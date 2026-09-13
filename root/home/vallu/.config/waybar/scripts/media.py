#!/usr/bin/env python3
"""
Event-driven MPRIS Waybar module.
Reacts instantly to playback changes; zero CPU between events.

Waybar config:
    "exec": "~/.config/waybar/scripts/media.py",
    "interval": 0,          ← tells Waybar to treat it as a long-running process
    "signal": 8             ← optional: kill -SIGRTMIN+8 $(pidof media.py) to force refresh
"""
import json, sys

try:
    import dbus
    import dbus.mainloop.glib
    from gi.repository import GLib
except ImportError as e:
    print(json.dumps({"text": "", "tooltip": str(e), "class": "error"}), flush=True)
    sys.exit(1)

MPRIS_PREFIX = "org.mpris.MediaPlayer2"
MPRIS_PATH   = "/org/mpris/MediaPlayer2"
PLAYER_IFACE = "org.mpris.MediaPlayer2.Player"
PROP_IFACE   = "org.freedesktop.DBus.Properties"
MAX_DISPLAY  = 35

COMMANDS = {"playpause": "PlayPause", "next": "Next", "prev": "Previous"}


# ── helpers (same as before) ───────────────────────────────────────────────

def meta_string(metadata, key):
    val = metadata.get(key)
    if val is None:
        return None
    if isinstance(val, (list, dbus.Array)):
        return str(val[0]) if val else None
    return str(val) if str(val) else None

def truncate(text, n=MAX_DISPLAY):
    return text if len(text) <= n else text[:n] + "…"

def get_prop(bus, bus_name, prop):
    try:
        proxy = bus.get_object(bus_name, MPRIS_PATH)
        return dbus.Interface(proxy, PROP_IFACE).Get(PLAYER_IFACE, prop)
    except dbus.DBusException:
        return None

def list_players(bus):
    try:
        proxy = bus.get_object("org.freedesktop.DBus", "/org/freedesktop/DBus")
        names = proxy.ListNames(dbus_interface="org.freedesktop.DBus")
        return [str(n) for n in names if str(n).startswith(MPRIS_PREFIX)]
    except dbus.DBusException:
        return []

def call_method(bus, bus_name, method):
    try:
        proxy = bus.get_object(bus_name, MPRIS_PATH)
        dbus.Interface(proxy, PLAYER_IFACE).__getattr__(method)()
    except dbus.DBusException as e:
        print(f"MPRIS {method} failed: {e}", file=sys.stderr)


# ── query + output ─────────────────────────────────────────────────────────

def query_and_print(bus):
    for bus_name in list_players(bus):
        status = get_prop(bus, bus_name, "PlaybackStatus")
        if not status or str(status) == "Stopped":
            continue
        metadata = get_prop(bus, bus_name, "Metadata") or {}
        title  = meta_string(metadata, "xesam:title") or bus_name.rsplit(".", 1)[-1]
        artist = meta_string(metadata, "xesam:artist")
        icon   = "\uf04c" if str(status) == "Playing" else "\uf04b"
        raw    = f"{icon}  {title} - {artist}" if artist else f"{icon}  {title}"
        css    = "playing" if str(status) == "Playing" else "paused"
        print(json.dumps({"text": truncate(raw), "class": css}), flush=True)
        return
    print(json.dumps({"text": "", "tooltip": "", "class": "stopped"}), flush=True)


# ── signal handling ────────────────────────────────────────────────────────

def on_properties_changed(iface, changed, invalidated, bus=None, **kw):
    if iface == PLAYER_IFACE:
        query_and_print(bus)

def on_name_owner_changed(name, old, new, bus=None):
    if str(name).startswith(MPRIS_PREFIX):
        query_and_print(bus)


# ── main ───────────────────────────────────────────────────────────────────

def main():
    if len(sys.argv) >= 2:
        # Control path: one-shot, no event loop needed
        try:
            bus = dbus.SessionBus()
        except dbus.DBusException:
            sys.exit(1)
        method = COMMANDS.get(sys.argv[1].lower())
        if not method:
            print(f"Unknown command: {sys.argv[1]}", file=sys.stderr)
            sys.exit(1)
        players = list_players(bus)
        if players:
            call_method(bus, players[0], method)
        return

    # Monitoring path
    dbus.mainloop.glib.DBusGMainLoop(set_as_default=True)
    try:
        bus = dbus.SessionBus()
    except dbus.DBusException:
        print(json.dumps({"text": "", "tooltip": "D-Bus unavailable", "class": "error"}), flush=True)
        sys.exit(1)

    # Print current state immediately on startup
    query_and_print(bus)

    # Subscribe to property changes from any MPRIS player
    bus.add_signal_receiver(
        lambda iface, changed, inv: on_properties_changed(iface, changed, inv, bus=bus),
        signal_name="PropertiesChanged",
        dbus_interface=PROP_IFACE,
        path=MPRIS_PATH,
        sender_keyword=None,
    )

    # Subscribe to players appearing/disappearing
    bus.add_signal_receiver(
        lambda name, old, new: on_name_owner_changed(name, old, new, bus=bus),
        signal_name="NameOwnerChanged",
        dbus_interface="org.freedesktop.DBus",
    )

    GLib.MainLoop().run()

if __name__ == "__main__":
    main()
