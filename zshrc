autoload -U colors && colors
setopt PROMPT_SUBST
# Enable zsh's tab-completion system (for git branches, commands, flags, etc.).
# Not on by default; oh-my-zsh used to handle this. -C and -d cache the scan for speed.
autoload -Uz compinit && compinit -C -d ~/.zcompdump-${HOST}-${ZSH_VERSION}

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
export PATH="$HOME/.local/bin:$PATH"

source ~/.zshprivate
