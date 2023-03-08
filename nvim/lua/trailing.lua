local function strip_trailing()
    local line = vim.fn.line('.')
    local col = vim.fn.col('.')
    vim.cmd [[%s/\s\+$//e]]
    vim.fn.cursor(line, col)
end
vim.api.nvim_create_user_command("StripTrailing", strip_trailing, {})
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "<buffer>",
    callback = strip_trailing,
})
vim.cmd [[
    " Highlight trailing whitespace
    highlight ExtraWhitespace ctermbg=red guibg=Red
    match ExtraWhitespace /\s\+$/
    autocmd InsertEnter * highlight clear ExtraWhitespace
    autocmd InsertLeave * highlight ExtraWhitespace ctermbg=red guibg=red
]]


