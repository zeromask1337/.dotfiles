---
name: real-profile-browsing
description: Use when browsing as the user — their real Chrome logins, cookies, sessions, IP. Account-gated pages, paywalls, sites that reject fresh profiles. Covers the agent-browser-profile helper (copy profile → launch real Chrome → attach agent-browser over CDP) and why agent-browser's built-in --profile loses login on follow-up commands (fix: AGENT_BROWSER_CONFIG/AGENT_BROWSER_PROFILE).
---

# Real-profile browsing (macOS + Linux)

Driving the user's own Chrome/Chromium state — cookies, logins, extensions — so account-gated sites work.

Platform paths: macOS = `/Applications/Google Chrome.app/Contents/MacOS/Google Chrome` + `~/Library/Application Support/Google/Chrome`; Linux = `/usr/bin/chromium` + `~/.config/chromium`. The helper detects the OS; on macOS it needs Full Disk Access.

## The one-line reality

`agent-browser --profile Default` **works** (copies profile, launches real Chrome from `~/.agent-browser/config.json` `executablePath`, omits `--use-mock-keychain` → cookies decrypt). The trap: launch options are **per invocation**. A follow-up command without `--profile` makes the daemon relaunch a clean Chrome (temp dir + `--use-mock-keychain` + `--password-store=basic`) → logged out, `about:blank`, 0 cookies.

Trap fixed by export in `.zprofile` (Linux branch points at `real-profile.linux.json`, same keys):

```bash
export AGENT_BROWSER_CONFIG=$HOME/.config/agent-browser/real-profile.json   # macOS
export AGENT_BROWSER_CONFIG=$HOME/.config/agent-browser/real-profile.linux.json   # Linux
```

Already exported for login shells (Terminal/Ghostty). So:

```bash
agent-browser --session me open https://mail.google.com
agent-browser --session me snapshot -i
agent-browser --session me close
```

Opt out per command with `env -u AGENT_BROWSER_CONFIG agent-browser ...` for anonymous/isolated browsing (`AGENT_BROWSER_CONFIG=` errors). Needed for tests that must not see real logins. Each profiled launch costs a real-profile copy (~240MB, temp dir), so keep sessions short-lived.

Alt (below): helper script, headed real Chrome on full copy + `--cdp`.

The working mechanism is Hermes' one: **copy the profile directory, launch the real Chrome binary on the copy with `--remote-debugging-port=0`, attach agent-browser via `--cdp`**. Same binary ⇒ same keychain key ⇒ cookies decrypt.

## Helper

```bash
agent-browser-profile start          # copy profile, launch Chrome, print CDP port
agent-browser-profile port           # print the port
agent-browser-profile stop           # kill the copy's Chrome, delete the copy
agent-browser-profile attach open X  # prints: --cdp PORT open X
```

Lives at `~/.dotfiles/.config/scripts/agent-browser-profile` (on PATH via `.zshrc`).

Typical agent flow:

```bash
agent-browser-profile start
PORT=$(agent-browser-profile port)
agent-browser --cdp "$PORT" open https://example.com/account
agent-browser --cdp "$PORT" snapshot -i
# ... work ...
agent-browser --cdp "$PORT" close --all
agent-browser-profile stop
```

## Pitfalls

- **Headed vs headless.** The helper is headless on Linux and headed on macOS; override with `AGENT_BROWSER_PROFILE_HEADED=1|0`. Plain `agent-browser` (incl. the `AGENT_BROWSER_CONFIG` profile copy) is always `--headless=new`, so no window appears. Either way the user's own browser stays untouched and can run at the same time.
- **Full Disk Access (macOS).** Copying the profile needs FDA on the app hosting the agent (Ghostty/Terminal/iTerm). Without it: `Operation not permitted` on `~/Library/Application Support/Google/Chrome`. Fix in System Settings → Privacy & Security → Full Disk Access. Do not loop on the error — report the missing grant.
- **CDP attach needs an explicit tab when a session existed before attach.** After `--cdp PORT`, list tabs first (`agent-browser --cdp PORT tab list`) and switch with `tab tN` before evaluating, or evaluations land on `about:blank`.
- **Session hygiene.** Give attached work a named session (`--session <name>`); do not touch the anonymous default session.
- **`stop` when done.** It kills only the copy's Chrome and removes the copy. Leaving it running burns CPU and disk (profile copies are hundreds of MB).
- **One copy at a time.** `start` refuses while a copy is running (`stop` first).
- **Private data rule.** Never echo cookie values, tokens, page bodies, or account identifiers. Verify state with counts and booleans (e.g. `Storage.getCookies` count, presence of `logged_in`), not contents.
