---@module 'hl'

--------------------
--- WINDOW RULES ---
--------------------
local suppressMaximizeRule = hl.window_rule({
    -- ignore maximize requests from all apps; you'll probably like this
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
    -- fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

-------------------------------------------------------------------------------
---- auto-hide Noctalia top bar on fullscreen, otherwise make it stay
-------------------------------------------------------------------------------
-- revised edition to fix alt+tab-ing into other windows when in fullscreen
-- local function is_fullscreen(w)
--     return w ~= nil and not w.floating and (w.fullscreen == 2 or w.fullscreen == 3)
-- end
-- 
-- local function workspace_has_fullscreen(ws)
--     if ws == nil then return false end
--     for _, w in ipairs(hl.get_workspace_windows(ws)) do
--         if is_fullscreen(w) then return true end
--     end
--     return false
-- end
-- 
-- local CMDS = {
--     hidden = "noctalia msg bar-auto-hide-set true; noctalia msg bar-hide; noctalia msg bar-layer-set overlay",
--     pinned = "noctalia msg bar-auto-hide-set false; noctalia msg bar-show; noctalia msg bar-layer-set overlay",
--     normal = "noctalia msg bar-auto-hide-set false; noctalia msg bar-show; noctalia msg bar-layer-set top",
-- }
-- 
-- local last_state = nil
-- local generation = 0
-- 
-- local function apply_bar()
--     local win = hl.get_active_window()
--     local ws = win and win.workspace
-- 
--     local state
--     if is_fullscreen(win) then
--         state = "hidden"
--     elseif workspace_has_fullscreen(ws) then
--         state = "pinned"
--     else
--         state = "normal"
--     end
-- 
--     if state == last_state then return end
--     last_state = state
-- 
--     -- one process, commands strictly in order
--     hl.dispatch(hl.dsp.exec_cmd("sh -c '" .. CMDS[state] .. "'"))
-- end
-- 
-- local function schedule_update()
--     generation = generation + 1
--     local my_gen = generation
--     -- debounce: wait for the burst of events (unfullscreen / focus / fullscreen) to settle
--     hl.timer(function()
--         if my_gen == generation then apply_bar() end
--     end, { timeout = 50, type = "oneshot" })
-- end
-- 
-- hl.on("window.active", schedule_update)
-- hl.on("window.fullscreen", schedule_update)

----------------
--- revised edition of above, to keep bar visible when a panel or something of
--- that sort is open
----------------
local function is_fullscreen(w)
    return w ~= nil and not w.floating and (w.fullscreen == 2 or w.fullscreen == 3)
end

local function workspace_has_fullscreen(ws)
    if ws == nil then return false end
    for _, w in ipairs(hl.get_workspace_windows(ws)) do
        if is_fullscreen(w) then return true end
    end
    return false
end

-- Namespaces of Noctalia panel layer surfaces. ADJUST THESE: run `hyprctl layers`
-- with a panel open and see what its namespace is. Don't match the bar itself.
-- local PANEL_PATTERNS = { "^noctalia%-panel", "^noctalia%-launcher", "^noctalia%-control" }
local PANEL_PATTERNS = { "^noctalia%-panel$", }

local function is_panel_layer(l)
    local ns = l and l.namespace
    if not ns then return false end
    for _, p in ipairs(PANEL_PATTERNS) do
        if ns:find(p) then return true end
    end
    return false
end

-- Query live state rather than tracking open/close events, so it can't drift
local function panel_open()
    for _, l in ipairs(hl.get_layers()) do
        if is_panel_layer(l) then return true end
    end
    return false
end

local CMDS = {
    hidden = "noctalia msg bar-auto-hide-set true; noctalia msg bar-hide; noctalia msg bar-layer-set overlay",
    pinned = "noctalia msg bar-auto-hide-set false; noctalia msg bar-show; noctalia msg bar-layer-set overlay",
    normal = "noctalia msg bar-auto-hide-set false; noctalia msg bar-show; noctalia msg bar-layer-set top",
}

local last_state = nil
local generation = 0

local function apply_bar()
    local win = hl.get_active_window()
    local ws = win and win.workspace

    local state
    if is_fullscreen(win) then
        -- fullscreen focused: hide, unless a panel is open
        state = panel_open() and "pinned" or "hidden"
    elseif workspace_has_fullscreen(ws) then
        state = "pinned"
    else
        state = "normal"
    end

    if state == last_state then return end
    last_state = state
    hl.dispatch(hl.dsp.exec_cmd("sh -c '" .. CMDS[state] .. "'"))
end

local function schedule_update()
    generation = generation + 1
    local my_gen = generation
    hl.timer(function()
        if my_gen == generation then apply_bar() end
    end, { timeout = 50, type = "oneshot" })
end

hl.on("window.active", schedule_update)
hl.on("window.fullscreen", schedule_update)
hl.on("layer.opened", schedule_update)   -- guessed event names
hl.on("layer.closed", schedule_update)
-------------------------------------------------------------------------------

hl.window_rule({
    -- float Clipse window
    name  = "float-clipse-win",
    match = {
        class = "clipse",
    },
    float = true,
    size = { "(monitor_w * 0.4)", "(monitor_h * 0.5)" },
})

hl.window_rule({
    -- float Noctalia settings
    match = { class = "dev.noctalia.Noctalia" },
    float = true,
    size = { 1300, 920 },
})

hl.window_rule({
    -- change maximised window border
    name = "change-maxi-border",
    match = {
        fullscreen_state_internal = 1,
    },
    border_color = { colors = { "rgba(d0a020ee)", "rgba(dd4010ee)" }, angle = 45 },
})

hl.window_rule({
    -- change global ("pinned") window border
    name = "change-pinned-border",
    match = {
        pin = true,
    },
    border_color = { colors = { "rgba(ffc0cbee)", "rgba(e0218aee)" }, angle = 45 },
})

hl.window_rule({
    -- Alacritty dropdown window
    name = "float-dropdown-workspace-windows",
    match = {
        class = "AlacrittyDropdown",
        workspace = "special:dropdown_term",
    },
    float = true,
    size = { "(monitor_w * 0.75)", "(monitor_h * 0.75)" },
})

hl.window_rule({
    -- "Save as|to" or "Open with|folder" GTK dialogs
    match  = { class = "xdg-desktop-portal-gtk", title = "(?i).*(save (as|to)|open (with|folder|file)).*" },
    float  = true,
    center = true,
    size   = { "(monitor_w * 0.47)", "(monitor_h * 0.49)" },
})

hl.window_rule({
    match  = { class = "Tk" },
    float  = true,
    center = true,
})

-----------------------
--- WORKSPACE RULES ---
-----------------------
hl.workspace_rule({
    -- dropdown terminal workspace
    workspace = "special:dropdown_term",
    gaps_out = 0,
    on_created_empty = "alacritty --option font.size=18 --class AlacrittyDropdown",
})

-------------------
--- LAYER RULES ---
-------------------
-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- hl.layer_rule({
--     match = { namespace = "waybar" },
--     blur = true,
-- })
--
-- hl.layer_rule({
--     match = { namespace = "waybar" },
--     ignore_alpha = 0,
-- })
