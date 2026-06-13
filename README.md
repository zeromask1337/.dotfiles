# Setup
Clone this repo into your home folder, cd into it and run `stow .`.

Then install lefthook and activate the hooks:
```sh
brew install lefthook
lefthook install
```

# QA
## What if I need specific folder from `.config`?
To do this you need to fork this repo first. Then read example, it shows how you can download only `nvim` folder using `git sparse`.

```sh
git clone --filter=blob:none --sparse <repo-url> ~/.dotfiles
cd ~/.dotfiles
git sparse-checkout set .config/nvim
```

## How can I simplify scoping commits for various configs?

`lefthook` manages a `commit-msg` hook that automatically injects the correct `.config` scope into your commit message.

Example:

```sh
~/.dotfiles/.config/nvim:$ git commit -am "feat: add opencode plugin"
~/.dotfiles/.config/nvim:$ git log

commit 0af08aa7f00000f22eb300000f156753648831be (HEAD -> master, origin/master, origin/HEAD)
Author: flippy <example@gmail.com>
Date:   Fri Mar 27 16:25:46 2026 +0300

    feat(nvim): add opencode plugin
```
