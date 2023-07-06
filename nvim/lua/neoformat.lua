-- Neoformat on save
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.js,*.jsx,*.ts,*.tsx,*.cs,*.tf",
    callback = function()
        -- Ensure CWD matches the file being edited, so the prettier config will be picked up
        local cwd = vim.fn.getcwd()
        local parent_folder = vim.fn.expand("%:h")
        vim.api.nvim_set_current_dir(parent_folder)
        vim.cmd "try | undojoin | Neoformat | catch /E790/ | Neoformat | endtry"
        vim.api.nvim_set_current_dir(cwd)
    end
})
vim.g.neoformat_try_node_exe = 1
vim.api.nvim_create_autocmd("BufWritePre", {
    -- Doing my little CWD hack breaks Neoformat's rustfmt integration, so rust is separate
    pattern = "*.rs",
    callback = function()
        vim.cmd "try | undojoin | Neoformat | catch /E790/ | Neoformat | endtry"
    end
})

vim.g.neoformat_enabled_csharp = { "csharpier" }
