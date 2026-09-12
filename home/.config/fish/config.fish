if status is-interactive
    # Commands to run in interactive sessions can go here
end

function fish_prompt
    set -l _last_status $status
    set -l _ssh_status local
    set -l stat (set_color green)"• "(set_color normal)
    if test $_last_status -ne 0
        set stat (set_color red)"•$_last_status "(set_color normal)
    end

    if set -q $SSH_CONNECTION
        set _ssh_status=ssh
    end

    # string join '' -- (set_color magenta) '┌ ' (set_color normal) $stat (set_color --dim) 'fish' $FISH_VERSION (set_color normal) ' ' $_ssh_status ':' (set_color yellow) $USER (set_color normal) '@' (set_color blue) $hostname (set_color normal) ':' (set_color green) $PWD (set_color normal)
    string join '' -- (set_color magenta) '┌ ' (set_color normal) $stat (set_color --dim) 'fish' $FISH_VERSION (set_color normal) ' ' $_ssh_status ':' (set_color yellow) $USER (set_color normal) ':' (set_color green) $PWD (set_color normal)
    string join '' -- (set_color magenta) '└─❯ '(set_color normal)
end
