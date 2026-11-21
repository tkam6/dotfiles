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
local function strip_oil(name)
    return (name:gsub("^oil://", ""))
end

local function buffer_name(bufnr)
    local name = vim.api.nvim_buf_get_name(bufnr)
    if name == "" then
        return "[buf]"
    end
    if vim.bo[bufnr].filetype == "oil" then
        return "[dir] " .. condense_path(vim.fn.fnamemodify(strip_oil(name), ":p"))
    end
    return condense_path(vim.fn.fnamemodify(name, ":p"))
end

-- real filesystem path of THIS buffer ("" if it has none)
local function real_path(bufnr)
    local name = vim.api.nvim_buf_get_name(bufnr)
    if name == "" then
        return ""
    end
    if vim.bo[bufnr].filetype == "oil" then
        return strip_oil(name)
    end
    -- skip terminals, help, quickfix, etc. (they aren't files)
    if vim.bo[bufnr].buftype ~= "" then
        return ""
    end
    return vim.fn.fnamemodify(name, ":p")
end

local function buffer_state(bufnr)
    local states = {}
    local realpath = real_path(bufnr)

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
-- returns the rendered string and its visible width
local function tab(bufnr, number, active)
    local name = buffer_name(bufnr)
    local state = buffer_state(bufnr)

    local width = 1 + #tostring(number) + 1
        + vim.fn.strdisplaywidth(name)
        + vim.fn.strdisplaywidth(state)

    -- escape % so it isn't read as a statusline item
    local safe_name = name:gsub("%%", "%%%%")

    local result = {
        " ",
        hl("TabLineNumber", tostring(number)),
        " ",
        hl(active and "TabLineActive" or "TabLineInactive", safe_name),
    }

    if state ~= "" then
        table.insert(result, hl("TabLineModified", state))
    end

    return table.concat(result), width
end


---------------
--- TABLINE ---
---------------
local tab_ln = {}

local first = 1   -- first visible tab; persists between redraws
local IND = 6     -- width of the "< " / " >" indicators

function tab_ln.active()
    local current_tab = vim.api.nvim_get_current_tabpage()
    local rendered, widths, active = {}, {}, 1

    for i, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
        local win = vim.api.nvim_tabpage_get_win(tabpage)
        local bufnr = vim.api.nvim_win_get_buf(win)
        local str, width = tab(bufnr, i, tabpage == current_tab)
        rendered[i] = str
        widths[i] = width
        if tabpage == current_tab then
            active = i
        end
    end

    local n = #rendered
    local total = vim.o.columns

    -- do tabs a..b (plus separators and indicators) fit on screen?
    local function fits(a, b)
        local w = b - a -- one-space separators
        for i = a, b do
            w = w + widths[i]
        end
        if a > 1 then w = w + IND end
        if b < n then w = w + IND end
        return w <= total
    end

    if first > n then first = n end
    if first > active then first = active end

    -- scroll right until the active tab fits
    while first < active and not fits(first, active) do
        first = first + 1
    end

    -- extend to the right as far as possible
    local last = active
    while last < n and fits(first, last + 1) do
        last = last + 1
    end

    -- use leftover space on the left (e.g. after closing tabs)
    while first > 1 and fits(first - 1, last) do
        first = first - 1
    end

    local visible = {}
    for i = first, last do
        table.insert(visible, rendered[i])
    end

    --local left = first > 1 and (hl("TabLineNumber", "<") .. " ") or ""
    --local right = last < n and (" " .. hl("TabLineNumber", ">")) or ""
    local hidden_left = first - 1
    local hidden_right = n - last

    local left = hidden_left > 0
        and (hl("TabLineNumber", " <" .. hidden_left .. "> ") .. " ")
        or ""
    local right = hidden_right > 0
        and (" " .. hl("TabLineNumber", " <" .. hidden_right .. "> "))
        or ""

    return left .. table.concat(visible, " ") .. right .. "%="
end


-------------
--- SETUP ---
-------------
vim.opt.tabline = "%!v:lua.require('tabline').active()"
return tab_ln
