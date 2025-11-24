au BufRead,BufNewFile *.felt set filetype=felt

let g:neoformat_felt_feltfmt = {
            \ 'exe': 'felt_fmt',
            \ 'stdin': 1,
            \ 'valid_exit_codes': [0],
            \ }

let g:neoformat_enabled_felt = ['feltfmt']
set cindent
