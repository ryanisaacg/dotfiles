-- LSP-specific keybinds live in lua/lsp.lua
local util = require("util")

vim.g.mapleader = ' '
util.leadmap('r', ':so %\n') -- Load a config
-- Split navigation

util.keymap('t', ':FZF<CR>') -- Fuzzy finding
util.leadmap('c', ':nohl<CR>') -- Clear highlighting
util.leadmap('s', ':buffers<CR>:b') -- Buffer list
util.leadmap('S', ':b#\n') -- Switch between the last two buffers
util.leadmap('-', ':split\n')
util.leadmap('|', ':vsplit\n')

util.leadmap('d', ":put =strftime('Time: %a %Y-%m-%d %H:%M:%S')<CR>") -- Insert timestamp

local telescope = require('telescope.builtin')
vim.keymap.set('n', '<leader>tg', telescope.live_grep, {noremap=true, silent=true})
vim.keymap.set('n', '<leader>tf', telescope.find_files, {noremap=true, silent=true})
vim.keymap.set('n', '<leader>tb', telescope.buffers, {noremap=true, silent=true})
vim.keymap.set('n', '<leader>tr', telescope.reloader, {noremap=true, silent=true})
