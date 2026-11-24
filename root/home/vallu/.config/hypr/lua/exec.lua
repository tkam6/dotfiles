---@module 'hl'

-----------------
--- AUTOSTART ---
-----------------
hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpm reload")
    --hl.exec_cmd("waybar -c ~/.config/waybar/config_top.jsonc -s ~/.config/waybar/style_top.css")
    --hl.exec_cmd("waybar -c ~/.config/waybar/config_bottom.jsonc -s ~/.config/waybar/style_bottom.css")
    --hl.exec_cmd("qs -c noctalia-shell")
    --hl.exec_cmd("noctalia")
    --hl.exec_cmd("ambxst")
    --hl.exec_cmd("caelestia shell")
    --hl.exec_cmd("hyprpaper")
    --hl.exec_cmd("mako")
    --hl.exec_cmd("hypridle")
    --hl.exec_cmd("hyprsunset")
    --hl.exec_cmd("clipse -listen")
    hl.exec_cmd("activate-linux")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    --hl.exec_cmd("systemctl --user enable --now easyeffects")
    --hl.exec_cmd("serpantinumd start")
    --hl.exec_cmd("/home/vallu/.config/serpantinum/scripts/rotate-wallpaper.sh")
    hl.exec_cmd("snappy-switcher --daemon")
    hl.exec_cmd("bluetoothctl power off")
end)
