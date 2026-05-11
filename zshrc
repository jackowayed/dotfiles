autoload -U colors && colors
setopt PROMPT_SUBST
autoload -Uz compinit && compinit -C -d ~/.zcompdump-${HOST}-${ZSH_VERSION}

export ZSH=$HOME/.oh-my-zsh
source $ZSH/lib/git.zsh
source $ZSH/themes/macovsky.zsh-theme

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
