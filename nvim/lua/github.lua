local util = require('util')

vim.api.nvim_create_user_command("Github", function ()
    local origin = util.trim(vim.fn.system("git remote get-url origin")):gsub('.git$', '')

    local branch_path = util.trim(vim.fn.system("git symbolic-ref refs/remotes/origin/HEAD"))
    local branch = vim.fn.fnamemodify(branch_path, ":t")

    local git_root = vim.fn.trim(vim.fn.system("git rev-parse --show-toplevel"))
    local dir = vim.fn.getcwd()
    vim.api.nvim_set_current_dir(git_root)
    local path_to_file = vim.fn.expand('%'):gsub(git_root, '')
    vim.api.nvim_set_current_dir(dir)

    print(origin.."/blob/"..branch.."/"..path_to_file)
end, {})

