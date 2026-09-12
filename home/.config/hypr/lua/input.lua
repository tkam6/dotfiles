---@module 'hl'

-------------
--- INPUT ---
-------------
hl.config({
    input = {
        kb_layout = "us",
        kb_variant = "altgr-intl",
        numlock_by_default = true,
        repeat_delay = 250,
        repeat_rate = 50,
        sensitivity = 0.0,
        accel_profile = "adaptive",
        follow_mouse = 1,
        touchpad = {
            natural_scroll = true,
            disable_while_typing = true,
            scroll_factor = 0.4,
        },
    },

    cursor = {
        inactive_timeout = 90,
        no_warps = false,
        persistent_warps = false,
        zoom_factor = 1.0,
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})
