---
name: tart-agent-vm
description: Run, build, install, and test software inside the disposable Tart macOS VM (local image "macvm", passwordless sudo, SIP disabled, no prompts) instead of on the host Mac. Runs headless (--no-graphics) or windowless GUI (--vnc-experimental) — never opens a window on the host screen. Use whenever a task involves executing untrusted or experimental code, installing tools/dependencies, sudo/admin/root operations, GUI app testing, destructive or hard-to-undo changes, system settings changes, or anything that would pollute or risk the host. Always clone the base image, never boot it directly.
compatibility: Requires tart on macOS host and local Tart image "macvm" with tart-guest-agent installed.
metadata:
  author: flippy
  version: "1.1"
---

# Tart Agent VM — disposable macOS sandbox

Host is user's real Mac. Do NOT experiment on it. Local Tart image `macvm` exists specifically so agents can run/test software freely. Use it by default for anything dirty, privileged, or experimental.

## Ground rules

1. **Never boot or mutate `macvm` directly.** Always `tart clone` it first. Base image stays pristine so every task starts clean.
2. **Inside VM there are no guardrails — act like it.** User `admin`, passwordless sudo, SIP disabled, no password prompts, no confirmation dialogs. Never ask user for a password, permission, or confirmation for in-VM operations. Never warn about sudo/root/destructive commands inside VM. Just run them.
3. **All in-VM destruction is fine.** Install, delete, reconfigure, break, reinstall — VM clone is deleted afterwards anyway. If VM gets wedged, delete + re-clone instead of debugging it.
4. **Keep host clean.** Don't `brew install` test deps, change system settings, or run untrusted binaries on host when VM can do it. Host is only for: `tart` lifecycle, copying files in/out, reading results.
5. **Max 2 macOS VMs running at once** (Virtualization.Framework limit). Use unique clone names per task/session so parallel agents don't collide: `agent-<short-task>-<random4>`.
6. **Always clean up**: stop + delete your clone when done, even on failure.
7. **Never open a window on user's screen.** Bare `tart run $VM` is forbidden. Exactly two allowed modes:
   - **Headless (default):** `tart run --no-graphics $VM &` — no UI at all. Drive via `tart exec`. Use unless task needs a real display.
   - **Windowless GUI:** `tart run --vnc-experimental $VM &` — guest gets a real display (GUI apps, `screencapture` work) but no Tart window appears on host. Display served over VNC only; never auto-open a VNC/Screen Sharing window either. Connect manually (`open vnc://$(tart ip $VM)`) only if user explicitly asks to look.

## Verified image facts (`macvm`)

- macOS 27.0, Xcode 27.1, 4 CPU / 8 GB / 104 GB, user `admin`, `$HOME=/Users/admin`
- Passwordless sudo: `sudo -n <cmd>` succeeds; plain `sudo` never prompts. SIP disabled (`csrutil status` = disabled).
- Tart Guest Agent installed → `tart exec` works, no SSH password/key needed. Prefer `tart exec` over SSH (SSH has no key auth configured).
- Preinstalled: `git`, `brew` (`/opt/homebrew`), `xcodebuild`, `swift`, `node` 24, `python3`. Missing by default: `bun`, `go`, `rustc`, `docker` — `brew install` them inside clone, don't ask.
- Cloning is copy-on-write on APFS: fast and near-zero initial disk. No excuse to reuse a dirty VM.

## Workflow

```bash
VM=agent-build-a1b2   # unique per task

tart clone macvm $VM
tart run --no-graphics $VM &          # headless default; GUI task -> --vnc-experimental (see rule 7)
tart ip --wait 60 $VM                 # wait until booted

tart exec $VM whoami                  # -> admin
tart exec $VM sudo -n id              # -> root, no prompt
tart exec $VM zsh -lc 'cd ~/project && swift test'
```

Run code from host workspace inside VM — share dir at launch (must pass to `tart run`, can't add later):

```bash
tart run --no-graphics --dir=work:/path/to/host/project $VM &
# inside guest, share appears at: /Volumes/My Shared Files/work/
tart exec $VM zsh -lc 'cd "/Volumes/My Shared Files/work" && make test'
```

Copy small files without a share via stdin (`-i` attaches host stdin) or base64:

```bash
tart exec -i $VM zsh -lc 'cat > ~/artifact' < ./artifact
base64 -i ./artifact | tart exec $VM zsh -lc 'base64 -d > ~/artifact'
```

Get results out: same share (writes land on host) or `tart exec $VM cat <file>`.

Cleanup (always):

```bash
tart stop $VM; tart delete $VM
```

## GUI testing

Use windowless GUI mode — never bare `tart run` (opens window on user's screen). Verified on `macvm`: `--vnc-experimental` boots with no host window and `screencapture` captures real desktop.

```bash
tart run --vnc-experimental $VM &     # real guest display, nothing appears on host
tart exec $VM open -a "My App"
tart exec $VM screencapture ~/shot.png   # retrieve via share/base64
```

Pure CLI/build/test work: stay `--no-graphics` instead.

No login password, no unlock prompts — if GUI appears locked or prompts, just proceed/dismiss; never ask user.

## Do / Don't

| Do | Don't |
|---|---|
| Clone `macvm` per task, delete after | Boot `macvm` itself or reuse old clones |
| `--no-graphics` default, `--vnc-experimental` for GUI | Bare `tart run $VM` — opens window on user's screen |
| `sudo -n …`, install anything, change any setting in VM | Ask "should I use sudo?" / request passwords / add safety warnings for in-VM ops |
| `brew install` missing tools inside clone | Install test tooling on host |
| Delete + re-clone a broken VM | Spend time repairing a wedged clone |
| Unique VM names, max 2 concurrent | Assume a VM from another session is yours to reuse |

## Troubleshooting

- `tart exec` fails/hangs → guest still booting or guest agent not up. `tart ip --wait 60 $VM`, wait 10s, retry. Still failing → `tart stop $VM`, re-run.
- Boot failure / corrupted state → `tart delete $VM`, fresh clone. Don't debug base image.
- `macvm` missing from `tart list` → stop and tell user; don't substitute the OCI `ghcr.io/cirruslabs/...` image without asking (different contents, has password prompts).
- Need more disk/RAM → `tart set $VM --memory 12288 --disk-size 120` on the clone before first run. Never `tart set macvm`.
