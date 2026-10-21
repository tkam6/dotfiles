##################
##### HELP COMMAND
##################
unalias run-help
autoload run-help


##############
##### GIT INFO
##############
# version control info
autoload -Uz vcs_info
# Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:git:*' formats '%b'


##############
##### KEYBINDS
##############
# emacs binds
bindkey -e
#bindkey -v
# ctrl+u behaves like bash
bindkey \^U backward-kill-line
# alt+bksp kills till directory separators
backward-kill-dir () {
    local WORDCHARS=${WORDCHARS/\/}
    zle backward-kill-word
    zle -f kill
}
zle -N backward-kill-dir
bindkey '^[^?' backward-kill-dir
zshexit() { echo "bye" }


#############
##### ALIASES
#############
alias anews='xdg-open https://archlinux.org/news'
alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias less='less -Ni'
alias ls='ls -Fh --color=auto'
alias md='mkdir'
alias neofetch='fastfetch'
alias py='python3'
alias snoo='echo :\)'
alias start='xdg-open'
alias steal='git clone'
alias yeet='git push'
alias yoink='git pull'

FUCK_OFF_CNTR=0
help() {
    (( FUCK_OFF_CNTR++ ))
    if (( FUCK_OFF_CNTR >= 8 )); then
        printf 'fuck off goddammit\n'
    elif (( FUCK_OFF_CNTR >= 5 )); then
        printf 'seriously mate?\n'
    else
        printf 'fuck off\n'
    fi
}


##############
##### AUTOLOAD
##############
autoload -U colors && colors
autoload -Uz compinit && compinit

##########
##### TMUX
##########
# Do not exit shell on ^d
# if [[ -n $TMUX ]]
# then
#     setopt IGNORE_EOF
# fi

#############
##### GENERAL
#############
# Do not exit shell on ^d
if [[ -n $VIRTUAL_ENV ]]
then
    setopt IGNORE_EOF
fi

#################
##### INTERACTIVE
#################
setopt prompt_subst
if [[ -o interactive ]]; then
    #pfetch
    #fastfetch
    # I hate clearing the screen by force of habit and being unable to see what
    # fortune returned
    #_FORTUNE_SESSION_TXT=$(fortune -s)
    #cowsay -- "$_FORTUNE_SESSION_TXT"

    RESET='\033[0m'
    PINKY_PINK='\033[38;5;213m'
    BLINKY_RED='\033[38;5;196m'
    PACMAN_YELLOW='\033[38;5;226m'
    PELLET_YELLOW='\033[38;5;229m'
    PY=$PELLET_YELLOW
    CLYDE_ORANGE='\033[38;5;208m'
    INKY_CYAN='\033[38;5;39m'
    printf "
    ${PACMAN_YELLOW}⠀⠀⠀⣠⣤⣶⣶⣦⣤⡀⠀${RESET}⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀${BLINKY_RED}⠀⠀⠀⣀⣤⣤⣀⠀⠀⠀⠀⠀${INKY_CYAN}⠀⠀⣀⣤⣤⣤⣀⠀⠀⠀⠀${CLYDE_ORANGE}⠀⠀⣀⣤⣤⣤⣀⠀⠀⠀
    ${PACMAN_YELLOW}⠀⣠⣾⣿⣿⣿⡏⠉⢻⣿⡦${RESET}⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀${BLINKY_RED}⠀⡰⠿⣿⣿⡿⢻⣷⣤⠀⠀⠀${INKY_CYAN}⢠⠾⣿⣿⣿⠿⣿⣷⡀⠀⠀${CLYDE_ORANGE}⢠⠾⢿⣿⣿⠿⣿⣷⡄⠀
    ${PACMAN_YELLOW}⢰⣿⣿⣿⣿⣿⣿⡶⠟⠉⠀${RESET}⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀${BLINKY_RED}⠀⠀⢹⡆⡋⠈⢳⢼⣿⡇⠀⠀${INKY_CYAN}⠁⢙⡦⣿⠀⢹⡎⣿⣷⠀⠀${CLYDE_ORANGE}⡂⢉⡧⡟⠀⢹⡆⣿⣷⠀
    ${PACMAN_YELLOW}⢸⣿⣿⣿⣿⣿⣅⡀⠀⠀⠀${RESET}⠀⠀${PY}⠾⠆⠀⠀⠀⠀⢐⡆⠀⠀⠀⠀⠰⡦⠀⠀⠀⠀${BLINKY_RED}⠈⣂⣉⣦⣯⣊⣅⣾⣿⡇⠀⠀${INKY_CYAN}⣷⣭⣴⣿⣶⣭⣾⣿⣿⠀⠀${CLYDE_ORANGE}⣵⣭⣴⣿⣷⣭⣶⣿⣿⠀
    ${PACMAN_YELLOW}⠘⣿⣿⣿⣿⣿⣿⣿⣶⣄⡀${RESET}⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀${BLINKY_RED}⠀⣿⣿⣭⣭⢿⣭⣵⣿⡇⠀⠀${INKY_CYAN}⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀${CLYDE_ORANGE}⣽⣿⣿⣿⣿⣿⣿⣿⣿⠀
    ${PACMAN_YELLOW}⠀⠘⠿⣿⣿⣿⣿⣿⣿⡿⠏${RESET}⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀${BLINKY_RED}⠐⠃⠈⠫⠁⠉⠛⠁⠙⠇⠀⠀${INKY_CYAN}⠟⠉⠻⠋⠉⠻⠋⠉⠛⠀⠀${CLYDE_ORANGE}⠟⠈⠙⠏⠈⠹⠋⠈⠻⠀
    ${PACMAN_YELLOW}⠀⠀⠀⠈⠙⠛⠛⠋⠉⠀⠀${RESET}\n"
    printf '
       88888b.   8888b.   .d8888b 88888b.d88b.   8888b.  88888b.
       888 "88b     "88b d88P"    888 "888 "88b     "88b 888 "88b
       888  888 .d888888 888      888  888  888 .d888888 888  888
       888 d88P 888  888 Y88b.    888  888  888 888  888 888  888
       88888P"  "Y888888  "Y8888P 888  888  888 "Y888888 888  888
       888
       888
       888\n\n'

    unsetopt AUTO_REMOVE_SLASH
fi


############
##### PROMPT
############
zmodload zsh/datetime
typeset -g CMD_START_TIME CMD_DURATION

# root user?
_IS_USR_ROOT=false
if [[ $UID -eq 0 ]]; then
    _IS_USR_ROOT=true
fi
_SSH_CONNECTION=false
_CONNECTION_TYP="local"
# SSH session?
if [[ -n "$SSH_CONNECTION" ]]; then
    _SSH_CONNECTION=true
    _CONNECTION_TYP="ssh${SSH_CONNECTION}"
fi

preexec() { CMD_START_TIME=$EPOCHREALTIME }

precmd()
{
    local last_ret=$?

    # git branch
    vcs_info
    _GIT_BRANCH=""
    if [[ -n "$vcs_info_msg_0_" ]]; then
        _GIT_BRANCH=" B:%B%F{cyan}${vcs_info_msg_0_}%f%b"
    fi
    # last exit code
    _LAST_CMD_RET_CODE=$last_ret
    if [[ $_LAST_CMD_RET_CODE -eq 0 ]]; then
        _PROMPT_BULLET="%F{green}•%f"
    else
        _PROMPT_BULLET="%F{red}•$_LAST_CMD_RET_CODE%f"
    fi
    # virtual env?
    _VIRT_ENV=""
    _ARROW_LN_TOP="┌"
    _ARROW_PS1="└─❯"
    _ARROW_PS2="••❯"
    if [[ -n "$VIRTUAL_ENV" ]]; then
        _VIRT_ENV="V:%F{magenta}${VIRTUAL_ENV:t}%f "
        _ARROW_LN_TOP="%F{magenta}┌%f"
        _ARROW_PS1="%F{magenta}└─❯%f"
        _ARROW_PS2="%F{magenta}••❯%f"
    fi
    # path with slash at end only if path isn't user dir
    _PTH="%~/"
    if [[ $PWD == $HOME || $PWD == "/" ]]; then
        _PTH='%~'
    fi
    # time commands
    CMD_DURATION='0'
    if [[ -n $CMD_START_TIME ]]; then
        local end_time=$EPOCHREALTIME
        CMD_DURATION=$(printf "%.0f" $(( end_time - CMD_START_TIME )))
    fi
}
# old, big prompt
#PS1=$'${_ARROW_LN_TOP} ${_PROMPT_BULLET} \e[2mzsh${ZSH_VERSION}\e[0m p:%U%#%u j:%U%j%u \e[2mt:${CMD_DURATION}s\e[0m ${_VIRT_ENV}${_CONNECTION_TYP}:%F{yellow}%n%f@%F{blue}%M%f %B%F{green}${_PTH}%f%b
# ${_ARROW_PS1} '
PS1=$'${_ARROW_LN_TOP} ${_PROMPT_BULLET} \e[2mZ\e[0m U:%U%#%u J:%U%j%u \e[2mT:${CMD_DURATION}s\e[0m ${_VIRT_ENV}%F{yellow}%n%f@%F{blue}%M%f${_GIT_BRANCH}%f%b %B%F{green}${_PTH}%f%b
${_ARROW_PS1} '
PS2=$'\e[2m${_ARROW_PS2}\e[0m '

################
##### LS COLOURS
################
#eval "$(dircolors -b ~/.dir_colors)"

#############
##### PLUGINS
#############
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
# fish shell-like features
[[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
[[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# [[ -f /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh ]] && source /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh
