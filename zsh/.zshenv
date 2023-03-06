# Zsh root
export ZDOTDIR=$HOME/.config/zsh

# Zsh related
export HISTFILE=$ZDOTDIR/.history
export HISTSIZE=10000
export SAVEHIST=10000
export KEYTIMEOUT=1  # makes the switch between modes quicker

# PATH
export PATH=~/.composer/vendor/bin:$PATH
export PATH=~/.cargo/bin:$PATH
export PATH=~/go/bin:$PATH
if [[ "$(uname -sm)" = "Darwin arm64" ]] then export PATH=/opt/homebrew/bin:$PATH; fi

# Software specific
export EDITOR="nvim"
export VISUAL="nvim"
export HOMEBREW_NO_ANALYTICS=1

