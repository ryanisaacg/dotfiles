#set -U fish_user_paths $fish_user_paths ~/.config/dotfiles/bin ~/.cargo/bin
#set PATH ~/.config/dotfiles/bin $PATH
set -x FZF_DEFAULT_COMMAND "rg -l ."
set -x EDITOR nvim
#set -x VIMINIT 'let $MYVIMRC="~/.config/dotfiles/vim/vimrc" | source $MYVIMRC'
set -x VIMINIT ''
stty start undef stop undef
