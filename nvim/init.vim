"Plugins
"Install the plugin manager
"if empty(glob("~/.config/nvim/autoload/plug.vim"))
"  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
"endif
"Install the plugins
call plug#begin(stdpath('data') . '/plugged')
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " File fuzzy finding
Plug 'airblade/vim-gitgutter' " Show git diff lines
Plug 'tpope/vim-rsi' " Add the readline keys to Github
Plug 'tpope/vim-sensible' " Some nice defaults for Vim
Plug 'tpope/vim-eunuch' " Some nice unix stuff for Vim (rename file and buffer, sudo edit)
Plug 'sheerun/vim-polyglot' " Add a bunch of language support plugins on demand
Plug 'w0rp/ale' " Erorr highlighting / linting while editing
Plug 'vimwiki/vimwiki' " Vim wiki
Plug 'junegunn/goyo.vim' " Distraction free writing
Plug 'morhetz/gruvbox'
Plug 'MattesGroeger/vim-bookmarks' " Vim Bookmarks
call plug#end()

" Important for lua quality-of-life
lua util = require('util')
command! -nargs=1 Unload :lua util.unload(<q-args>)<CR>

"Some basic utilities
set bg=dark
set number "Line numbers
set clipboard^=unnamed "Use the system clipboard
set mouse=a "Read mouse events
set showmatch "Show matching parens and brackets
set hlsearch "Highlight matching items in a search
set incsearch "Incrementally search: auto-jump to the first match while a search is being typed
set hidden "Buffers should stay alive, even if not visible
set showcmd
set autoread "Reload files automatically when they're changed outside vim
set splitbelow "Open a split below the current split
set splitright "Open a split to the right of the current split

colorscheme gruvbox

" Use ripgrep for the :grep command
set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case

"Tabs
"Each indent should be 4 space characters
set tabstop=4 "Make each tab 4 spaces
set shiftwidth=4 "Make sure auto-tabbing only indents 4 spaces
set autoindent
set expandtab
set smarttab
filetype plugin indent on

"Text wrapping
set wrap
set linebreak
set nolist  " list disables linebreak
set textwidth=0
set wrapmargin=0
set formatoptions-=t
noremap  <buffer> <silent> k gk
noremap  <buffer> <silent> j gj
noremap  <buffer> <silent> 0 g0
noremap  <buffer> <silent> $ g$
noremap  <buffer> <silent> <Up> gk
noremap  <buffer> <silent> <Down> gj
noremap  <buffer> <silent> <Home> g0
noremap  <buffer> <silent> <End> g$

"Disable backups completely
set nobackup nowritebackup noswapfile

" Keybinds
let mapleader=" "
" Load this config file
nmap <silent> <leader>r :so %<CR>
" Add keybinds to jump to errors
nmap <silent> <leader>ak <Plug>(ale_previous_wrap)
nmap <silent> <leader>aj <Plug>(ale_next_wrap)
" Add keybinds for split navigation
nmap <silent> <leader>h <C-w>h
nmap <silent> <leader>j <C-w>j
nmap <silent> <leader>k <C-w>k
nmap <silent> <leader>l <C-w>l
" Add keybinds for using common ALE operations
nmap <silent> <leader>ah :ALEHover<CR>
nmap <silent> <leader>ad :ALEGoToDefinition<CR>
nmap <silent> <leader>ar :ALEFindReferences<CR>
" Fuzzy finder
nmap <silent> t :FZF<CR>
" Clear highlighting
nmap <silent> <leader>c :nohl<CR>
" Display list of buffers
nmap <silent> <leader>s :buffers<CR>:b
" Switch between the last 2 buffers
nmap <silent> <leader>S :b#<CR>
" Execute the currently focused command from 'dispatch.vim'
nmap <silent> <leader>Q :Dispatch<CR>
" Create splits using easy keybindings
nmap <silent> <leader>- :split<CR>
nmap <silent> <leader>\| :vsplit<CR>
" Wiki keybindings
" Add keybinds for opening a link into split
nmap <silent> <leader>w- <Plug>VimwikiSplitLink
nmap <silent> <leader>w\| <Plug>VimwikiVSplitLink
nmap <silent> <leader>wc :VimwikiTOC<CR>
nmap <silent> <leader><CR> :call NormalizeLocalLink(0)<CR>
vmap <silent> <leader><CR> :<C-U>call NormalizeLocalLink(1)<CR>
" Configure the statusline
set statusline=%f%m%r%h%w%=\ [%Y]\ [%{&ff}]\ [line:\ %0l,\ column:\ %0v]\ [%p%%]
"set guicursor=

" Custom commands
" Strip tailing whitespace from files
function! StripTrailingWhitespace()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfunction
command! StripTrailing :call StripTrailingWhitespace()
au BufWritePre <buffer> :call StripTrailingWhitespace()
" Create a local link in vimwiki
function! NormalizeLocalLink(visual)
    call vimwiki#base#normalize_link(a:visual)
    execute "normal! /]\<cr>wi#\<esc>"
endfunction
" Set the GUI title of nvim
function! SetTitle(title)
    set title
    let &titlestring=a:title
endfunction

" Don't highlight POSIX sh features as errors
let g:is_posix=1

" Leave Vim screen on scrollback instead of clearing it
command! Persist :set t_ti= t_te=

" Echo expanded
command! -nargs=1 Expand :echo expand(<f-args>)

" Configure syntax highlighting
function! InitGui()
    if exists('g:GuiLoaded')
        "call s:h("ALEError", { "fg": s:red, "gui": "underline", "cterm": "underline" }) " Highligh error as red, underlined.
        "call s:h("ALEWarning", { "gui": "underline", "cterm": "underline"})  " Underline for warning.
        "call s:h("ALEInfo", { "gui": "underline", "cterm": "underline"}) " Underline for info tips.
        "colorscheme gruvbox
    endif
endfunction
if has('nvim-0.4')
    autocmd UIEnter * call InitGui()
endif
" Enable italics
let &t_ZH="\e[3m"
let &t_ZR="\e[23m"
" Highlight trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=Red
match ExtraWhitespace /\s\+$/
autocmd InsertEnter * highlight clear ExtraWhitespace
autocmd InsertLeave * highlight ExtraWhitespace ctermbg=red guibg=red

" Configure VimWiki
let g:vimwiki_list = [{ 'path': '~/vimwiki', 'syntax': 'markdown', 'ext': '.txt' }]
lua wiki = require('wiki')
command! Today :lua wiki.genToday()<CR>
command! Days :lua wiki.genDays()<CR>
command! Checkify :lua wiki.checkify()<CR>
nmap <silent> <leader>wg :VimwikiGoto
hi VimwikiLink cterm=underline ctermfg=DarkBlue gui=underline guifg=#458588
