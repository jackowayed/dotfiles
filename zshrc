# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.oh-my-zsh

# Set to the name theme to load.
# Look in ~/.oh-my-zsh/themes/
export ZSH_THEME="macovsky"

# Set to this to use case-sensitive completion
# export CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# export DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# export DISABLE_LS_COLORS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git) #brew) #rails)

source $ZSH/oh-my-zsh.sh

alias emacsclient="/Applications/Emacs.app/Contents/MacOS/bin/emacsclient"
alias e="emacsclient -n"
alias em="emacs"
alias f="say finished"
alias ghash="git log -n1 --pretty=format:'%h' | pbcopy"

CLASSPATH=$CLASSPATH:/usr/local/Cellar/clojure-contrib/1.1.0/clojure-contrib.jar

PATH=$PATH:~/bin

source ~/.zshprivate
alias glink="git --no-pager log --graph --pretty=format:'https://github.com/quip/quip/commit/%h %s' -n 1 | cut -c 3- | tee >&2 | pbcopy"

[ -s "/Users/danieljackoway/.scm_breeze/scm_breeze.sh" ] && source "/Users/danieljackoway/.scm_breeze/scm_breeze.sh"
