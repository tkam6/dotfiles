---------------
--- HELPERS ---
---------------
local function hl(group, text)
    return string.format("%%#%s#%s%%*", group, text)
end


------------------
--- HIGHLIGHTS ---
------------------
vim.api.nvim_set_hl(0, "TabLineFill",     { fg = "#a0a0a0", bg = "#121212" })
vim.api.nvim_set_hl(0, "TabLineActive",   { fg = "#98e879", bold = true })
vim.api.nvim_set_hl(0, "TabLineInactive", { fg = "#707070" })
vim.api.nvim_set_hl(0, "TabLineModified", { fg = "#ffef78", bold = true })
vim.api.nvim_set_hl(0, "TabLineNumber",   { fg = "#61affa", bold = true })


-----------------------
--- PATH CONDENSING ---
-----------------------
local function condense_component(comp)
    -- hidden dirs keep their leading dot: ".config" -> ".c"
    if comp:sub(1, 1) == "." and #comp > 1 then
        return "." .. comp:sub(2, 2)
    end
    return comp:sub(1, 1)
end

local function condense_path(path)
    local cwd = vim.fn.getcwd()
    local home = vim.env.HOME or vim.fn.expand("~")

    -- normalize: no trailing slashes
    if cwd:sub(-1) == "/" then cwd = cwd:sub(1, -2) end
    if home:sub(-1) == "/" then home = home:sub(1, -2) end

    local prefix, rest

    if path == cwd then
        return "."
    elseif path:sub(1, #cwd + 1) == cwd .. "/" then
        prefix = "."
        rest = path:sub(#cwd + 2)
    elseif path == home then
        return "~"
    elseif path:sub(1, #home + 1) == home .. "/" then
        prefix = "~"
        rest = path:sub(#home + 2)
    else
        prefix = ""
        rest = path:sub(2) -- drop leading "/"
    end

    local parts = vim.split(rest, "/", { plain = true })
    local n = #parts

    for i = 1, n - 1 do
        parts[i] = condense_component(parts[i])
    end

    local joined = table.concat(parts, "/")

    if prefix == "" then
        return "/" .. joined
    end
    return prefix .. "/" .. joined
end

--------------
--- BUFFER ---
--------------
local function buffer_name(bufnr)
    local name = vim.api.nvim_buf_get_name(bufnr)
    if name == "" then
        return "[buf]"
    end
    if vim.bo[bufnr].filetype == "oil" then
        return "[dir] " .. condense_path(vim.fn.fnamemodify(name:gsub("^oil://", ""), ":p"))
    end
    return condense_path(vim.fn.fnamemodify(name, ":p"))
end

local function real_path()
    if vim.bo.filetype == "oil" then
        return vim.api.nvim_buf_get_name(0):gsub("^oil://", "")
    else
        return vim.fn.expand("%:p")
    end
end

local function buffer_state(bufnr)
    local states = {}
    local buf_path = vim.api.nvim_buf_get_name(bufnr)
    local realpath = real_path(buf_path)

    if vim.bo[bufnr].modified then
        table.insert(states, "+")
    end
    if realpath ~= "" and not vim.uv.fs_access(realpath, "R") then
        table.insert(states, "!")
    end
    if not vim.bo[bufnr].modifiable then
        table.insert(states, "R")
    end
    if #states == 0 then
        return ""
    end
    return " " .. table.concat(states, "")
end


-----------
--- TAB ---
-----------
local function tab(bufnr, number, active)
    local name = buffer_name(bufnr)
    local state = buffer_state(bufnr)

    local name_hl
    if active then
        name_hl = "TabLineActive"
    else
        name_hl = "TabLineInactive"
    end

    local result = {
        " ",
        hl("TabLineNumber", tostring(number)),
        " ",
        hl(name_hl, name),
    }

    if state ~= "" then
        table.insert(
            result,
            hl("TabLineModified", state)
        )
    end

    table.insert(result, "")
    return table.concat(result)
end


---------------
--- TABLINE ---
---------------
local tab_ln = {}

function tab_ln.active()
    local tabs = {}
    local current_tab = vim.api.nvim_get_current_tabpage()

    for i, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
        local win = vim.api.nvim_tabpage_get_win(tabpage)
        local bufnr = vim.api.nvim_win_get_buf(win)
        table.insert(
            tabs,
            tab(bufnr, i, tabpage == current_tab)
        )
    end

    return table.concat(tabs, " ")
        .. "%="
        .. ""
end


-------------
--- SETUP ---
-------------
vim.opt.tabline = "%!v:lua.require('tabline').active()"
return tab_ln
