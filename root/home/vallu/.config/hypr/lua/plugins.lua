---------------
--- PLUGINS ---
---------------

--- hyprfocus ---
if hl.plugin.hyprfocus ~= nil then
    hl.config({
        plugin = {
            hyprfocus = {
                enabled = true,
                animate_floating = true,
                keyboard_focus_animation = "shrink",
                mouse_focus_animation = "flash",
            }
        }
    })
end

--- hyprbars ---
if hl.plugin.hyprbars ~= nil then
    hl.config({
        plugin = {
            hyprbars = {
                enabled = true,
                bar_height = 35,
                bar_blur = true,
                bar_text_size = 15,
                bar_text_font = "Iosevka NFM",
                bar_padding = 12,
                bar_button_padding = 10,
                bar_part_of_window = false,
                icon_on_hover = true,
                on_double_click = [[hyprctl dispatch 'hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" })']],
            }
        },
    })

    hl.plugin.hyprbars.add_button({
        bg_color = "rgb(dd4040)",
        fg_color = "rgb(ffffff)",
        size = 20,
        icon = "",
        action = "hyprctl dispatch 'hl.dsp.window.close()'",
    })

    hl.plugin.hyprbars.add_button({
        bg_color = "rgb(cccccc)",
        fg_color = "rgb(000000)",
        size = 20,
        icon = "",
        action = [[hyprctl dispatch 'hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" })']],
    })

    hl.plugin.hyprbars.add_button({
        bg_color = "rgb(cccccc)",
        fg_color = "rgb(000000)",
        size = 20,
        icon = "󰘖",
        action = [[hyprctl dispatch 'hl.dsp.window.fullscreen({ mode = "fullscreen", action = "set" })']],
    })

    -- hl.plugin.hyprbars.add_button({
    --     bg_color = "rgb(cccccc)",
    --     fg_color = "rgb(000000)",
    --     size = 20,
    --     icon = "",
    --     action = [[hyprctl dispatch 'hl.dsp.window.move({ workspace = "special:magic" })']],
    -- })
end

--- gloview ---
if hl.plugin.gloview ~= nil then
    hl.config({
        plugin = {
            gloview = {
                duration = 260,
            },
        },
    })
end

--- hyprexpo ---
if hl.plugin.hyprexpo ~= nil then
    hl.config({
        plugin = {
            hyprexpo = {
                columns = 3,
                gaps_in = 5,
                gaps_out = 5,
                bg_col = "rgb(111111)",
                workspace_method = "center current",
                gesture_distance = 200,
                cancel_key = "escape",
                show_cursor = 1,
                drag_drop_enable = 1, -- Disable moving windows by dragging workspace previews.
            },
        },
    })
end

--- dynamic_cursors ---
if hl.plugin.dynamic_cursors ~= nil then
    hl.config({
        plugin = {
            dynamic_cursors = {
                enabled = true,
                mode = "tilt",
                shake = {
                    enabled = true,
                    threshold = 3.0,
                    limit = 6.0,
                    timeout = 150,
                    effects = true,
                },
            },
        },
    })
end

--- hyprglass ---
if hl.plugin.hyprglass then
    local hg = hl.plugin.hyprglass

    hg.config({
        default_theme = "dark",
        default_preset = "glass",
        tint_color = 0x8899aa22,

        brightness = 0.9,
        dark = { brightness = 0.82 },
        light = { adaptive_boost = 0.5 },

        layers = { enabled = true },
    })

    -- Layer surfaces: each call whitelists the namespace and configures it
    hg.layer("noctalia")

    hg.preset("glass", {
        blur_strength        = 2.0,
        blur_iterations      = 3,
        chromatic_aberration = 0.2,
        fresnel_strength     = 0.2,
        edge_thickness       = 0.08,
        lens_distortion      = 0.5,
        brightness           = 1.0,
        contrast             = 1.7,
        saturation           = 1,
        vibrancy             = 0.8,
        vibrancy_darkness    = 1,
        adaptive_boost       = 0.5,
    })

    hg.preset("apple", {
        blur_strength        = 2.2,
        blur_iterations      = 3,
        refraction_strength  = 0.55,
        chromatic_aberration = 0.3,
        fresnel_strength     = 0.5,
        specular_strength    = 0.75,
        edge_thickness       = 0.05,
        lens_distortion      = 0.3,
        dark  = { brightness = 0.82, contrast = 0.90, saturation = 0.80, vibrancy = 0.15, adaptive_dim = 0.4 },
        light = { brightness = 1.12, contrast = 0.92, saturation = 0.85, vibrancy = 0.12, adaptive_boost = 0.4 },
    })
end

------------------
--- hypr-edgehover
------------------
if hl.plugin.hypr_edgehover then
    hl.config({
        plugin = {
            hypr_edgehover = {
                edges = "lrb",
            },
        },
    })
end
