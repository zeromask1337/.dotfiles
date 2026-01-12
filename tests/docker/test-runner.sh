#!/usr/bin/env bash
# Test runner for Docker-based integration tests
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

IMAGE_NAME="dotfiles-test"
CONTAINER_NAME="dotfiles-test-run"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log() {
  echo -e "${BLUE}==>${NC} $*"
}

log_success() {
  echo -e "${GREEN}✓${NC} $*"
}

log_error() {
  echo -e "${RED}✗${NC} $*" >&2
}

log_warn() {
  echo -e "${YELLOW}⚠${NC} $*"
}

die() {
  log_error "$*"
  exit 1
}

# Build test image
build_image() {
  log "Building test image: $IMAGE_NAME"
  docker build -t "$IMAGE_NAME" "$SCRIPT_DIR" || die "Failed to build image"
  log_success "Image built: $IMAGE_NAME"
}

# Run container with SSH mount
run_container() {
  local steps="$1"
  
  local docker_args=(
    --rm
    -v "$REPO_ROOT:/work"
    -w /work
    -e SKIP_SSH_GITHUB_CHECK=1
    -e DOTFILES_DIR=/home/test/.dotfiles
    -e DOTFILES_REPO=/work
    -v "$HOME/.ssh:/home/test/.ssh:ro"
  )
  
  log "Mounting ~/.ssh read-only"
  
  log "Running: install.sh --yes --only $steps"
  docker run "${docker_args[@]}" "$IMAGE_NAME" \
    bash -c "./install.sh --yes --only $steps"
}

# Test individual step
test_step() {
  local step="$1"
  log "Testing step: $step"
  
  if run_container "$step"; then
    log_success "Step passed: $step"
    return 0
  else
    log_error "Step failed: $step"
    return 1
  fi
}

# Test prefix (cumulative steps)
test_prefix() {
  local prefix="$1"
  log "Testing prefix: $prefix"
  
  if run_container "$prefix"; then
    log_success "Prefix passed: $prefix"
    return 0
  else
    log_error "Prefix failed: $prefix"
    return 1
  fi
}

# Run all per-step tests
test_all_steps() {
  local steps=(preflight ssh brew bundle clone stow)
  local failed=0
  
  log "Running per-step tests..."
  echo
  
  for step in "${steps[@]}"; do
    if ! test_step "$step"; then
      ((failed++))
    fi
    echo
  done
  
  if [[ $failed -eq 0 ]]; then
    log_success "All per-step tests passed"
    return 0
  else
    log_error "$failed step(s) failed"
    return 1
  fi
}

# Run prefix tests (cumulative)
test_all_prefixes() {
  local prefixes=(
    "preflight"
    "preflight,ssh"
    "preflight,ssh,clone"
    "preflight,ssh,clone,brew"
    "preflight,ssh,clone,brew,bundle"
    "preflight,ssh,clone,brew,bundle,stow"
  )
  local failed=0
  
  log "Running prefix tests..."
  echo
  
  for prefix in "${prefixes[@]}"; do
    if ! test_prefix "$prefix"; then
      ((failed++))
    fi
    echo
  done
  
  if [[ $failed -eq 0 ]]; then
    log_success "All prefix tests passed"
    return 0
  else
    log_error "$failed prefix(es) failed"
    return 1
  fi
}

# Main
usage() {
  cat <<EOF
Usage: $0 [COMMAND]

Commands:
  build              Build test Docker image
  step STEP          Test individual step
  prefix PREFIX      Test prefix (e.g., "preflight,ssh,brew")
  all-steps          Test all steps individually
  all-prefixes       Test all cumulative prefixes
  all                Build + test all steps + all prefixes
  
Examples:
  $0 build
  $0 step preflight
  $0 prefix "preflight,ssh,brew"
  $0 all-steps
  $0 all-prefixes
  $0 all
EOF
}

main() {
  if [[ $# -eq 0 ]]; then
    usage
    exit 0
  fi
  
  local cmd="$1"
  shift
  
  case "$cmd" in
    build)
      build_image
      ;;
    step)
      [[ $# -eq 1 ]] || die "Usage: $0 step STEP"
      build_image
      test_step "$1"
      ;;
    prefix)
      [[ $# -eq 1 ]] || die "Usage: $0 prefix PREFIX"
      build_image
      test_prefix "$1"
      ;;
    all-steps)
      build_image
      test_all_steps
      ;;
    all-prefixes)
      build_image
      test_all_prefixes
      ;;
    all)
      build_image
      echo
      test_all_steps
      echo
      test_all_prefixes
      ;;
    *)
      usage
      die "Unknown command: $cmd"
      ;;
  esac
}

main "$@"
