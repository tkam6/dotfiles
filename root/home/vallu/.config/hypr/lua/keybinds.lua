---@module 'hl'

-------------------
--- KEYBINDINGS ---
-------------------
local terminal = "alacritty"
local fl_mgr = "nautilus"
local fl_mgr_alt = "dolphin"
local menu_run = "rofi -show run"
local menu_drun = "rofi -show drun"

-- logoff
-- with hyprshutdown (recommended, programs are "asked nicely" to kill themselves)
hl.bind("CTRL + ALT + delete", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown"))
-- with dispatch exit - no opportunity for programs to close themselves
hl.bind("SHIFT + CTRL + ALT + delete", hl.dsp.exit())
-- go nuclear option
hl.bind("SUPER + CTRL + ALT + delete", hl.dsp.exec_cmd("loginctl terminate-session self"))

-- reload Hyprland
hl.bind("SUPER + P", hl.dsp.exec_cmd("hyprctl reload"))

-- general
hl.bind("SUPER + C", hl.dsp.window.close())
hl.bind("SUPER + E", hl.dsp.exec_cmd(fl_mgr))
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind("SUPER + G", hl.dsp.window.pin({ action = "toggle" }))
hl.bind("SUPER + Q", hl.dsp.exec_cmd(terminal))
hl.bind("SUPER + R", hl.dsp.exec_cmd(menu_drun))
hl.bind("SUPER + T", hl.dsp.exec_cmd(menu_run))
hl.bind("SUPER + X", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
hl.bind("SUPER + F12",           hl.dsp.exec_cmd("loginctl lock-session"))
hl.bind("SUPER + backslash",     hl.dsp.window.float({ action = "toggle" }))
-- why the hell is it called "grave"?
-- hl.bind("SUPER + grave",         hl.dsp.exec_cmd("skwd-wall-v2"))
hl.bind("SUPER + SHIFT + C",     hl.dsp.window.kill())
hl.bind("SUPER + SHIFT + E",     hl.dsp.exec_cmd(fl_mgr_alt))
hl.bind("SUPER + SHIFT + Q",     hl.dsp.exec_cmd("~/bin/gprog tmux"))
hl.bind("CTRL + SHIFT + escape", hl.dsp.exec_cmd("kitty -e btop"))

-- zoomer
hl.bind("SUPER + equal", hl.dsp.exec_cmd("/home/vallu/.config/hypr/scripts/zoom.sh +"))
hl.bind("SUPER + minus", hl.dsp.exec_cmd("/home/vallu/.config/hypr/scripts/zoom.sh -"))
hl.bind("SUPER + backspace", hl.dsp.exec_cmd("hyprctl eval 'hl.config({ [\"cursor.zoom_factor\"] = 1 })'"))

-- PLUGINS
-- plugin gloview
if hl.plugin.gloview ~= nil then
    hl.bind("SUPER + tab",          hl.plugin.gloview.toggle)
    hl.bind("SUPER + bracketright", hl.plugin.gloview.next)
    hl.bind("SUPER + bracketleft",  hl.plugin.gloview.prev)
    hl.bind("SUPER + SHIFT + tab",  hl.plugin.gloview.allworkspaces)
    hl.bind("mouse:277",            hl.plugin.gloview.toggle, { mouse = true })
end
-- plugin hyprexpo
if hl.plugin.hyprexpo ~= nil then
    hl.bind("SUPER + tab", function() hl.plugin.hyprexpo.expo("toggle") end)
end

-- clipboard
-- hl.bind("SUPER + V", hl.dsp.exec_cmd("alacritty -o 'font.size=16' --class clipse -e clipse"))
hl.bind("SUPER + V", hl.dsp.exec_cmd("rofi -modi clipboard:/home/vallu/bin/cliphist-rofi-img -show clipboard -show-icons -theme-str 'window { width: 50%; height: 50%; } element { padding: 7px; }'"))
-- screenshots
hl.bind("Print", hl.dsp.exec_cmd("/home/vallu/.config/mango/scripts/scrshot.sh"))
hl.bind("SUPER + Print", hl.dsp.exec_cmd("/home/vallu/.config/mango/scripts/scrshot_clip.sh"))

-- cycle thru windows
hl.bind("ALT + tab",         hl.dsp.window.cycle_next())
hl.bind("ALT + SHIFT + tab", hl.dsp.window.cycle_next({ next = false }))

-- window resize
hl.bind("SUPER + CTRL + right", hl.dsp.window.resize({ x = 50,  y = 0,   relative = true }))
hl.bind("SUPER + CTRL + left",  hl.dsp.window.resize({ x = -50, y = 0,   relative = true }))
hl.bind("SUPER + CTRL + up",    hl.dsp.window.resize({ x = 0,   y = -50, relative = true }))
hl.bind("SUPER + CTRL + down",  hl.dsp.window.resize({ x = 0,   y = 50,  relative = true }))

-- focus windows
hl.bind("SUPER + left",  hl.dsp.focus({ direction = "left"  }))
hl.bind("SUPER + right", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + up",    hl.dsp.focus({ direction = "up"    }))
hl.bind("SUPER + down",  hl.dsp.focus({ direction = "down"  }))
hl.bind("SUPER + A",     hl.dsp.focus({ direction = "left"  }))
hl.bind("SUPER + D",     hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + W",     hl.dsp.focus({ direction = "up"    }))
hl.bind("SUPER + S",     hl.dsp.focus({ direction = "down"  }))
hl.bind("SUPER + H",     hl.dsp.focus({ direction = "left"  }))
hl.bind("SUPER + L",     hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + K",     hl.dsp.focus({ direction = "up"    }))
hl.bind("SUPER + J",     hl.dsp.focus({ direction = "down"  }))

-- swap windows
hl.bind("SUPER + SHIFT + left",  hl.dsp.window.swap({ direction = "left"  }))
hl.bind("SUPER + SHIFT + right", hl.dsp.window.swap({ direction = "right" }))
hl.bind("SUPER + SHIFT + up",    hl.dsp.window.swap({ direction = "up"    }))
hl.bind("SUPER + SHIFT + down",  hl.dsp.window.swap({ direction = "down"  }))
hl.bind("SUPER + SHIFT + A",     hl.dsp.window.swap({ direction = "left"  }))
hl.bind("SUPER + SHIFT + D",     hl.dsp.window.swap({ direction = "right" }))
hl.bind("SUPER + SHIFT + W",     hl.dsp.window.swap({ direction = "up"    }))
hl.bind("SUPER + SHIFT + S",     hl.dsp.window.swap({ direction = "down"  }))
hl.bind("SUPER + SHIFT + H",     hl.dsp.window.swap({ direction = "left"  }))
hl.bind("SUPER + SHIFT + L",     hl.dsp.window.swap({ direction = "right" }))
hl.bind("SUPER + SHIFT + K",     hl.dsp.window.swap({ direction = "up"    }))
hl.bind("SUPER + SHIFT + J",     hl.dsp.window.swap({ direction = "down"  }))

-- switch workspaces and move windows to workspaces
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind("SUPER" .. " + " .. key,         hl.dsp.focus({ workspace = i}))
    hl.bind("SUPER" .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- temporary workspace
hl.bind("SUPER + Y",         hl.dsp.workspace.toggle_special("magic"))
hl.bind("SUPER + SHIFT + Y", hl.dsp.window.move({ workspace = "special:magic", follow = false }))

-- scroll through workspaces
-- hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
-- hl.bind("SUPER + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- dropdown terminal
hl.bind("SUPER + escape", hl.dsp.workspace.toggle_special("dropdown_term"))

-- move/resize with LMB/RMB
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind("SUPER + SHIFT + mouse:273", hl.dsp.window.resize({ keep_aspect_ratio = true }), { mouse = true })

-- volume and brightness controls
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +5%"), { locked = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -5%"), { locked = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e2 set 5%+"), { locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e2 --min-value=1000 set 5%-"), { locked = true })

-- playback controls
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86AudioStop",  hl.dsp.exec_cmd("playerctl stop"), { locked = true })

-- Noctalia v5 keybinds
local ipc = "noctalia msg "
hl.bind("SUPER + Z",         hl.dsp.exec_cmd(ipc .. "panel-toggle control-center network"))
hl.bind("SUPER + B",         hl.dsp.exec_cmd(ipc .. "panel-toggle control-center bluetooth"))
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd(ipc .. "wifi-toggle"))
hl.bind("SUPER + SHIFT + B", hl.dsp.exec_cmd(ipc .. "bluetooth-toggle"))
hl.bind("SUPER + space",     hl.dsp.exec_cmd(ipc .. "panel-toggle launcher"))
hl.bind("SUPER + comma",     hl.dsp.exec_cmd(ipc .. "settings-toggle"))
-- hl.bind("ALT + tab",         hl.dsp.exec_cmd(ipc .. "window-switcher"))
