# Widgets
function vi-yank-wrapped {
  local last_key="$KEYS[-1]"
  local ori_buffer="$CUTBUFFER"

  zle vi-yank
  if [[ "$last_key" = "Y" ]] then
    echo -n "$CUTBUFFER" | pbcopy -i
    CUTBUFFER="$ori_buffer"
  fi
}
zle -N vi-yank-wrapped

bindkey -s "^y" "y\n"

# Menu
bindkey -rpM menuselect ""
bindkey -M menuselect "^I"        complete-word
bindkey -M menuselect "^["        send-break
bindkey -M menuselect "^U"        up-line-or-history
bindkey -M menuselect "^E"        down-line-or-history
bindkey -M menuselect "^N"        backward-char
bindkey -M menuselect "^[[105;5u" forward-char  # Ctrl+i in CSI u, configured in kitty.conf and tmux.conf both

# Command
bindkey -rpM command ""
bindkey -M command "^[" send-break
bindkey -M command "^M" accept-line

# Normal mode
bindkey -rpM vicmd ""
bindkey -M vicmd "^W"        backward-delete-word
bindkey -M vicmd "^L"        clear-screen
bindkey -M vicmd "^M"        accept-line
bindkey -M vicmd "u"         up-line
bindkey -M vicmd "^U"        history-substring-search-up
bindkey -M vicmd "e"         down-line
bindkey -M vicmd "^E"        history-substring-search-down
bindkey -M vicmd "n"         vi-backward-char
bindkey -M vicmd "N"         vi-first-non-blank
bindkey -M vicmd "^N"        vi-insert-bol
bindkey -M vicmd "i"         vi-forward-char
bindkey -M vicmd "I"         vi-end-of-line
bindkey -M vicmd "^[[105;5u" vi-add-eol         # Ctrl+i in CSI u, configured in kitty.conf and tmux.conf both
bindkey -M vicmd "^[[44;5u"  edit-command-line  # Ctrl+, in CSI u, configured in kitty.conf and tmux.conf both

bindkey -M vicmd "b" vi-backward-word
bindkey -M vicmd "B" vi-backward-blank-word
bindkey -M vicmd "h" vi-forward-word-end
bindkey -M vicmd "H" vi-forward-blank-word-end
bindkey -M vicmd "w" vi-forward-word
bindkey -M vicmd "W" vi-forward-blank-word
bindkey -M vicmd "a" vi-add-next
bindkey -M vicmd "A" vi-add-eol
bindkey -M vicmd "k" vi-insert
bindkey -M vicmd "K" vi-insert-bol
bindkey -M vicmd "m" vi-open-line-below
bindkey -M vicmd "M" vi-open-line-above

bindkey -M vicmd "d" vi-delete
bindkey -M vicmd "D" vi-kill-eol
bindkey -M vicmd "c" vi-change
bindkey -M vicmd "C" vi-change-eol
bindkey -M vicmd "x" vi-delete-char
bindkey -M vicmd "X" vi-backward-delete-char
bindkey -M vicmd "r" vi-replace-chars
bindkey -M vicmd "R" vi-replace

bindkey -M vicmd "y" vi-yank-wrapped
bindkey -M vicmd "Y" vi-yank-wrapped
bindkey -M vicmd "p" vi-put-after
bindkey -M vicmd "P" vi-put-before

bindkey -M vicmd "v" visual-mode
bindkey -M vicmd "V" visual-line-mode
bindkey -M vicmd "l" undo
bindkey -M vicmd "L" redo

# bindkey -M vicmd ";"  execute-named-cmd
bindkey -M vicmd "."  vi-repeat-change
bindkey -M vicmd ","  edit-command-line
bindkey -M vicmd "\-" vi-repeat-search
bindkey -M vicmd "="  vi-rev-repeat-search

bindkey -M vicmd "0"-"9" digit-argument
bindkey -M vicmd "<"     vi-unindent
bindkey -M vicmd ">"     vi-indent
bindkey -M vicmd "J"     vi-join

bindkey -M vicmd "gu" vi-down-case
bindkey -M vicmd "gU" vi-up-case
bindkey -M vicmd "gs" vi-swap-case
bindkey -M vicmd "ge" vi-backward-word-end
bindkey -M vicmd "gE" vi-backward-blank-word-end
bindkey -M vicmd "gg" beginning-of-buffer-or-history
bindkey -M vicmd "fb" vi-match-bracket

# Insert mode
bindkey -M viins "^?"        backward-delete-char  # Backspace
bindkey -M viins "^W"        backward-delete-word
bindkey -M viins "^U"        history-substring-search-up
bindkey -M viins "^E"        history-substring-search-down
bindkey -M viins "^N"        vi-insert-bol
bindkey -M viins "^[[105;5u" vi-add-eol            # Ctrl+i in CSI u, configured in kitty.conf
bindkey -M viins "^[[44;5u"  edit-command-line     # Ctrl+, in CSI u, configured in kitty.conf and tmux.conf both

# Visual mode
bindkey -rpM visual ""
bindkey -M visual "^["   deactivate-region  # Esc
bindkey -M visual "u"    up-line
bindkey -M visual "^U"   history-substring-search-up
bindkey -M visual "e"    down-line
bindkey -M visual "^E"   history-substring-search-down
bindkey -M visual "aw"   select-a-word
bindkey -M visual "aW"   select-a-blank-word
bindkey -M visual "aa"   select-a-shell-word
bindkey -M visual "kw"   select-in-word
bindkey -M visual "kW"   select-in-blank-word
bindkey -M visual "kk"   select-in-shell-word
bindkey -M visual "x"    vi-delete
bindkey -M visual "p"    put-replace-selection

# Operator pending mode
bindkey -rpM viopp ""
bindkey -M viopp "^[" vi-cmd-mode
bindkey -M viopp "u"  up-line
bindkey -M viopp "e"  down-line
bindkey -M viopp "aw" select-a-word
bindkey -M viopp "aW" select-a-blank-word
bindkey -M viopp "aa" select-a-shell-word
bindkey -M viopp "kw" select-in-word
bindkey -M viopp "kW" select-in-blank-word
bindkey -M viopp "kk" select-in-shell-word

