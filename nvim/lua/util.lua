local m = {}
local api = vim.api

function m.keys(command)
    return api.nvim_feedkeys(util.termcode(command), 'm', false)
end

function m.termcode(string)
    return api.nvim_replace_termcodes(string, true, true, true)
end

function m.unload(pkg)
    package.loaded[pkg] = nil
end

function m.starts_with(str, start)
   return str:sub(1, #start) == start
end

function m.ends_with(str, ending)
   return ending == "" or str:sub(-#ending) == ending
end

function m.trim(s)
   return (s:gsub("^%s*(.-)%s*$", "%1"))
end

return m
