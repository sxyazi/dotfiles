setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS

# Alias
alias -g ..="cd .."
alias -g ...="cd ../.."

alias p="pwd"
alias o="open ."
alias l="exa --icons --group-directories-first"
alias ls="exa -al --icons --group-directories-first"
alias vim="nvim"
alias cat="bat --theme Dracula"
alias ssh="kitty +kitten ssh"
alias du="dust -r -n 999999999"
alias icpng="mkdir converted-images; sips -s format png * --out converted-images"
alias icjpg="mkdir converted-images; sips -s format jpeg * --out converted-images"

alias gs="git status"
alias ga="git add -A"
alias gc="git commit -v"
alias gc!="git commit -v --amend --no-edit"
alias gl="git pull"
alias gp="git push"
alias gp!="git push --force"
alias gcl="git clone"
alias gf='git fetch --all'
alias gb="git branch"
alias gr="git rebase"
alias gt='cd "$(git rev-parse --show-toplevel)"'

# Autoload
autoload -U compinit; compinit
zmodload zsh/complist
autoload -Uz edit-command-line; zle -N edit-command-line

# Plugins
source $ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZDOTDIR/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
fpath=($ZDOTDIR/plugins/zsh-completions/src $fpath)

# Auto completion
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' file-sort change
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|=*' 'l:|=* r:|=*'
source $ZDOTDIR/keymap.zsh

# Initialize tools
source $ZDOTDIR/function.zsh
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

