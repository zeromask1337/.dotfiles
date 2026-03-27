**AGENTS.md — Code Agent Guidelines**

- **Purpose**: provide build, lint, test commands and code-style rules for this repo.
- **Single Test**: run via test harness, e.g. `./tests/run_test.sh --single path/to/test.lua`.
- **Build**: format with `stylua .` and verify with `stylua --check .`.
- **Lint**: run `luacheck lua/` if available; otherwise rely on Neovim health checks.
- **Tests**: add tests under `lua/tests` when introducing new features.
- **Formatting**: follow `.stylua.toml` (160 columns, spaces, Unix endings).
- **Typing**: use LuaDoc annotations (`---@param`, `@return`) where possible.
- **Imports**: prefer explicit `local foo = require('bar')`, avoid globals.
- **Naming**: modules CamelCase; locals snake_case; file names lowercase.
- **Errors**: propagate errors with context; avoid swallowing.
- **Cursor Rules**: none detected in `.cursor` or `.cursorrules`.
- **Copilot Rules**: no `.github/copilot-instructions.md` present.
- **Tests**: keep changes surgical; add non-regression tests where feasible.
- **Versioning**: do not modify git config; commit only when requested.
- **Review**: follow project style; update docs as needed.
- **Delivery**: provide a concise summary and next steps.
- **Location**: this file lives at `/Users/flippy/.dotfiles/.config/nvim/AGENTS.md`.
- End.