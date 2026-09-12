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

----------
-- auto-hide Noctalia top bar on fullscreen, otherwise make it stay
local function is_fullscreen(w)
    return w ~= nil and not w.floating and (w.fullscreen == 2 or w.fullscreen == 3)
end

local function workspace_has_fullscreen(ws)
    if ws == nil then return false end
    for _, w in ipairs(hl.get_workspace_windows(ws)) do
        if is_fullscreen(w) then
            return true
        end
    end
    return false
end

local function update_bar(win)
    local ws = win and win.workspace
    local fs_in_ws = workspace_has_fullscreen(ws)

    if is_fullscreen(win) then
        -- focused window is itself fullscreen: hide, auto-hide, overlay so it can peek above it
        hl.dispatch(hl.dsp.exec_cmd("noctalia msg bar-auto-hide-set true"))
        hl.dispatch(hl.dsp.exec_cmd("noctalia msg bar-hide"))
        hl.dispatch(hl.dsp.exec_cmd("noctalia msg bar-layer-set overlay"))
    elseif fs_in_ws then
        -- a floating window is focused, but a fullscreen window is still present
        -- underneath in this workspace: bar must stay on overlay or it gets covered
        hl.dispatch(hl.dsp.exec_cmd("noctalia msg bar-auto-hide-set false"))
        hl.dispatch(hl.dsp.exec_cmd("noctalia msg bar-show"))
        hl.dispatch(hl.dsp.exec_cmd("noctalia msg bar-layer-set overlay"))
    else
        -- no fullscreen window anywhere in the workspace: normal top layer
        hl.dispatch(hl.dsp.exec_cmd("noctalia msg bar-auto-hide-set false"))
        hl.dispatch(hl.dsp.exec_cmd("noctalia msg bar-show"))
        hl.dispatch(hl.dsp.exec_cmd("noctalia msg bar-layer-set top"))
    end
end

hl.on("window.active", function(win)
    update_bar(win)
end)

hl.on("window.fullscreen", function(win)
    -- recompute for the currently active window, not just when the changed
    -- window happens to be active — a background window's fullscreen toggle
    -- still changes what the workspace looks like
    update_bar(hl.get_active_window())
end)
----------

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
