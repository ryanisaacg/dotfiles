-- LSP-specific keybinds live in lua/lsp.lua
local util = require("util")

vim.g.mapleader = ' '
util.leadmap('r', ':so %\n') -- Load a config
-- Split navigation

util.leadmap('c', ':nohl<CR>') -- Clear highlighting

if vim.g.vscode then
    local vscode = require("vscode-neovim")
    local function vscall(command)
        return function()
            vscode.call(command)
        end
    end
    -- Normal stuff
    util.keymap('t', vscall("workbench.action.quickOpen"))
    util.leadmap('-', vscall("workbench.action.splitEditorDown"))
    util.leadmap('|', vscall("workbench.action.splitEditorRight"))
    -- Telescope equivalent
    util.keymap('<leader>tg', vscall("workbench.view.search"))
    -- LSP stuff
    util.keymap('<space>rn', vscall("editor.action.rename"))
    util.keymap('<space>sa', vscall("editor.action.quickFix"))
    util.keymap('[d', vscall("editor.action.marker.prev"))
    util.keymap(']d', vscall("editor.action.marker.next"))
    util.keymap('gr', vscall("editor.action.referenceSearch.trigger"))
    util.leadmap('e', vscall("editor.action.showHover"))
else
    -- Spacemacs compatibility - map C-g to Esc
	-- vim.keymap.set({ 'n', 'i', 'v', 'x', 's', 'o', 't', 'c' }, '<C-g>', '<Esc>', {noremap = true, silent=true})

    util.keymap('t', ':FZF<CR>') -- Fuzzy finding
    util.leadmap('w-', ':split\n')
    util.leadmap('-', ':split\n')
    util.leadmap('w/', ':vsplit\n')
    util.leadmap('|', ':vsplit\n')
    util.leadmap('w/', ':vsplit\n')
    util.leadmap('w-', ':split\n')

    local telescope_settings = {
        attach_mappings = function (_, map)
            local actions = require('telescope.actions')
            -- As above - spacemacs compat to close out of telescope actions
            map({"i", "n"}, "<C-g>", actions.close)

            return true
        end
    }
    local telescope = require('telescope.builtin')
    util.leadmap('sd', function () telescope.live_grep(telescope_settings) end)
    util.leadmap('pf', function () telescope.find_files(telescope_settings) end)
    util.leadmap('pb', function () telescope.buffers(telescope_settings) end)
    util.leadmap('tr', function () telescope.reloader(telescope_settings) end)

    util.leadmap('tn', ':TestNearest<CR>')
    util.leadmap('tf', ':TestFile<CR>')
    util.leadmap('tl', ':TestLast<CR>')
    util.leadmap('ts', ':TestSuite<CR>')
    util.leadmap('tv', ':TestVisit<CR>')
end

