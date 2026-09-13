##### ** WARNING! **
##### This file is sourced in ~/.zprofile!
##### DO NOT USE BASH-SPECIFIC SYNTAX!
##### USE ONLY POSIX-COMPATIBLE SYNTAX!

[[ -r "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

umask 077

export PATH="$PATH:$HOME/bin"
# all paths I need in PATH
PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/usr/local/games:/usr/games"
# private bin (~/bin/) if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi
# private local/bin (~/.local/bin/) if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi
export PATH

export EDITOR="/usr/bin/nvim"
export RANGER_LOAD_DEFAULT_RC=false
export VIRTUAL_ENV_DISABLE_PROMPT=1
