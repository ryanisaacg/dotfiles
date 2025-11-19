au BufRead,BufNewFile *.brick set filetype=brick

let g:neoformat_brick_brickfmt = {
            \ 'exe': 'brick_fmt',
            \ 'stdin': 1,
            \ 'valid_exit_codes': [0],
            \ }

let g:neoformat_enabled_brick = ['brickfmt']
set cindent
