-- helper to wrap text in statusline highlight group
local function hl(group, text)
    return string.format("%%#%s#%s%%*", group, text)
end

-- create and link the highlight group(s)
vim.api.nvim_set_hl(0, "StatusLine",                 { fg = "#a0a0a0", bg = "#121212" })
vim.api.nvim_set_hl(0, "StatusLineModeNormal",       { fg = "#61affa", bold = true })
vim.api.nvim_set_hl(0, "StatusLineModeInsert",       { fg = "#98e897", bold = true })
vim.api.nvim_set_hl(0, "StatusLineModeVisual",       { fg = "#ff9fff", bold = true })
vim.api.nvim_set_hl(0, "StatusLineModeCommand",      { fg = "#e6e600", bold = true })
vim.api.nvim_set_hl(0, "StatusLineModeReplace",      { fg = "#cf2f2f", bold = true })
vim.api.nvim_set_hl(0, "StatusLineFilepathActive",   { fg = "#98e879", bold = true })
vim.api.nvim_set_hl(0, "StatusLineFilepathInactive", { fg = "#ffffff", bold = true })
vim.api.nvim_set_hl(0, "StatusLineOilPath",          { fg = "#61affa", bold = true })
vim.api.nvim_set_hl(0, "StatusLineSpinner",          { fg = "#cf2f2f", bold = true })
vim.api.nvim_set_hl(0, "StatusLineGit",              { fg = "#ff9fff", bold = true })
vim.api.nvim_set_hl(0, "StatusLineFiletype",         { fg = "#ffffff", bold = true })
vim.api.nvim_set_hl(0, "StatusLineFilepos",          { fg = "#ffef78", bold = true })
vim.api.nvim_set_hl(0, "StatusLineCurposRow",        { fg = "#ffef78", bold = true })
vim.api.nvim_set_hl(0, "StatusLineCurposCol",        { fg = "#ffef78", bold = true })


------------
--- MODE ---
------------
local mode_hl = {
    n       = "StatusLineModeNormal",
    i       = "StatusLineModeInsert",
    v       = "StatusLineModeVisual",
    V       = "StatusLineModeVisual",
    ["\22"] = "StatusLineModeVisual",
    c       = "StatusLineModeCommand",
    R       = "StatusLineModeReplace",
}

local mode_map = {
    -- normal
    n         = "•",
    no        = "•",
    nov       = "•",
    noV       = "•",
    ["no\22"] = "•",
    niI       = "•",
    niR       = "•",
    niV       = "•",
    -- insert
    i         = "+",
    ic        = "+",
    ix        = "+",
    -- visual
    v         = "~",
    vs        = "~",
    V         = "-",
    Vs        = "-",
    ["\22"]   = "|",
    ["\22s"]  = "|",
    -- replace
    R         = "R",
    Rc        = "R",
    Rx        = "R",
    Rv        = "V-R",
    s         = "S",
    S         = "S-L",
    ["\19"]   = "S-B",
    -- command and ex mode
    c         = ":",
    cv        = ">",
    ce        = ">",
    -- prompt
    r         = "?",
    rm        = "...",
    ["r?"]    = "?",
    -- shell mode and terminal
    ["!"]     = "!",
    t         = "T",
}

local function mode()
    local m = vim.fn.mode()
    local label = "[" .. (mode_map[m] or m) .. "]"
    local group = mode_hl[m:sub(1, 1)] or "StatusLine"
    return hl(group, label)
end

---------------------
--- FILE/DIR PATH ---
---------------------
local function real_path()
    if vim.bo.filetype == "oil" then
        return vim.api.nvim_buf_get_name(0):gsub("^oil://", "")
    else
        return vim.fn.expand("%:p")
    end
end

local function file_state()
    local states = {}
    local path = real_path()

    if vim.bo.modified then
        table.insert(states, "+")
    end

    if path ~= "" and not vim.uv.fs_access(path, "R") then
        table.insert(states, "!")
    end

    local readonly
    if vim.bo.filetype == "oil" then
        -- oil buffers never set 'readonly' themselves, so check the
        -- real filesystem permission instead
        readonly = path ~= "" and vim.uv.fs_access(path, "W") == false
    else
        readonly = vim.bo.readonly
    end
    if readonly then
        table.insert(states, "R")
    end

    return #states > 0 and table.concat(states, "") or ""
end

local function filepath()
    local hl_group
    local path
    local header
    local state = file_state()
    if state ~= "" then state = " {" .. state .. "}" end

    if vim.bo.filetype == "oil" then
        path = vim.api.nvim_buf_get_name(0):gsub("^oil://", "")
        hl_group = "StatusLineOilPath"
        header = "dir"
    elseif vim.fn.expand("%") == "" then
        return { "fl", hl("StatusLineFilepathActive", "[buf]"), state }
    else
        path = vim.fn.expand("%:p")
        hl_group = "StatusLineFilepathActive"
        header = "fl"
    end

    path = vim.fn.fnamemodify(path, ":p")
    local cwd = vim.fn.getcwd() .. "/"
    if vim.startswith(path, cwd) then
        path = "./" .. path:sub(#cwd + 1)
    else
        path = vim.fn.fnamemodify(path, ":~")
    end
    return { header, hl(hl_group, path), state }
end

------------------
--- GIT BRANCH ---
------------------
local git_branch_name = hl("StatusLineGit", "?")

local function update_git_branch()
    local handle = io.popen("git branch --show-current 2>/dev/null")
    if not handle then
        git_branch_name = hl("StatusLineGit", "!")
    end
    local branch = handle:read("*l")
    handle:close()
    git_branch_name = hl("StatusLineGit", branch ~= "" and branch or "?")
end

update_git_branch()
vim.api.nvim_create_autocmd({
    "BufEnter",
    "DirChanged",
}, {
    callback = update_git_branch,
})

local function git()
    return git_branch_name
end

----------------
--- SPINNERS ---
----------------
local function new_spinner(frames, interval)
    local spinner = {
        frames = frames,
        index = 1,
        timer = vim.uv.new_timer(),
    }
    spinner.timer:start(0, interval, vim.schedule_wrap(function()
        spinner.index = spinner.index % #spinner.frames + 1
        vim.cmd("redrawstatus")
    end))
    return spinner
end

local spinner1_state = new_spinner({
    '⡀', '⠄', '⠂', '⠁', '⠈', '⠐', '⠠', '⢀',
}, 120)

local spinner2_state = new_spinner({
    '⠉ ', '⠒ ', '⠤ ', '⣀ ', ' ⣀', ' ⠤', ' ⠒', ' ⠉',
}, 150)

local spinner3_state = new_spinner({
    '⠋', '⠙', '⠸', '⠴', '⠦', '⠇', '⠋', '⠙', '⠸', '⢰', '⣠', '⣄', '⡆', '⠖', '⠲', '⢰', '⣠', '⣄', '⡆', '⠇',
}, 100)

local function spinner1()
    return hl("StatusLineSpinner", spinner1_state.frames[spinner1_state.index])
end

local function spinner2()
    return hl("StatusLineSpinner", spinner2_state.frames[spinner2_state.index])
end

local function spinner3()
    return hl("StatusLineSpinner", spinner3_state.frames[spinner3_state.index])
end

vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        for _, spinner in ipairs({
            spinner1_state,
            spinner2_state,
            spinner3_state,
        }) do
            if not spinner.timer:is_closing() then
                spinner.timer:stop()
                spinner.timer:close()
            end
        end
    end,
})

--
local function filetype()
    return hl("StatusLineFiletype", vim.bo.filetype ~= "" and vim.bo.filetype or "?")
end

local function curpos()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local row_len = #tostring(vim.api.nvim_buf_line_count(0))
    local col_len = #tostring(vim.fn.col("$"))
    return {
        hl("StatusLineCurposRow", string.format("%" .. row_len .. "d", row)),
        hl("StatusLineCurposCol", string.format("%" .. col_len .. "d", col + 1)),
    }
end

local function filepos()
    return hl(
        "StatusLineFilepos",
        string.format(
            "%3d%%%%",
            math.floor(vim.api.nvim_win_get_cursor(0)[1] / vim.api.nvim_buf_line_count(0) * 100)
        )
    )
end


------------------
--- STATUSLINE ---
------------------
status_ln = {}

function status_ln.active()
    local type, path, state  = unpack(filepath())
    local row, col = unpack(curpos())
    return table.concat {
        string.format(
            "mode=%s %s %s=%s%s %s br=%s",
            mode(),
            spinner1(),
            type,
            path,
            state,
            spinner2(),
            git()
        ),
        "%=",
        string.format(
            "ft=%s %s (%s) %s [%s:%s] ",
            filetype(),
            spinner3(),
            vim.api.nvim_buf_line_count(0),
            filepos(),
            row,
            col
        )
    }
end

function status_ln.inactive()
    return " " .. hl("StatusLineFilepathInactive", "%t")
end

local group = vim.api.nvim_create_augroup("status_ln", { clear = true })

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
    group = group,
    desc = "Activate statusline on focus",
    callback = function()
        vim.opt_local.statusline = "%!v:lua.status_ln.active()"
    end,
})

vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
    group = group,
    desc = "Deactivate statusline when unfocused",
    callback = function()
        vim.opt_local.statusline = "%!v:lua.status_ln.inactive()"
    end,
})

return status_ln
