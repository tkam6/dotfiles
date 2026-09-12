---@module 'hl'

------------------
--- APPEARANCE ---
------------------
hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 20,
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
        rounding = 15,
        rounding_power = 4,
        active_opacity = 1.0,
        inactive_opacity = 0.8,
        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = 0xee1a1a1a,
        },
        blur = {
            enabled = true,
            size = 3,
            passes = 1,
            vibrancy = 0.1696,
        },
    },
})
