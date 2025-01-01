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
    util.keymap('t', ':FZF<CR>') -- Fuzzy finding
    util.leadmap('-', ':split\n')
    util.leadmap('|', ':vsplit\n')

    local telescope = require('telescope.builtin')
    vim.keymap.set('n', '<leader>tg', telescope.live_grep, {noremap=true, silent=true})
    vim.keymap.set('n', '<leader>tf', telescope.find_files, {noremap=true, silent=true})
    vim.keymap.set('n', '<leader>tb', telescope.buffers, {noremap=true, silent=true})
    vim.keymap.set('n', '<leader>tr', telescope.reloader, {noremap=true, silent=true})

    util.leadmap('rt', ':TestNearest<CR>')
end

