# Docker Integration Tests

Test the bootstrap installer in isolated Ubuntu containers.

## Prerequisites

- Docker installed and running
- SSH agent running with your GitHub key loaded (for clone tests)
  ```bash
  # Check if agent is running and has keys
  ssh-add -l
  ```

## Quick Start

```bash
# Build image and run all tests
./tests/docker/test-runner.sh all

# Or just build the image
./tests/docker/test-runner.sh build

# Test individual steps
./tests/docker/test-runner.sh step preflight
./tests/docker/test-runner.sh step brew

# Test cumulative prefixes (order/dependency tests)
./tests/docker/test-runner.sh prefix "preflight,ssh,brew"
./tests/docker/test-runner.sh all-prefixes
```

## Test Types

### Per-Step Tests (Isolated)
Tests each step in a fresh container to verify it works standalone.
```bash
./tests/docker/test-runner.sh all-steps
```

### Prefix Tests (Cumulative)
Tests step sequences to catch hidden dependencies (PATH, env vars, etc).
```bash
./tests/docker/test-runner.sh all-prefixes
```

Runs:
- `preflight`
- `preflight,ssh`
- `preflight,ssh,brew`
- `preflight,ssh,brew,bundle`
- `preflight,ssh,brew,bundle,clone`
- `preflight,ssh,brew,bundle,clone,stow`

## SSH Agent Mount

The test runner auto-detects your SSH agent socket:
- **Linux**: Uses `$SSH_AUTH_SOCK`
- **macOS Docker Desktop**: Uses `/run/host-services/ssh-auth.sock`

This allows the `clone` step to authenticate with GitHub using your existing SSH keys without copying them into containers.

## Notes

- All tests run with `SKIP_SSH_GITHUB_CHECK=1` (tests keygen but skips interactive GitHub verification)
- Brew installation is slow (~5min); prefixes run incrementally to save time
- On Linux hosts with cask-only packages in `.Brewfile`, expect warnings (handled gracefully)
