if status is-interactive
    # Commands to run in interactive sessions can go here
    stty start undef stop undef
end

set -x FZF_DEFAULT_COMMAND "rg -l ."
set -x EDITOR nvim

alias g='git'
