# If not running interactively, don't do anything
# [[ $- != *i* ]] && return

# # # # #
# PATH  #
# # # # #
PATH="$PATH:/home/vallu/bin"


##### ALIASES
alias grep='grep --color=auto'
alias ll='ls -l'
alias logoff='loginctl terminate-user $(whoami)'
alias ls='ls --color=auto'
alias snoo='echo :\)'
alias start='xdg-open'


_RESET_ANSI="\[\e[0m\]"
_BOLD_ANSI="\[\e[1m\]"
_FAINT_ANSI="\[\e[2m\]"
_UNDERLINE_ANSI="\[\e[4m\["
_RED_ANSI="\[\e[31m\]"
_GREEN_ANSI="\[\e[32m\]"
_YELLOW_ANSI="\[\e[33m\]"
_CYAN_ANSI="\[\e[34m\]"
_PURPLE_ANSI="\[\e[35m\]"
_BLUE_ANSI="\[\e[36m\]"
_SWAP_ANSI="\[\e[7m\]"
_BLACK_ON_GREEN_ANSI="\[\e[30;42m\]"
_BLACK_ON_RED_ANSI="\[\e[30;41m\]"
_BOLD_BLACK_ON_BLUE_ANSI="\[\e[1;30;44m\]"
_BOLD_BLACK_ON_CYAN_ANSI="\[\e[1;30;46m\]"
_BOLD_BLACK_ON_YELLOW_ANSI="\[\e[1;30;43m\]"
_BOLD_WHITE_ON_BLUE_ANSI="\[\e[1;37;44m\]"
_BOLD_WHITE_ON_YELLOW_ANSI="\[\e[1;37;43m\]"
# Is user root?
if [[ $UID -eq 0 ]]; then
    _IS_USR_ROOT=true
else
    _IS_USR_ROOT=false
fi
# Is current session on SSH?
if [[ -z "$SSH_CONNECTION" ]]; then
    _CONNECTION_TYP="local"
else
    _CONNECTION_TYP="ssh ${SSH_CONNECTION}"
fi
PROMPT_COMMAND='
_LAST_CMD_RET_CODE=$?
# Last command exit status
if [[ $_LAST_CMD_RET_CODE -eq 0 ]]; then
    _PROMPT_BULLET="${_GREEN_ANSI}•${_RESET_ANSI}"
else
    _PROMPT_BULLET="${_RED_ANSI}•${_LAST_CMD_RET_CODE}${_RESET_ANSI}"
fi
# Bash prompt
PS1="┌ ${_PROMPT_BULLET}${_RESET_ANSI} ${_FAINT_ANSI}B${_RESET_ANSI} U:${_UNDERLINE_ANSI}\$${_RESET_ANSI} J:${_UNDERLINE_ANSI}\j${_RESET_ANSI} ${_YELLOW_ANSI}\u${_RESET_ANSI}@${_CYAN_ANSI}\H${_RESET_ANSI} ${_GREEN_ANSI}\w${_RESET_ANSI}\n└─❯ "
# Continuation prompt
PS2="${_FAINT_ANSI}${_PURPLE_ANSI}└→${_RESET_ANSI} "
'

##### MISCELLANEOUS
echo
pfetch
fortune -s | cowsay
echo

##### CARGO
. "$HOME/.cargo/env"
