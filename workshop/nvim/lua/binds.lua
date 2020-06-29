local leader = ' '

function bind(shortcut, expansion)
    shortcut = shortcut:gsub('<lead>', leader)
    vim.api.nvim_set_keymap('n', shortcut, expansion, { silent = true })
end

bind('k', 'gk')
bind('<lead>r', ':lua reload()\n')
bind('<lead>w-', '<Plug>VimwikiSplitLink')
bind('t', 'k')

--nmap <silent> <leader>r :so %<CR>
