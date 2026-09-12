---@module 'hl'

---------------------
--- MISCELLANEOUS ---
---------------------

hl.config({
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        force_default_wallpaper = 0,            -- 0/1 = disables anime bg
        animate_manual_resizes = true,
        animate_mouse_windowdragging = true,
        size_limits_tiled = true,
        middle_click_paste = false,
        disable_autoreload = true,
        on_focus_under_fullscreen = 1,          -- 1 - takes over
        initial_workspace_tracking = 1,         -- 1 - single-shot
    },
})
