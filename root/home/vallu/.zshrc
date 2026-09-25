##### help
unalias run-help
autoload run-help


##### git info
# Load version control information
autoload -Uz vcs_info
# Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:git:*' formats '%b'


##### KEYBINDS
revert-line() { while zle .undo; do done }
zle -N revert-line
bindkey '^[r' revert-line
bindkey -e
backward-kill-dir () {
    local WORDCHARS=${WORDCHARS/\/}
    zle backward-kill-word
    zle -f kill
}
zle -N backward-kill-dir
bindkey '^[^?' backward-kill-dir
# bindkey -v
function zsh_exit_message() { echo "bye" }
trap zsh_exit_message EXIT


##### ALIASES
alias anews='xdg-open https://archlinux.org/news &>/dev/null'
alias grep='grep --color=auto'
alias help='run-help'
alias less='less -N'
alias ls='ls -Fh --color=auto'
alias md='mkdir'
alias neofetch='fastfetch'
alias py='python3'
alias pyt='python3t'
alias 'py3.13'='python3.13'
alias snoo='echo :\)'
alias start='xdg-open'
alias steal='git clone'
alias yeet='git push'
alias yoink='git pull'


##### AUTOLOAD
autoload -U colors && colors
autoload -Uz compinit && compinit
##### TMUX
# Do not exit shell on ^d
# if [[ -n $TMUX ]]
# then
#     setopt IGNORE_EOF
# fi
##### GENERAL
# Do not exit shell on ^d
# if [[ -n $VIRTUAL_ENV ]]
# then
#     setopt IGNORE_EOF
# fi

##### MISCELLANEOUS
setopt prompt_subst
if [[ -o interactive ]]; then
    echo
    # pfetch
    fastfetch
    # I hate clearing the screen by force of habit and being unable to see what fortune returned
    _FORTUNE_SESSION_TXT=$(fortune -s)
    cowsay -- "$_FORTUNE_SESSION_TXT"
    echo
    unsetopt AUTO_REMOVE_SLASH
    setopt HIST_IGNORE_DUPS
    # setopt SHARE_HISTORY
    # setopt INC_APPEND_HISTORY
    # setopt AUTO_CD
fi

##### PROMPT
zmodload zsh/datetime
typeset -g CMD_START_TIME CMD_DURATION
CMD_DURATION='0'
# Is user root?
if [[ $UID -eq 0 ]]; then
    _IS_USR_ROOT=true
else
    _IS_USR_ROOT=false
fi
# Is current session on SSH?
if [[ -n "$SSH_CONNECTION" ]]; then
    _CONNECTION_TYP="ssh${SSH_CONNECTION}"
else
    _CONNECTION_TYP="local"
fi

preexec() { CMD_START_TIME=$EPOCHREALTIME }

precmd()
{
    vcs_info
    _GIT_BRANCH=""
    if [[ -n "$vcs_info_msg_0_" ]]; then
        _GIT_BRANCH=" B:%B%F{cyan}${vcs_info_msg_0_}%f%b"
    fi

    _LAST_CMD_RET_CODE=$?
    # Last command exit status
    if [[ $_LAST_CMD_RET_CODE -eq 0 ]]; then
        _PROMPT_BULLET="%F{green}•%f"
    else
        _PROMPT_BULLET="%F{red}•$_LAST_CMD_RET_CODE%f"
    fi
    # Is it a virtual env?
    if [[ -n "$VIRTUAL_ENV" ]]; then
        _VIRT_ENV="V:%F{magenta}${VIRTUAL_ENV:t}%f "
        _ARROW_LN_TOP="%F{magenta}┌%f"
        _ARROW_PS1="%F{magenta}└─❯%f"
        _ARROW_PS2="%F{magenta}••❯%f"
    else
        _VIRT_ENV=""
        _ARROW_LN_TOP="┌"
        _ARROW_PS1="└─❯"
        _ARROW_PS2="••❯"
    fi
    # Path with a slash at the end only if path isn't user dir
    if [[ $PWD == $HOME || $PWD == "/" ]]; then
        _PTH='%~'
    else
        _PTH="%~/"
    fi
    # Time commands
    if [[ -n $CMD_START_TIME ]]; then
        local end_time=$EPOCHREALTIME
        CMD_DURATION=$(printf "%.0f" $(( end_time - CMD_START_TIME )))
    fi
}
# Old, big prompt
# PS1=$'${_ARROW_LN_TOP} ${_PROMPT_BULLET} \e[2mzsh${ZSH_VERSION}\e[0m p:%U%#%u j:%U%j%u \e[2mt:${CMD_DURATION}s\e[0m ${_VIRT_ENV}${_CONNECTION_TYP}:%F{yellow}%n%f@%F{blue}%M%f %B%F{green}${_PTH}%f%b
# ${_ARROW_PS1} '
PS1=$'${_ARROW_LN_TOP} ${_PROMPT_BULLET} \e[2mZ\e[0m U:%U%#%u J:%U%j%u \e[2mT:${CMD_DURATION}s\e[0m ${_VIRT_ENV}%F{yellow}%n%f@%F{blue}%M%f${_GIT_BRANCH}%f%b %B%F{green}${_PTH}%f%b
${_ARROW_PS1} '
PS2=$'\e[2m${_ARROW_PS2}\e[0m '

##### LS COLOURS
# eval "$(dircolors -b ~/.dir_colors)"

##### ZSH-AUTOSUGGESTIONS CONFIG
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
##### FISH SHELL-LIKE FEATURES
[[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
[[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# [[ -f /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh ]] && source /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh
