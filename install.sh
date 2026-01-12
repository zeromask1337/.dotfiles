#!/usr/bin/env bash
set -euo pipefail

# Bootstrap installer for dotfiles + brew + packages
# Usage: ./install.sh [--yes] [--dry-run] [--only step1,step2] [--skip step] [--dotfiles-repo URL] [--dotfiles-dir PATH] [--ssh-email EMAIL]

# ============================================================================
# Config + Defaults
# ============================================================================

DOTFILES_REPO="${DOTFILES_REPO:-git@github.com:zeromask1337/.dotfiles.git}"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
SSH_EMAIL="${SSH_EMAIL:-}"
SKIP_SSH_GITHUB_CHECK="${SKIP_SSH_GITHUB_CHECK:-0}"

OPT_YES=0
OPT_DRY_RUN=0
OPT_ONLY=""
OPT_SKIP=""

# Step registry (order enforced)
ALL_STEPS=(preflight ssh clone brew bundle stow postflight)

# ============================================================================
# Logging + Helpers
# ============================================================================

log() {
  printf "\033[0;34m==>\033[0m %s\n" "$*"
}

log_success() {
  printf "\033[0;32m✓\033[0m %s\n" "$*"
}

log_warn() {
  printf "\033[0;33m⚠\033[0m %s\n" "$*" >&2
}

die() {
  printf "\033[0;31mERROR:\033[0m %s\n" "$*" >&2
  exit 1
}

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "required command not found: $1"
}

is_macos() {
  [[ "$OSTYPE" == darwin* ]]
}

is_linux() {
  [[ "$OSTYPE" == linux* ]]
}

has_brew() {
  command -v brew >/dev/null 2>&1
}

run() {
  if [[ "$OPT_DRY_RUN" -eq 1 ]]; then
    log "[dry-run] $*"
    return 0
  fi
  "$@"
}

confirm() {
  if [[ "$OPT_YES" -eq 1 ]]; then
    return 0
  fi
  read -rp "$* (y/N) " answer
  [[ "$answer" =~ ^[Yy] ]]
}

# ============================================================================
# Step Runner
# ============================================================================

run_step() {
  local name="$1"
  local fn="$2"
  
  log "Running step: $name"
  if "$fn"; then
    log_success "Step completed: $name"
  else
    die "Step failed: $name"
  fi
}

should_run_step() {
  local step="$1"
  
  # Check --skip
  if [[ -n "$OPT_SKIP" ]]; then
    local skip_list="${OPT_SKIP//,/ }"
    for s in $skip_list; do
      if [[ "$s" == "$step" ]]; then
        return 1
      fi
    done
  fi
  
  # Check --only (if set, only run listed steps)
  if [[ -n "$OPT_ONLY" ]]; then
    local only_list="${OPT_ONLY//,/ }"
    for s in $only_list; do
      if [[ "$s" == "$step" ]]; then
        return 0
      fi
    done
    return 1
  fi
  
  return 0
}

# ============================================================================
# Steps (to be implemented)
# ============================================================================

step_preflight() {
  log "Checking OS and prerequisites..."
  
  if is_macos; then
    log "Detected: macOS"
  elif is_linux; then
    log "Detected: Linux"
    # Install brew prerequisites via apt
    if confirm "Install Homebrew prerequisites via apt?"; then
      run sudo apt-get update
      run sudo apt-get install -y build-essential procps curl file git
    fi
  else
    die "Unsupported OS: $OSTYPE"
  fi
  
  need_cmd curl
  need_cmd git
  
  log_success "Preflight checks passed"
  return 0
}

step_ssh() {
  log "Verifying SSH authentication setup..."
  
  local has_key=0
  local has_agent=0
  
  # Check for SSH key files
  if [[ -f "$HOME/.ssh/id_ed25519" || -f "$HOME/.ssh/id_rsa" || -f "$HOME/.ssh/id_ecdsa" ]]; then
    log "Found SSH private key"
    has_key=1
  fi
  
  # Check for SSH agent with loaded keys
  if [[ -n "${SSH_AUTH_SOCK:-}" ]] && command -v ssh-add >/dev/null 2>&1; then
    if ssh-add -l >/dev/null 2>&1; then
      log "SSH agent has loaded keys"
      has_agent=1
    fi
  fi
  
  if [[ $has_key -eq 0 && $has_agent -eq 0 ]]; then
    die "No SSH key found. Please generate one manually:\n  ssh-keygen -t ed25519 -C \"your-email@example.com\"\nThen add to GitHub: https://github.com/settings/keys"
  fi
  
  # Skip GitHub verification in CI mode
  if [[ "$SKIP_SSH_GITHUB_CHECK" -eq 1 ]]; then
    log_success "SSH setup verified (GitHub check skipped in CI mode)"
    return 0
  fi
  
  # Verify GitHub access
  log "Verifying GitHub SSH access..."
  if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
    log_success "GitHub SSH authentication successful"
  else
    die "Cannot authenticate with GitHub. Ensure your SSH key is added:\n  https://github.com/settings/keys\nOr verify with: ssh -T git@github.com"
  fi
  
  return 0
}

step_brew() {
  log "Installing Homebrew..."
  
  if has_brew; then
    log "Homebrew already installed"
  else
    local brew_install_url="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
    run bash -c "$(curl -fsSL "$brew_install_url")"
  fi
  
  # Ensure brew is in PATH for current session
  if is_macos; then
    eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv 2>/dev/null)"
  elif is_linux; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi
  
  has_brew || die "Homebrew installation failed"
  log_success "Homebrew ready: $(command -v brew)"
  return 0
}

step_bundle() {
  log "Installing packages from Brewfile..."
  
  local brewfile="$DOTFILES_DIR/.Brewfile"
  
  if [[ ! -f "$brewfile" ]]; then
    log_warn "Brewfile not found: $brewfile (skipping)"
    return 0
  fi
  
  if is_linux; then
    # Filter out cask lines for Linux
    local tmp_brewfile="/tmp/Brewfile.linux.$$"
    grep -v '^cask ' "$brewfile" > "$tmp_brewfile"
    log "Using filtered Brewfile for Linux (casks removed)"
    run brew bundle --file="$tmp_brewfile" || log_warn "Some packages failed (continuing)"
    rm -f "$tmp_brewfile"
  else
    run brew bundle --file="$brewfile" || log_warn "Some packages failed (continuing)"
  fi
  
  log_success "Package installation completed"
  return 0
}

step_clone() {
  log "Cloning dotfiles repository..."
  
  if [[ -d "$DOTFILES_DIR/.git" ]]; then
    log "Dotfiles already cloned; updating..."
    run git -C "$DOTFILES_DIR" pull --recurse-submodules
  else
    run git clone --recurse-submodules "$DOTFILES_REPO" "$DOTFILES_DIR"
  fi
  
  run git -C "$DOTFILES_DIR" submodule update --init --recursive
  log_success "Dotfiles ready: $DOTFILES_DIR"
  return 0
}

step_stow() {
  log "Linking dotfiles with stow..."
  
  if ! command -v stow >/dev/null 2>&1; then
    log_warn "stow not found; skipping"
    return 0
  fi
  
  run bash -c "cd '$DOTFILES_DIR' && stow --restow ."
  log_success "Dotfiles linked via stow"
  return 0
}

step_postflight() {
  log_success "Installation complete!"
  echo
  log "Next steps:"
  log "  1. Restart your shell or run: exec \$SHELL"
  log "  2. (Optional) Run: brew doctor"
  log "  3. Check installed tools: nvim, tmux, fzf, etc."
  return 0
}

# ============================================================================
# CLI Parsing
# ============================================================================

usage() {
  cat <<EOF
Usage: $0 [OPTIONS]

Options:
  --yes                 Non-interactive mode (auto-confirm)
  --dry-run             Show what would be done without executing
  --only STEPS          Run only specified steps (comma-separated)
  --skip STEPS          Skip specified steps (comma-separated)
  --dotfiles-repo URL   Override dotfiles repo URL (default: $DOTFILES_REPO)
  --dotfiles-dir PATH   Override dotfiles install dir (default: $DOTFILES_DIR)
  --ssh-email EMAIL     Email for SSH key generation
  --list-steps          List available steps and exit
  -h, --help            Show this help

Environment variables:
  SKIP_SSH_GITHUB_CHECK=1    Skip GitHub SSH verification (CI mode)
  DOTFILES_REPO              Same as --dotfiles-repo
  DOTFILES_DIR               Same as --dotfiles-dir
  SSH_EMAIL                  Same as --ssh-email

Available steps (in order):
  ${ALL_STEPS[*]}

Examples:
  $0 --yes
  $0 --dry-run
  $0 --only ssh,brew
  $0 --skip stow
  $0 --dotfiles-repo git@github.com:user/dotfiles.git
EOF
}

list_steps() {
  echo "Available steps (in order):"
  for step in "${ALL_STEPS[@]}"; do
    echo "  - $step"
  done
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --yes)
        OPT_YES=1
        shift
        ;;
      --dry-run)
        OPT_DRY_RUN=1
        shift
        ;;
      --only)
        OPT_ONLY="$2"
        shift 2
        ;;
      --skip)
        OPT_SKIP="${OPT_SKIP:+$OPT_SKIP,}$2"
        shift 2
        ;;
      --dotfiles-repo)
        DOTFILES_REPO="$2"
        shift 2
        ;;
      --dotfiles-dir)
        DOTFILES_DIR="$2"
        shift 2
        ;;
      --ssh-email)
        SSH_EMAIL="$2"
        shift 2
        ;;
      --list-steps)
        list_steps
        exit 0
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        die "Unknown option: $1 (use --help for usage)"
        ;;
    esac
  done
  
  # Validate --only steps
  if [[ -n "$OPT_ONLY" ]]; then
    local only_list="${OPT_ONLY//,/ }"
    for step in $only_list; do
      local valid=0
      for known in "${ALL_STEPS[@]}"; do
        if [[ "$step" == "$known" ]]; then
          valid=1
          break
        fi
      done
      if [[ "$valid" -eq 0 ]]; then
        die "Invalid step in --only: $step (use --list-steps to see available steps)"
      fi
    done
  fi
}

# ============================================================================
# Main
# ============================================================================

main() {
  parse_args "$@"
  
  log "Dotfiles Bootstrap Installer"
  log "Repo: $DOTFILES_REPO"
  log "Target: $DOTFILES_DIR"
  echo
  
  for step in "${ALL_STEPS[@]}"; do
    if should_run_step "$step"; then
      run_step "$step" "step_$step"
    else
      log "Skipping step: $step"
    fi
  done
  
  echo
  log_success "All steps completed!"
}

main "$@"
