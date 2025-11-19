local Plug = vim.fn['plug#']

if not vim.g.vscode then
    vim.call('plug#begin', vim.fn.stdpath('data')..'/plugged')
    Plug('junegunn/fzf', { dir = '~/.fzf', ['do'] = './install --all' }) -- File fuzzy finding
    Plug 'airblade/vim-gitgutter' -- Show git diff lines
    Plug 'tpope/vim-rsi' -- Add the readline keys to Vim
    Plug 'tpope/vim-eunuch' -- Some nice unix stuff for Vim (rename file and buffer, sudo edit)
    Plug 'olimorris/onedarkpro.nvim' -- colorscheme
    Plug 'sheerun/vim-polyglot' -- Lazy-loaded syntax highlighting
    Plug 'neovim/nvim-lspconfig' -- LSP
    Plug 'chrisbra/Colorizer' -- Show color definitions as their color, highlighted
    Plug 'sbdchd/neoformat' -- Apply auto-formatting when applicable
    Plug 'nvim-lua/plenary.nvim' -- Dependency for telescope
    Plug 'nvim-telescope/telescope.nvim' -- Searching plugin
    Plug 'vim-test/vim-test' -- test runner
    Plug 'skywind3000/asyncrun.vim'

    -- Autocomplete
    Plug 'hrsh7th/nvim-cmp' -- Completion plugin
    Plug 'hrsh7th/vim-vsnip' -- "Snippet engine"
    Plug 'hrsh7th/cmp-vsnip' --  vim-vsnip integration with nvim-cmp
    Plug 'hrsh7th/cmp-nvim-lsp' -- Tell the LSP that we have completion capability
    vim.call('plug#end')

    require('autocomplete')
    require('lsp')
end

require('keybinds')
require('prompt')
require('neoformat')
require('github')
require('trailing')

-- Some basic utilities
vim.o.number = true
vim.o.splitbelow = true -- When making vertical splits, open the bottom
vim.o.splitright = true -- When making horizontal splits, open the right
vim.o.clipboard = 'unnamed'

vim.g.vim_markdown_folding_disabled = 1

-- Indentation
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.api.nvim_create_autocmd("FileType", {
  pattern = "javascript,typescript,javascriptreact,typescriptreact,html,css",
  callback = function ()
      vim.opt_local.shiftwidth = 2
      vim.opt_local.tabstop = 2
  end
})
vim.o.expandtab = true
vim.cmd('filetype plugin indent on')

-- Theming
if not vim.g.vscode then
    require("onedarkpro").setup({
      highlights = {
        Comment = { italic = true, extend = true }
      },
    })

    vim.cmd('colorscheme onedark')
    vim.o.termguicolors = true
    vim.cmd('hi StatusLineNC guibg=#1F1F1F')
    vim.cmd('hi StatusLine guibg=#444444')

    vim.g.colorizer_auto_filetype = 'css,html,js,jsx,typescript,typescriptreact'
    vim.g.colorizer_colornames = 0
end

-- Use ripgrep for the :grep command
vim.o.grepprg='rg --vimgrep --no-heading --smart-case'

-- Text wrapping
vim.o.linebreak = true
vim.o.list = false -- list disables linebreak
vim.cmd('set formatoptions-=t')

-- Disable backups
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false

-- Don't highlight POSIX sh features as errors
vim.g.is_posix=1

-- Stop writing to all
vim.cmd('cabbrev W w')

vim.api.nvim_create_user_command("Title", function (opts)
    vim.o.title = true
    vim.o.titlestring = opts.args
end, { nargs = 1 })

vim.api.nvim_create_user_command("Expand", function (opts)
    print(vim.fn.expand(opts.args))
end, { nargs = 1 })

-- Test runner
vim.g["test#strategy"] = "neovim"

-- Don't use git bash on windows - it causes really weird issues with temp files and paths and such
if vim.fn.has('win32') == 1 then
    vim.o.shell = 'cmd.exe'
end
-- Brick development
vim.treesitter.language.add('brick', { path = "/Users/ryanisaacg/git/ryanisaacg/brick/tree-sitter-brick/brick.dylib" })
vim.treesitter.language.register('brick', { 'brick' })
io.input('/Users/ryanisaacg/git/ryanisaacg/brick/tree-sitter-brick/highlights.scm')
local highlights = io.read('*all')
vim.treesitter.query.set('brick', 'highlights', highlights)
vim.api.nvim_create_autocmd( 'FileType', { pattern = 'brick',
    callback = function(args)
        vim.treesitter.start(args.buf, 'brick')
    end
})
