local options = {
    --- TABBING ---
    tabstop = 4, -- Tabs should be 4 spaces
    shiftwidth = 4, -- see above
    autoindent = true, -- Maintain indents
    expandtab = true,
    smarttab = true,
    number = true, -- Turn on line numbering (broken)
    --- SEARCHES ---
    hlsearch = true, -- Highlight the current search term
    incsearch = true, -- Incremental searching: jump to serach results as you type
    grepprg = 'rg --vimgrep --no-heading --smart-case', -- Use rg for vimgrep
    --- BUFFERS ---
    hidden = true, -- Don't kill buffers in the background!
    autoread = true, -- Automatically reload files when you switch to the buffer
    --- SPLITS --
    splitbelow = true, -- New splits should focus down
    splitright = true, -- New splits should focus right
    --- WRAPPING ---
    list = false, -- Disable list, because having it disables linebreaks
    textwidth = 0, -- To be honest I have no idea what this does or any other wrapping setting.
    wrapmargin = 0,
    wrap = true,
    linebreak = true,
    --- BACKUPS, which we disable --
    backup = false,
    writebackup = false,
    swapfile = false,
    --- MISC ---
    showcmd = true, -- Show the command that has been buffered up to execute in normal mode
    showmatch = true, -- Show the matching bracket when highlighting a bracket
    bg = 'dark', -- Dark background!
    mouse = 'a', -- Enable mouse events
    statusline = '%#StatusLine#%f%m%r%h%w%= [%Y] [%{&ff}] [line: %0l, column: %0v] [%p%%]' -- ???
    -- ['clipboard^'] = 'unnamed'
}

for key, value in pairs(options) do
    vim.api.nvim_set_option(key, value)
end
