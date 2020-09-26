function exc
    echo -e $argv[1] > /tmp/script.fish
    source /tmp/script.fish
end

function launch
    set args (echo -s $argv)
    echo "tmux $args"
end

function session
    set name $argv[1]
    tmux-cmd "new-session"
    tmux-cmd "rename-session '$name'"
end

function window
    set name $argv[1]
    if set -q argv[2]
        set dir $argv[2]
    else
        set dir '~'
    end
    if set -q argv[3]; and [ "$argv[3]" = "new" ]
        tmux-cmd "new-window"
    end
    tmux-cmd "rename-window '$name'"
    send-cmd "cd $dir"
end

function h_split
    set path $argv[1]
    set size $argv[2]

    tmux-cmd "split-window -h"
    tmux-cmd "resize-pane -x $size"
    send-cmd "cd $path"
end

function send-cmd
    set cmd $argv[1]
    tmux-cmd "send-keys '$cmd' Enter"
    tmux-cmd "send-keys 'clear' Enter"
end

function select-pane
    tmux-cmd "select-pane -t '$argv[1]'"
end

function tmux-cmd
    echo "$argv[1] \\; \\\\\n"
end
