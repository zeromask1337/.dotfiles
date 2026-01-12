# Dotfiles Bootstrap Installer

Automated installer for dotfiles, Homebrew, and CLI tools on macOS and Linux.

## Quick Start

### Fresh Machine Setup

```bash
# One-line install (interactive)
bash -c "$(curl -fsSL https://raw.githubusercontent.com/zeromask1337/.dotfiles/main/install.sh)"

# Or clone first, then run
git clone https://github.com/zeromask1337/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

### What It Does

1. **Preflight** - Detects OS, checks prerequisites
2. **SSH** - Generates SSH key for GitHub (if needed)
3. **Clone** - Clones/updates dotfiles repo with submodules
4. **Homebrew** - Installs Homebrew (macOS + Linux)
5. **Packages** - Installs all packages from `.Brewfile`
6. **Stow** - Symlinks configs to `$HOME` via GNU stow
7. **Postflight** - Prints next steps

## Usage

```bash
# Interactive (prompts for confirmations)
./install.sh

# Non-interactive (auto-yes)
./install.sh --yes

# Dry-run (show what would happen)
./install.sh --dry-run

# Run only specific steps
./install.sh --only preflight,brew,bundle

# Skip steps
./install.sh --skip ssh,stow

# Custom dotfiles repo
./install.sh --dotfiles-repo git@github.com:you/dotfiles.git

# Custom install directory
./install.sh --dotfiles-dir ~/my-dotfiles

# Provide email for SSH key
./install.sh --ssh-email "me@example.com"

# List available steps
./install.sh --list-steps
```

## Flags

| Flag | Description |
|------|-------------|
| `--yes` | Non-interactive mode (auto-confirm) |
| `--dry-run` | Show commands without executing |
| `--only STEPS` | Run only specified steps (comma-separated) |
| `--skip STEPS` | Skip specified steps |
| `--dotfiles-repo URL` | Override dotfiles repo URL |
| `--dotfiles-dir PATH` | Override install directory |
| `--ssh-email EMAIL` | Email for SSH key generation |
| `--list-steps` | List available steps and exit |
| `-h, --help` | Show help |

## Environment Variables

| Variable | Description |
|----------|-------------|
| `SKIP_SSH_GITHUB_CHECK=1` | Skip GitHub SSH verification (CI mode) |
| `DOTFILES_REPO` | Same as `--dotfiles-repo` |
| `DOTFILES_DIR` | Same as `--dotfiles-dir` |
| `SSH_EMAIL` | Same as `--ssh-email` |

## Available Steps

1. `preflight` - OS detection + prerequisites
2. `ssh` - SSH key generation + GitHub setup
3. `clone` - Clone/update dotfiles repo
4. `brew` - Homebrew installation
5. `bundle` - Install packages from `.Brewfile`
6. `stow` - Symlink dotfiles to `$HOME`
7. `postflight` - Final instructions

## Testing

### Docker Integration Tests

Test the installer in isolated Ubuntu containers:

```bash
# Build image and run all tests
./tests/docker/test-runner.sh all

# Test individual steps
./tests/docker/test-runner.sh step preflight
./tests/docker/test-runner.sh step brew

# Test cumulative prefixes (dependency/order tests)
./tests/docker/test-runner.sh all-prefixes
```

See [tests/docker/README.md](tests/docker/README.md) for details.

### Prerequisites for Testing

- Docker installed and running
- SSH agent with GitHub key loaded (for clone tests):
  ```bash
  ssh-add -l  # Should show your key
  ```

## Platform Support

### macOS
- Full support: taps, brews, casks
- Uses `/opt/homebrew` (Apple Silicon) or `/usr/local` (Intel)

### Linux (Ubuntu/Debian)
- Homebrew installed to `/home/linuxbrew/.linuxbrew`
- Casks skipped automatically (not supported on Linux)
- Brew prerequisites installed via `apt`

## Re-running

The installer is **idempotent** - safe to run multiple times:
- Won't regenerate SSH keys if they exist
- Won't reinstall Homebrew if present
- `git pull` instead of re-cloning
- Stow uses `--restow` for safe relinking

## Troubleshooting

### SSH Key Not Working
```bash
# Verify key exists
ls -la ~/.ssh/id_ed25519*

# Check GitHub authentication
ssh -T git@github.com

# Add key to GitHub manually
cat ~/.ssh/id_ed25519.pub
# Copy and paste to: https://github.com/settings/keys
```

### Homebrew Not in PATH
```bash
# Reload shell config
exec $SHELL

# Or manually add to current session
eval "$(/opt/homebrew/bin/brew shellenv)"  # macOS
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"  # Linux
```

### Stow Conflicts
```bash
# Remove conflicting files first
rm ~/.zshrc  # or back up

# Then re-run stow
cd ~/.dotfiles && stow --restow .
```

## Development

### Adding New Steps

1. Add step name to `ALL_STEPS` array in `install.sh`
2. Implement `step_<name>()` function
3. Update tests in `tests/docker/test-runner.sh`
4. Update this README

### CI/CD

GitHub Actions runs on every push:
- Ubuntu: Full integration tests with Docker
- macOS: Smoke tests (dry-run mode)
- Linting: shellcheck validation

See [.github/workflows/test-bootstrap.yml](.github/workflows/test-bootstrap.yml)

## License

Same as parent dotfiles repo.
