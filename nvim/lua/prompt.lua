function _G.lsp_client_for_prompt()
    local bufnr = vim.fn.bufnr()
    local clients = vim.lsp.get_active_clients()
    local attached_clients = {}

    for _, client in ipairs(clients) do
        if client.attached_buffers[bufnr] then
            table.insert(attached_clients, client.name)
        end
    end

    if #attached_clients > 0 then
        local result = '[LSP:'
        for i=1,(#attached_clients -1) do
            result = result..attached_clients[i]..','
        end
        result = result..attached_clients[#attached_clients]..']'
        return result
    else
        return ''
    end
end

-- filename, buncha stuff              LSP clients                filetype  CR/LF    cursor       doc position
vim.o.statusline = '%f%m%r%h%w%= %{v:lua.lsp_client_for_prompt()} [FT:%Y] [%{&ff}] [l:%0l,c:%0v] [%p%%]'
