vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.api.nvim_create_autocmd("FileType", {
  pattern = "javascript,typescript,javascriptreact,typescriptreact,html,css",
  callback = function (args)
      vim.opt_local.shiftwidth = 2
      vim.opt_local.tabstop = 2
  end
})
vim.o.autoindent = true
vim.o.expandtab = true
vim.o.smarttab = true
vim.cmd('filetype plugin indent on')
