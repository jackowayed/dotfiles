# Dotfiles

My configs for zsh, Hammerspoon, Git, and macOS text key bindings. The other
files in this repo are vestigial and aren't part of this setup.

## Symlink the configs

Clone this repo wherever you want to keep it, then run the following **from the
repo root**. The links use absolute paths, so keep the checkout in that location.

| Config | Repo file | Symlink |
| --- | --- | --- |
| zsh | `zshrc` | `~/.zshrc` |
| Hammerspoon | `hammerspoon-init.lua` | `~/.hammerspoon/init.lua` |
| Git | `gitconfig` | `~/.gitconfig` |
| macOS key bindings | `DefaultKeyBinding.dict` | `~/Library/KeyBindings/DefaultKeyBinding.dict` |

First, move any existing configs out of the way. This saves them in a fresh
backup directory and also handles existing symlinks:

```sh
backup_dir=$(mktemp -d "$HOME/dotfiles-backup.XXXXXX")
for config in "$HOME/.zshrc" "$HOME/.hammerspoon/init.lua" "$HOME/.gitconfig" \
  "$HOME/Library/KeyBindings/DefaultKeyBinding.dict"; do
  if [ -e "$config" ] || [ -L "$config" ]; then
    mv "$config" "$backup_dir/$(basename "$config")"
  fi
done
echo "Previous configs saved to $backup_dir"
```

Then create the links:

```sh
dotfiles_dir=$(pwd -P)
mkdir -p "$HOME/.hammerspoon" "$HOME/Library/KeyBindings"
ln -s "$dotfiles_dir/zshrc" "$HOME/.zshrc"
ln -s "$dotfiles_dir/hammerspoon-init.lua" "$HOME/.hammerspoon/init.lua"
ln -s "$dotfiles_dir/gitconfig" "$HOME/.gitconfig"
ln -s "$dotfiles_dir/DefaultKeyBinding.dict" "$HOME/Library/KeyBindings/DefaultKeyBinding.dict"
```

Only Hammerspoon's `init.lua` is linked, leaving room for local files and Spoons
in `~/.hammerspoon`. Edits through any of these links change the repo files.

## zsh

The config uses zsh's built-in completion and Git prompt support; no Oh My Zsh
installation is needed. It finds the repo's `completions/` directory through the
symlink, so that directory doesn't need its own link.

The config loads Homebrew via `brew shellenv` if Homebrew is installed, checking
the usual Apple Silicon prefix (`/opt/homebrew`) and then `brew` on `PATH`. It
also sources `~/.zshprivate` if present, so keep machine-specific settings
there. Both are optional; no setup is needed on a new machine.

## Hammerspoon

Install [Hammerspoon](https://www.hammerspoon.org/), open it, and grant it
Accessibility access when prompted. Choose **Reload Config** from its menu
after creating the link or editing the config.

Window shortcuts use **Option + Control + Command** (for example, `m` maximizes
the focused window). **Control + Command + Space** opens the app launcher.
App names and shortcuts are defined in `hammerspoon-init.lua`.

Optional local additions:

- `~/.hammerspoon/work.lua` is loaded if present.
- `~/.hammerspoon/office-ips.txt` lists office public IPs, one per line, for
  muting audio after Zoom calls at the office. Without it, that timer is disabled.
- The launcher TODO shortcuts expect a separate `~/bin/save-todo` script.
- The BingDaily Spoon is loaded if installed.

## Git

Git picks up `~/.gitconfig` automatically. Review the identity and machine-specific
settings in `gitconfig`: `[user]`, `[github]`, and especially
`core.excludesfile`, which currently points to `/Users/daniel/.gitignore`.
Set that path to your own global ignore file if needed; the repo's `.gitignore`
isn't linked by these instructions.

Check that Git is reading the linked config:

```sh
git config --global --show-origin --list
```

## macOS key bindings

`DefaultKeyBinding.dict` adds Emacs-style text editing shortcuts in apps that
use macOS's standard text system, including **Option + f/b** to move by word
and **Control + a/e** to move to the beginning/end of a line. Apps with their
own text editors may ignore these bindings.

Quit and reopen affected apps after creating the link or editing the file.
