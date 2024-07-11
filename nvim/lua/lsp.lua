local lsp = require('lspconfig')
local util = require("util")

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

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
    lua_ls = {
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
        },
    },
    brick_lsp = {},
    zls = {}
}

-- Patch brick_lsp into the config
require('lspconfig.configs').brick_lsp = {
    default_config = {
        cmd = {'target/debug/brick-lsp'},
        filetypes = {'brick'};
        root_dir = function(fname)
            return lsp.util.find_git_ancestor(fname)
        end;
        settings = {};
    };
}


-- Indicate that we should have autocompletion - required for nvim-cmp
local capabilities = require('cmp_nvim_lsp').default_capabilities()

for server,settings in pairs(language_servers) do
    settings.on_attach = on_attach
    settings.capabilities = capabilities
    lsp[server].setup(settings)
end

