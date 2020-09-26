function work-tmux
    source ~/.config/fish/functions/init-tmux.fish
    exc (launch \
        (session 'config') \
        (window 'Dotfiles' '~/.config/dotfiles') \
        (session 'autolab') \
        (window 'Autolab' '~/Documents/Autolab') \
        (h_split '~/Documents/Autolab' '90') \
        (select-pane '1') \
        (window 'Autolab Scripts' '~/bin' 'new') \
        (session 'biginteger') \
        (window 'BigInteger' '~/Documents/biginteger') \
        (session '211') \
        (window 'Autograder' '~/Documents/211-autograder'))
end
