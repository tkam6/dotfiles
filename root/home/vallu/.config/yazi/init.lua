-- Custom linemode with size and permissions
function Linemode:sz_and_perms()
    local file = self._file

    -- Size
    local size = file:size()
    size = size and ya.readable_size(size) or "-"

    -- Permissions (Unix-style rwxr-xr-x)
    local mode = file.cha.mode or 0

    local function bit(val, mask)
        return (val & mask) ~= 0
    end

    local perms =
        (bit(mode, 0x100) and "r" or "-") ..
        (bit(mode, 0x80)  and "w" or "-") ..
        (bit(mode, 0x40)  and "x" or "-") ..
        (bit(mode, 0x20)  and "r" or "-") ..
        (bit(mode, 0x10)  and "w" or "-") ..
        (bit(mode, 0x8)   and "x" or "-") ..
        (bit(mode, 0x4)   and "r" or "-") ..
        (bit(mode, 0x2)   and "w" or "-") ..
        (bit(mode, 0x1)   and "x" or "-")

    return string.format("%s %s", size, perms)
end

--
-- Show username and group in status bar
Status:children_add(function()
    local h = cx.active.current.hovered
    if not h or ya.target_family() ~= "unix" then
        return ""
    end

    return ui.Line {
        ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"),
        ":",
        ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"),
        " ",
    }
end, 500, Status.RIGHT)

--
-- Display username and hostname at the top
Header:children_add(function()
    if ya.target_family() ~= "unix" then
        return ""
    end
    return ui.Span(ya.user_name() .. "@" .. ya.host_name() .. ": "):fg("green")
end, 500, Header.LEFT)

--
-- Full border (over all panes)
require("full-border"):setup {
	-- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
	type = ui.Border.ROUNDED,
}
