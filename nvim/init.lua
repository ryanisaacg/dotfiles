local Plug = vim.fn['plug#']

vim.call('plug#begin', vim.fn.stdpath('data')..'/plugged')
Plug('junegunn/fzf', { dir = '~/.fzf', ['do'] = './install --all' }) -- File fuzzy finding
Plug 'airblade/vim-gitgutter' -- Show git diff lines
Plug 'tpope/vim-rsi' -- Add the readline keys to Vim
Plug 'tpope/vim-eunuch' -- Some nice unix stuff for Vim (rename file and buffer, sudo edit)
Plug 'morhetz/gruvbox'
Plug 'sheerun/vim-polyglot'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'chrisbra/Colorizer'
Plug 'sbdchd/neoformat'
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
function _G.current_client()
    local bufnr = vim.fn.bufnr()
    local clients = vim.lsp.get_active_clients()
    for _, client in ipairs(clients) do
        if client.attached_buffers[bufnr] then
            return '['..client.name..']'
        end
    end
    return ''
end

vim.o.statusline = '%f%m%r%h%w%= %{v:lua.current_client()} [%Y] [%{&ff}] [line: %0l, column: %0v] [%p%%]'

vim.g.gruvbox_italic = 1
vim.cmd('colorscheme gruvbox')
vim.o.termguicolors = true
vim.g.colorizer_auto_filetype = 'css,html,js,jsx,typescript,typescriptreact'
vim.g.colorizer_colornames = 0

-- Use ripgrep for the :grep command
vim.o.grepprg='rg --vimgrep --no-heading --smart-case'

-- Tabs
-- Each indent should be 4 space characters
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.api.nvim_create_autocmd("FileType", {
  pattern = "javascript,typescript,javascriptreact,typescriptreact",
  callback = function (args)
      vim.opt_local.shiftwidth = 2
      vim.opt_local.tabstop = 2
  end
})
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

keymap('t', ':FZF<CR>') -- Fuzzy finding
leadmap('c', ':nohl<CR>') -- Clear highlighting
leadmap('s', ':buffers<CR>:b') -- Buffer list
leadmap('S', ':b#\n') -- Switch between the last two buffers
leadmap('-', ':split\n')
leadmap('|', ':vsplit\n')

leadmap('d', ":put =strftime('Time: %a %Y-%m-%d %H:%M:%S')<CR>") -- Insert timestamp

function strip_trailing()
    vim.cmd [[
      let l = line(".")
      let c = col(".")
      %s/\s\+$//e
      call cursor(l, c)
    ]]
end
vim.api.nvim_create_user_command("StripTrailing", strip_trailing, {})
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "<buffer>",
    callback = strip_trailing,
})
vim.api.nvim_create_user_command("Title", function (opts)
    vim.o.title = true
    vim.o.titlestring = opts.args
end, { nargs = 1 })

-- Don't highlight POSIX sh features as errors
vim.g.is_posix=1

vim.api.nvim_create_user_command("Expand", function (opts)
    print(vim.fn.expand(opts.args))
end, { nargs = 1 })

-- Enable italics (TODO: does this work?)
vim.cmd [[
    let &t_ZH="\e[3m"
    let &t_ZR="\e[23m"
]]

vim.cmd [[
    " Highlight trailing whitespace
    highlight ExtraWhitespace ctermbg=red guibg=Red
    match ExtraWhitespace /\s\+$/
    autocmd InsertEnter * highlight clear ExtraWhitespace
    autocmd InsertLeave * highlight ExtraWhitespace ctermbg=red guibg=red
]]


vim.api.nvim_create_user_command("Github", function ()
    -- TODO: lua-ify
    vim.cmd [[
        let origin = substitute(trim(system("git remote get-url origin")), '.git$', '', '')
        let branch_path = trim(system("git symbolic-ref refs/remotes/origin/HEAD"))
        let branch = fnamemodify(branch_path, ":t")
        echo origin.."/blob/"..branch.."/"..expand('%')
    ]]
end, {})

vim.api.nvim_create_augroup("fmt", {})
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.js,*.jsx,*.ts,*.tsx",
    callback = function()
        -- Ensure CWD matches the file being edited, so the prettier config will be picked up
        cwd = vim.fn.getcwd()
        parent_folder = vim.fn.expand("%:h")
        vim.cmd("cd " .. parent_folder)
        vim.cmd "try | undojoin | Neoformat | catch /E790/ | Neoformat | endtry"
        vim.cmd("cd " .. cwd)
    end
})
vim.g.neoformat_try_node_exe = 1

-- Stop writing to all
vim.cmd('cabbrev W w')

vim.g.vim_markdown_folding_disabled = 1

-- LSP support
local lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  keymap('gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
  keymap('gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
  keymap('K', '<cmd>lua vim.lsp.buf.hover()<CR>')
  keymap('gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
  keymap('<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
  keymap('<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
  keymap('<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
  keymap('<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')
  --keymap('<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
  keymap('<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
  keymap('<space>sa', '<cmd>lua vim.lsp.buf.code_action()<CR>')
  keymap('gr', '<cmd>lua vim.lsp.buf.references()<CR>')
  keymap('<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>')
  keymap('[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
  keymap(']d', '<cmd>lua vim.diagnostic.goto_next()<CR>')
  keymap('<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>')
  keymap('<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>')
end

local function filter(arr, fn)
  if type(arr) ~= "table" then
    return arr
  end

  local filtered = {}
  for k, v in pairs(arr) do
    if fn(v, k, arr) then
      table.insert(filtered, v)
    end
  end

  return filtered
end

local language_servers = {
    tsserver = {
      handlers = {
        ['textDocument/definition'] = function(err, result, method, ...)
          if vim.tbl_islist(result) and #result > 1 then
            -- Filter out type definitions confusing TypeScript as to where the real declaration
            -- of a given value is. Most common when working with React and wrapping exported
            -- types in React types
            local filtered_result = filter(result, function(value)
              -- TODO: this could probably be made faster
              return string.match(value.uri, '%a*/index.d.ts') == nil
            end)
            return vim.lsp.handlers['textDocument/definition'](err, filtered_result, method, ...)
          end

          vim.lsp.handlers['textDocument/definition'](err, result, method, ...)
        end
      }
    },
    eslint = {},
    rust_analyzer = {
        settings = {
            ["rust-analyzer"] = {
                procMacro = { enable = true },
                diagnostics = {
                    enable = true,
                    disabled = {"unresolved-proc-macro"},
                    enableExperimental = true,
                },
            }
        }
    },
}
for server,settings in pairs(language_servers) do
    settings.on_attach = on_attach
    lsp[server].setup(settings)
end

