local util = require('util')

vim.api.nvim_create_user_command("Github", function (table)
    local args = table.fargs

    local origin = util.trim(vim.fn.system("git remote get-url origin")):gsub('.git$', '')

    -- Attempt to find default branch from Github. If it is not found, assume 'main'
    local remote_ref = vim.fn.system("git symbolic-ref refs/remotes/origin/HEAD")
    local branch
    if util.trim(remote_ref) == "fatal: ref refs/remotes/origin/HEAD is not a symbolic ref" then
        branch = "main"
    else
        local branch_path = util.trim(remote_ref)
        branch = vim.fn.fnamemodify(branch_path, ":t")
    end

    local git_root = vim.fn.trim(vim.fn.system("git rev-parse --show-toplevel"))
    local dir = vim.fn.getcwd()
    vim.api.nvim_set_current_dir(git_root)
    local path_to_file = vim.fn.expand('%'):gsub(git_root, '')
    vim.api.nvim_set_current_dir(dir)

    local url = origin.."/blob/"..branch.."/"..path_to_file
    print("Copied: " .. url)
    vim.fn.setreg("+", url)

    if args[1] == "go" then
       vim.fn["netrw#BrowseX"](url, true)
    end
end, { nargs = '?' })
