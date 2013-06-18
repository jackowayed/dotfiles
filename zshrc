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

# Customize to your needs...
export PATH=/Users/daniel/Downloads/adt-bundle-mac-x86_64-20130514/sdk/tools:/Users/daniel/Downloads/adt-bundle-mac-x86_64-20130514/sdk/platform-tools:/Users/daniel/Downloads/adt-bundle-mac-x86_64-20130514/sdk/build-tools/android-4.2.2:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin:/opt/nginx/sbin:/Users/daniel/code/android/sdk/tools:/Users/daniel/.jruby/bin:/Users/daniel/bin:/usr/local/Cellar/python/2.7/bin

#autojump
#Copyright Joel Schaerer 2008, 2009
#This file is part of autojump

#autojump is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.
#
#autojump is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with autojump.  If not, see <http://www.gnu.org/licenses/>.

function autojump_preexec() {
    { (autojump -a "$(pwd -P)"&)>/dev/null 2>>|${HOME}/.autojump_errors ; } 2>/dev/null
}

typeset -ga preexec_functions
preexec_functions+=autojump_preexec

alias jumpstat="autojump --stat"

function j { local new_path="$(autojump $@)";if [ -n "$new_path" ]; then echo -e "\\033[31m${new_path}\\033[0m"; cd "$new_path";fi }


alias n1="emulator -avd nexus -logcat ."
alias froyo="emulator -avd froyo -logcat ."

alias edge_ruboto="ruby -rubygems ~/code/android/ruboto-core/bin/ruboto"

alias e="emacsclient -n"
alias em="emacs"
alias f="say finished"

export EC2_HOME=~/.ec2
export PATH=$PATH:$EC2_HOME/bin
export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Home/
export GOPATH=~/.golibs/


CLASSPATH=$CLASSPATH:/usr/local/Cellar/clojure-contrib/1.1.0/clojure-contrib.jar

source ~/.zshprivate

if [[ -s /Users/daniel/.rvm/scripts/rvm ]] ; then source /Users/daniel/.rvm/scripts/rvm ; fi

alias ori="~/code/ori/build/ori/ori"
alias orifs="~/code/ori/build/orifs/orifs"
