function attach -a name
    if [ -z "$name" ]
        set name (basename $PWD)
    end
    set sessions (tmux list-sessions -F '#{session_name}')
    if contains $name $sessions
        tmux attach -t $name
    else
        echo "No session $name found"
    end
end
