function attach -a name
    set base (basename $PWD)
    if not set -q name
        set name $base
    end
    set sessions (tmux list-sessions -F '#{session_name}')
    if contains $name $sessions
        tmux attach -t $name
    else
        tmux new -s $name
    end
end
