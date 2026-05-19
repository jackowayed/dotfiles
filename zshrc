autoload -U colors && colors
setopt PROMPT_SUBST

# Tab completion
#

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
autoload -Uz compinit && compinit -C -d ~/.zcompdump-${HOST}-${ZSH_VERSION}
# Arrow-key interactive menu when multiple matches exist
zstyle ':completion:*:*:*:*:*' menu select
# Case-insensitive, then partial-word, then substring matching
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|=*' 'l:|=* r:|=*'
# Complete . and .. as directories
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' list-colors ''
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
