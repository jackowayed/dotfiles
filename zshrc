autoload -U colors && colors
setopt PROMPT_SUBST

# Colors for ls and completion: must be set before completion setup below,
# since `list-colors` expands LS_COLORS at definition time.
# BSD/macOS ls uses CLICOLOR/LSCOLORS; GNU ls and zsh completion use LS_COLORS.
export CLICOLOR=1
export LSCOLORS=Exfxcxdxbxegedabagacad
if (( $+commands[dircolors] )); then
  eval "$(dircolors -b)"
else
  # Fallback so completions still colorize on systems without dircolors (stock macOS/BSD)
  export LS_COLORS=${LS_COLORS:-'di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'}
fi

# Tab completion
#

# Look for personal completion functions next to this file. Add a `_tool` file
# there (starting with `#compdef tool`) to teach zsh about another command.
typeset -g DOTFILES_DIR=${${(%):-%N}:A:h}
fpath=("$DOTFILES_DIR/completions" $fpath)

# Completion module for menuselect keymap
zmodload -i zsh/complist
# Don't auto-insert first match; show menu on second tab instead
unsetopt menu_complete
unsetopt flowcontrol
setopt auto_menu
# Allow completion from within a word (not just at the end)
setopt complete_in_word
# Move cursor to end of word after completing
setopt always_to_end
# Let compinit refresh its dump when completion files are added or removed.
autoload -Uz compinit && compinit -d ~/.zcompdump-${HOST}-${ZSH_VERSION}
# Arrow-key interactive menu when multiple matches exist
zstyle ':completion:*:*:*:*:*' menu select
# Case-insensitive, then partial-word, then substring matching
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|=*' 'l:|=* r:|=*'
# Complete . and .. as directories
zstyle ':completion:*' special-dirs true
# Use LS_COLORS for completion listings (dirs, symlinks, executables, etc.)
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# Color-coded process list for kill completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USERNAME -o pid,user,comm -w -w"
# cd completes local dirs first, then dirstack, then $PATH dirs
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
# Cache completions for slow commands (e.g. brew, npm)
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path ~/.zcompcache
# In menu, ^o accepts current match and starts completing the next path component
bindkey -M menuselect '^o' accept-and-infer-next-history
# Load bash-style completions for tools that only ship those
autoload -U +X bashcompinit && bashcompinit

# Git branch in prompt via built-in vcs_info (replaces oh-my-zsh)
autoload -Uz vcs_info
precmd() { vcs_info }
# Normal: ‹branch›  During rebase/merge: ‹branch|action›
zstyle ':vcs_info:git:*' formats '%F{yellow}‹%b›%f '
zstyle ':vcs_info:git:*' actionformats '%F{yellow}‹%b|%a›%f '

# Prompt: green cwd, yellow git branch, bold $. Show exit code on right on failure.
local return_code="%(?..%F{red}%? ↵%f)"
PROMPT='%F{green}%~%f ${vcs_info_msg_0_}%B$%b '
RPROMPT="${return_code}"

# ls alias: use colors to differentiate directories, symlinks, executables, etc.
# (CLICOLOR/LSCOLORS/LS_COLORS are set at the top of this file.)
if ls --version >/dev/null 2>&1; then
  # GNU ls (Linux, or Homebrew coreutils on macOS)
  alias ls='ls --color=auto'
elif (( $+commands[gls] )); then
  # Homebrew coreutils without dircolors in PATH shadowing
  alias ls='gls --color=auto'
else
  # BSD ls (default macOS): -G enables CLICOLOR/LSCOLORS
  alias ls='ls -G'
fi

alias emacsclient="/Applications/Emacs.app/Contents/MacOS/bin/emacsclient"
alias e="emacsclient -n"
alias em="emacs"
alias f="say finished"
alias g="git"

CLASSPATH=$CLASSPATH:/usr/local/Cellar/clojure-contrib/1.1.0/clojure-contrib.jar

PATH=$PATH:~/bin

eval "$(/opt/homebrew/bin/brew shellenv)"

source ~/.zshprivate
export PATH="$HOME/.local/bin:$PATH"
