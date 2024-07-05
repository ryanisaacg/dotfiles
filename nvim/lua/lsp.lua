local lsp = require('lspconfig')
local util = require("util")

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
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

  if client.name == "omnisharp" then
    client.server_capabilities.semanticTokensProvider = {
      full = vim.empty_dict(),
      legend = {
        tokenModifiers = { "static_symbol" },
        tokenTypes = {
          "comment",
          "excluded_code",
          "identifier",
          "keyword",
          "keyword_control",
          "number",
          "operator",
          "operator_overloaded",
          "preprocessor_keyword",
          "string",
          "whitespace",
          "text",
          "static_symbol",
          "preprocessor_text",
          "punctuation",
          "string_verbatim",
          "string_escape_character",
          "class_name",
          "delegate_name",
          "enum_name",
          "interface_name",
          "module_name",
          "struct_name",
          "type_parameter_name",
          "field_name",
          "enum_member_name",
          "constant_name",
          "local_name",
          "parameter_name",
          "method_name",
          "extension_method_name",
          "property_name",
          "event_name",
          "namespace_name",
          "label_name",
          "xml_doc_comment_attribute_name",
          "xml_doc_comment_attribute_quotes",
          "xml_doc_comment_attribute_value",
          "xml_doc_comment_cdata_section",
          "xml_doc_comment_comment",
          "xml_doc_comment_delimiter",
          "xml_doc_comment_entity_reference",
          "xml_doc_comment_name",
          "xml_doc_comment_processing_instruction",
          "xml_doc_comment_text",
          "xml_literal_attribute_name",
          "xml_literal_attribute_quotes",
          "xml_literal_attribute_value",
          "xml_literal_cdata_section",
          "xml_literal_comment",
          "xml_literal_delimiter",
          "xml_literal_embedded_expression",
          "xml_literal_entity_reference",
          "xml_literal_name",
          "xml_literal_processing_instruction",
          "xml_literal_text",
          "regex_comment",
          "regex_character_class",
          "regex_anchor",
          "regex_quantifier",
          "regex_grouping",
          "regex_alternation",
          "regex_text",
          "regex_self_escaped_character",
          "regex_other_escape",
        },
      },
      range = true,
    }
  end
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

local pid = vim.fn.getpid()
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
    terraformls = {},
    omnisharp = {
        cmd = { "mono", "/Users/ryanisaacg/bin/omnisharp-osx/omnisharp/OmniSharp.exe", "--languageserver", "--hostPID", tostring(pid) },
        handlers = {
            ["textDocument/definition"] = require('omnisharp_extended').handler,
        },

        -- Enables support for reading code style, naming convention and analyzer
        -- settings from .editorconfig.
        enable_editorconfig_support = true,

        -- If true, MSBuild project system will only load projects for files that
        -- were opened in the editor. This setting is useful for big C# codebases
        -- and allows for faster initialization of code navigation features only
        -- for projects that are relevant to code that is being edited. With this
        -- setting enabled OmniSharp may load fewer projects and may thus display
        -- incomplete reference lists for symbols.
        enable_ms_build_load_projects_on_demand = false,

        -- Enables support for roslyn analyzers, code fixes and rulesets.
        enable_roslyn_analyzers = false,

        -- Specifies whether 'using' directives should be grouped and sorted during
        -- document formatting.
        organize_imports_on_format = false,

        -- Enables support for showing unimported types and unimported extension
        -- methods in completion lists. When committed, the appropriate using
        -- directive will be added at the top of the current file. This option can
        -- have a negative impact on initial completion responsiveness,
        -- particularly for the first few completion sessions after opening a
        -- solution.
        enable_import_completion = true,

        -- Specifies whether to include preview versions of the .NET SDK when
        -- determining which version to use for project loading.
        sdk_include_prereleases = true,

        -- Only run analyzers against open files when 'enableRoslynAnalyzers' is
        -- true
        analyze_open_documents_only = false,
    },
    zls = {},
    brick_lsp = {},
}

-- Indicate that we should have autocompletion - required for nvim-cmp
-- Also mark dynamciRegistration as true for Unity/C# stuff
local capabilities = vim.tbl_deep_extend("force", require('cmp_nvim_lsp').default_capabilities(), {
    workspace = {
        didChangeWatchedFiles = {
            dynamicRegistration = true,
        },
    },
})

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


for server,settings in pairs(language_servers) do
    settings.on_attach = on_attach
    settings.capabilities = capabilities
    lsp[server].setup(settings)
end

