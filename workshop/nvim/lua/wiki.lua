local m = {}
local util = require('util')
local api = vim.api

local function is_weekday(date)
    return date ~= 'Saturday' and date ~= 'Sunday'
end

function m.genToday()
    -- Copy the Plans section from yesterday
    util.keys(' w y')
    util.keys('/Plans\n')
    util.keys(' c')
    util.keys('VGy')

    -- Go to today and generate the headers
    util.keys(' w w')
    local header = os.date('# %A, %d %B %Y') -- Monday, 20 July 2020
    util.keys('i'..header..'\n<Esc>')
    if is_weekday(os.date('%A')) then
        util.keys('i\n## Work\n<Esc>')
    end
    util.keys('i\n## Home\n<Esc>')

    -- Paste in the plans
    util.keys('p')
end

function m.genDays()
    days = { 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday', 'Next week' }
    util.keys(util.termcode('<Esc>'))
    for _, day in ipairs(days) do
        util.keys('i'..day..':\n<Esc>')
    end
end

function m.checkify()
    line = vim.api.nvim_get_current_line()
    local is_bottom = false
    while not is_bottom and util.starts_with(util.trim(line), '- ') and not util.starts_with(util.trim(line), '- [') do
        -- Check if we're at the bottom of the document
        local cursor = vim.api.nvim_win_get_cursor(0)
        is_bottom = cursor[1] == vim.api.nvim_buf_line_count(0)
        -- Convert to checkmark and move down a row
        api.nvim_command('VimwikiToggleListItem')
        local new_cursor = { cursor[1] + 1, cursor[2] }
        vim.api.nvim_win_set_cursor(0, new_cursor)
        line = vim.api.nvim_get_current_line()
    end
end

return m
