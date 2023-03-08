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
