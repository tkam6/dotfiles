---@module 'hl'

---------------
--- LAYOUTS ---
---------------
-- dwindle layout
hl.config({
    dwindle = {
        preserve_split = true, -- You probably want this
    },
})

-- master layout
hl.config({
    master = {
        new_status = "master",
        orientation = "right",
        new_on_top = true,
        new_on_active = "none",
        focus_master_on_close = true,
    },
})

-- scrolling layout
hl.config({
    scrolling = {
        -- fullscreen_on_one_column = true,
        direction = "right",
    },
})
