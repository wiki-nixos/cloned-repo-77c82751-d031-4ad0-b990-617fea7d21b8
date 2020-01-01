if [[ -n $SSH_CONNECTION ]]; then
  export PS1='%m:%3~$(git_info_for_prompt)%# '
else
  export PS1='%3~$(git_info_for_prompt)%# '
fi

export LSCOLORS="exfxcxdxbxegedabagacad"
export CLICOLOR=true

fpath=($ZSH/functions $fpath)

autoload -U $ZSH/functions/*(:t)

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt NO_BG_NICE # don't nice background tasks
setopt NO_HUP
setopt NO_LIST_BEEP
setopt LOCAL_OPTIONS # allow functions to have local options
setopt LOCAL_TRAPS # allow functions to have local traps
setopt HIST_VERIFY
setopt SHARE_HISTORY # share history between sessions ???
setopt EXTENDED_HISTORY # add timestamps to history
setopt PROMPT_SUBST
setopt CORRECT
setopt COMPLETE_IN_WORD

# IGNORE_EOF like in bash <https://superuser.com/questions/1243138/why-does-ignoreeof-not-work-in-zsh/1309966>
setopt IGNORE_EOF
IGNOREEOF=3

_bash-ctrl-d() {
  if [[ $CURSOR == 0 && -z $BUFFER ]]; then
    [[ -z $IGNOREEOF || $IGNOREEOF == 0 ]] && exit

    if [[ $LASTWIDGET == _bash-ctrl-d ]]; then
      (( --__BASH_IGNORE_EOF <= 0 )) && exit
    else
      (( __BASH_IGNORE_EOF = IGNOREEOF-1 ))
    fi

    echo
    echo "Press ^D again or use "exit" to leave shell ($(( $IGNOREEOF - $__BASH_IGNORE_EOF ))/$(( $IGNOREEOF - 1 )))"
    echo

    zle send-break
  else
    zle delete-char-or-list
  fi
}

zle -N _bash-ctrl-d
bindkey "^D" _bash-ctrl-d

setopt APPEND_HISTORY # adds history
setopt INC_APPEND_HISTORY SHARE_HISTORY  # adds history incrementally and share it across sessions
setopt HIST_IGNORE_ALL_DUPS  # don't record dupes in history
setopt HIST_REDUCE_BLANKS

# don't expand aliases _before_ completion has finished
#   like: git comm-[tab]
# setopt complete_aliases

zle -N newtab

bindkey -v  # vi mode

bindkey '^[^[[D' backward-word
bindkey '^[^[[C' forward-word
bindkey '^[[5D' beginning-of-line
bindkey '^[[5C' end-of-line
bindkey '^[[3~' delete-char
bindkey '^[^N' newtab
bindkey '^?' backward-delete-char

bindkey '^B' backward-word
bindkey '^F' forward-word
# ^left
bindkey ';5D' backward-word
# ^right
bindkey ';5C' forward-word

bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
bindkey '^r' history-incremental-search-backward

# C-x C-e to edit
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line
