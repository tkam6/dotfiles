---@module 'hl'

------------------
--- APPEARANCE ---
------------------
hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 10,
        border_size = 2,
        col = {
            active_border   = { colors = {"rgba(33ccffee)", "rgba(00ff99ee)"}, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },
        resize_on_border = false,
        -- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before turning on
        allow_tearing = false,
        layout = "master",
    },

    decoration = {
        rounding = 12,
        rounding_power = 4,
        active_opacity = 1.0,
        inactive_opacity = 0.7,
        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = 0xee1a1a1a,
        },
        blur = {
            enabled = true,
            size = 8,
            passes = 2,
            vibrancy = 0.1696,
            new_optimizations = true,
        },
    },
})

-- Serpantinum settings
--hl.config({
--  general = {
--    border_size = 0,
--    gaps_in = 4,
--    gaps_out = 6,
--    float_gaps = 6,
--    resize_on_border = true,
--    extend_border_grab_area = 30,
--  },
--
--  decoration = {
--    rounding = 12,
--    active_opacity = 1.0,
--    inactive_opacity = 1.0,
--    blur = {
--      enabled = true,
--      size = 8,
--      passes = 2,
--      new_optimizations = true,
--    },
--    shadow = {
--      enabled = false,
--    },
--  },
--
--  input = {
--    kb_layout = "us",
--    kb_options = "grp:alt_shift_toggle",
--    accel_profile = "flat",
--    touchpad = {
--      natural_scroll = true,
--      disable_while_typing = false,
--    },
--  },
--
--  misc = {
--    focus_on_activate = false,
--    font_family = "JetBrains Mono",
--    disable_hyprland_logo = true,
--    disable_splash_rendering = true,
--  },
--})
