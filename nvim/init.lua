local Plug = vim.fn['plug#']

vim.call('plug#begin', vim.fn.stdpath('data')..'/plugged')
Plug('junegunn/fzf', { dir = '~/.fzf', ['do'] = './install --all' }) -- File fuzzy finding
Plug 'airblade/vim-gitgutter' -- Show git diff lines
Plug 'tpope/vim-rsi' -- Add the readline keys to Vim
Plug 'tpope/vim-eunuch' -- Some nice unix stuff for Vim (rename file and buffer, sudo edit)
Plug 'w0rp/ale' -- Erorr highlighting / linting while editing
Plug 'morhetz/gruvbox'
Plug 'hhvm/vim-hack' -- Hack support
Plug 'dkarter/bullets.vim'
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'plasticboy/vim-markdown'
Plug 'solarnz/thrift.vim'
Plug 'sheerun/vim-polyglot'
vim.call('plug#end')

-- Some basic utilities
vim.o.bg = 'dark'
vim.o.number = true
vim.o.mouse = 'a' -- Read mouse events
vim.o.showmatch = true -- Show matching parens and brackets
vim.o.hlsearch = true -- Highlight matching items in a search
vim.o.incsearch = true -- Incrementally search: auto-jump to the first match
vim.o.hidden = true -- Buffers should stay alive, even if not visible
vim.o.showcmd = true -- Show commands as they're typed
vim.o.autoread = true -- Reload files automatically
vim.o.splitbelow = true -- When making vertical splits, open the bottom
vim.o.splitright = true -- When making horizontal splits, open the right
vim.o.clipboard = 'unnamed'

-- Theming
vim.o.statusline = '%f%m%r%h%w%= [%Y] [%{&ff}] [line: %0l, column: %0v] [%p%%]'
vim.cmd('colorscheme gruvbox')

-- Use ripgrep for the :grep command
vim.o.grepprg='rg --vimgrep --no-heading --smart-case'

-- Tabs
-- Each indent should be 4 space characters
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.autoindent = true
vim.o.expandtab = true
vim.o.smarttab = true
vim.cmd('filetype plugin indent on')

-- Text wrapping
vim.o.wrap = true
vim.o.linebreak = true
vim.o.list = false -- list disables linebreak
vim.o.textwidth=0
vim.o.wrapmargin=0
vim.cmd('set formatoptions-=t')

vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false

-- Keybinds
vim.g.mapleader = ' '
function keymap(key, command)
	vim.api.nvim_set_keymap('n', key, command, {noremap = true, silent=true})
end
function leadmap(key, command)
    keymap('<leader>'..key, command)
end
leadmap('r', ':so %\n') -- Load a config
-- Split navigation
leadmap('h', '<C-w>h')
leadmap('j', '<C-w>j')
leadmap('k', '<C-w>k')
leadmap('l', '<C-w>l')
-- Common ALE operations
leadmap('ak', '<Plug>(ale_previous_wrap)')
leadmap('aj', '<Plug>(ale_next_wrap)')
leadmap('ah', ':ALEHover<CR>')
leadmap('ad', ':ALEGoToDefinition<CR>')
leadmap('ad', ':ALEFindReferences<CR>')

keymap('t', ':FZF<CR>') -- Fuzzy finding
leadmap('c', ':nohl<CR>') -- Clear highlighting
leadmap('s', ':buffers<CR>:b') -- Buffer list
leadmap('S', ':b#\n') -- Switch between the last two buffers
leadmap('-', ':split\n')
leadmap('|', ':vsplit\n')

leadmap('d', ":put =strftime('Time: %a %Y-%m-%d %H:%M:%S')<CR>") -- Insert timestamp

vim.cmd [[
    function! StripTrailingWhitespace()
      let l = line(".")
      let c = col(".")
      %s/\s\+$//e
      call cursor(l, c)
    endfunction
    command! StripTrailing :call StripTrailingWhitespace()
    au BufWritePre <buffer> :call StripTrailingWhitespace()
]]
vim.cmd [[
    " Set the GUI title of nvim
    function! SetTitle(title)
        set title
        let &titlestring=a:title
    endfunction
    command! -nargs=1 Title :call SetTitle(<f-args>) <CR>
]]

-- Don't highlight POSIX sh features as errors
vim.g.is_posix=1

vim.cmd('command! -nargs=1 Expand :echo expand(<f-args>)')

-- Enable italics (TODO: does this work?)
-- vim.o.t_ZH = '\\e[3m'
-- vim.o.t_ZR = '\\e[23m'

vim.cmd [[
    " Highlight trailing whitespace
    highlight ExtraWhitespace ctermbg=red guibg=Red
    match ExtraWhitespace /\s\+$/
    autocmd InsertEnter * highlight clear ExtraWhitespace
    autocmd InsertLeave * highlight ExtraWhitespace ctermbg=red guibg=red
]]

vim.cmd [[
    if stridx(hostname(), "infra.net") != -1 || stridx(hostname(), "devvm") != -1
      let g:javascript_plugin_flow = 1

      set rtp+=/usr/local/share/myc/vim
      nmap <leader>t :MYC<CR>
      source $ADMIN_SCRIPTS/vim/biggrep.vim

      set shiftwidth=2

      command! Diffusion :echo "https://www.internalfb.com/code/www/" . expand('%')
      command! Pastry :w !pastry
    endif
]]

-- Stop writing to all
vim.cmd('cabbrev W w')

vim.g.vim_markdown_folding_disabled = 1
