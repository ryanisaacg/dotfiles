local lsp = require('lspconfig')
local util = require("util")

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(bufnr)
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- TODO: I think a lot of these binds are auto-set nowadays...
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  util.keymap('gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
  util.keymap('gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
  util.keymap('K', '<cmd>lua vim.lsp.buf.hover()<CR>')
  util.keymap('gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
  util.keymap('<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
  util.keymap('<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
  util.keymap('<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
  util.keymap('<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')
  --util.keymap('<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
  util.keymap('<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
  util.keymap('<space>sa', '<cmd>lua vim.lsp.buf.code_action()<CR>')
  util.keymap('gr', '<cmd>lua vim.lsp.buf.references()<CR>')
  util.keymap('<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>')
  util.keymap('[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
  util.keymap(']d', '<cmd>lua vim.diagnostic.goto_next()<CR>')
  util.keymap('<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>')
  util.keymap('<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>')
end

vim.lsp.config('rust_analyzer', {
    settings = {
        ["rust-analyzer"] = {
            procMacro = { enable = true },
            diagnostics = {
                enable = true,
                disabled = {"unresolved-proc-macro"},
                enableExperimental = true,
                refreshSupport = false,
            },
        }
    }
})

vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {'vim'},
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
        },
    }
})


vim.lsp.config('felt_ls', {
    default_config = {
        cmd = {'felt-lsp'},
        filetypes = {'felt'};
        root_dir = function(fname)
            return lsp.util.find_git_ancestor(fname)
        end;
        settings = {};
    };
})

-- Indicate that we should have autocompletion - required for nvim-cmp
-- local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- vim.lsp.config('*', { capabilities })

-- longstanding typescript issue may or may not be fixed
-- https://github.com/typescript-language-server/typescript-language-server/issues/216#issuecomment-2798711457
vim.lsp.enable({
    'ts_ls',
    'eslint',
    'rust_analyzer',
    'lua_ls',
    'felt_ls',
    'zls',
    'gopls',
})

-- Autocompletion
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        on_attach(ev.buf)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client:supports_method('textDocument/completion') then
            --vim.o.completeopt = 'fuzzy,menu,menuone,noinsert,popup'
            --vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
        end
    end,
})
