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

