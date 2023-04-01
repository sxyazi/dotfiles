# Alias
alias ..="cd .."
alias ...="cd ../.."

alias p="pwd"
alias v="nvim"
alias r="source ranger"
alias l="exa --icons --group-directories-first"
alias ls="exa -al --icons --group-directories-first"
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
alias gf="git fetch --all"
alias gb="git branch"
alias gr="git rebase"
alias gt='cd "$(git rev-parse --show-toplevel)"'


# Store commands in history only if successful
# CREDITS:
# https://gist.github.com/danydev/4ca4f5c523b19b17e9053dfa9feb246d
# https://scarff.id.au/blog/2019/zsh-history-conditional-on-command-success/

function __fd18et_prevent_write() {
  __fd18et_LASTHIST=$1
  return 2
}
function __fd18et_save_last_successed() {
  if [[ ($? == 0 || $? == 130) && -n $__fd18et_LASTHIST && -n $HISTFILE ]] ; then
    print -sr -- ${=${__fd18et_LASTHIST%%'\n'}}
  fi
}
add-zsh-hook zshaddhistory __fd18et_prevent_write
add-zsh-hook precmd __fd18et_save_last_successed
add-zsh-hook zshexit __fd18et_save_last_successed

