from os import getenv
from pathlib import Path

from libqtile.command.client import InteractiveCommandClient
from libqtile.lazy import LazyCall, lazy
from libqtile.utils import guess_terminal
from libqtile.config import Click, Drag, Key, KeyChord

from groups_list import groups


TERMINAL = getenv("TERMINAL", guess_terminal())
BROWSER = getenv("BROWSER", "vivaldi-stable")
EDITOR = getenv("EDITOR", "nvim")


SHIFT = "shift"
ALT = "mod1"
CTRL = "control"

MOD = ALT

LMB = "Button1"
RMB = "Button3"


def terminal_with(executable: str) -> str:
    return f"{TERMINAL} -t {executable} -e {executable}"


# Drag floating layouts.
mouse = [
    Drag(
        [MOD],
        LMB,
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag([MOD], RMB, lazy.window.set_size_floating(), start=lazy.window.get_size()),
    # Click([mod], 'Button2', lazy.window.bring_to_front()),
    Click([MOD, SHIFT], LMB, lazy.window.toggle_floating()),
    Click([MOD, SHIFT], RMB, lazy.window.kill()),
]


_system_keys = [
    Key([ALT], "F2", lazy.spawncmd(), desc="Run shell command"),
    Key([MOD], "Home", lazy.restart(), desc="Reload config"),
    Key(
        [MOD, SHIFT],
        "Delete",
        lazy.spawn(
            'dmprompt "Are you sure you want to exit qtile?"'
            ' "qtile cmd-obj -o cmd -f shutdown"'
        ),
        desc="Shutdown Qtile",
    ),
    Key(
        [MOD, SHIFT],
        "End",
        lazy.spawn('dmprompt "POWEROFF the PC?" "poweroff"'),
        desc="Shutdown PC",
    ),
    Key(
        [MOD, SHIFT],
        "Home",
        lazy.spawn('dmprompt "REBOOT the PC?" "reboot"'),
        desc="Reboot PC",
    ),
]

_application_launcher_keys = [
    Key([MOD], "Return", lazy.spawn(TERMINAL)),
    Key([MOD, SHIFT], "Return", lazy.spawn("rofi -modi drun,run -show drun")),
    Key([MOD], "w", lazy.spawn(BROWSER), desc="Web browser"),
    Key([MOD], "e", lazy.spawn(terminal_with(EDITOR)), desc="Text editor"),
    Key([MOD], "r", lazy.spawn(terminal_with("ranger")), desc="File browser"),
    # Key([mod], "y", lazy.group["scratchpad"].dropdown_toggle("ai")),
    Key([MOD], "t", lazy.group["scratchpad"].dropdown_toggle("terminal")),
    Key([MOD], "a", lazy.spawn("login.sh"), desc="Auto-login into standart form"),
    Key([MOD], "q", lazy.spawn("passmenu"), desc="Frontend for pass"),
    Key([MOD], "s", lazy.spawn(terminal_with("dmconf")), desc="Edit bm-file"),
    Key([], "XF86Calculator", lazy.spawn("rofi -modi calc -show calc")),
    Key([], "XF86Explorer", lazy.spawn("rofi -modi emoji -show emoji")),
    # Key([], "XF86HomePage", lazy.spawn("rofi-pass")),
    # Key([], "XF86Tools", lazy.spawn()),  # music btn
    # Key([], "XF86Mail", lazy.spawn()),
    KeyChord(
        [MOD],
        "d",
        [
            # GUI
            Key([], "o", lazy.spawn("obsidian")),
            Key([], "z", lazy.spawn("anki")),
            Key([], "v", lazy.spawn("Telegram")),
            Key([], "x", lazy.spawn("discord")),
            Key([], "t", lazy.spawn("torbrowser-launcher")),
            # Key([], "i", lazy.spawn("outline-client")),
            # TUI
            Key([], "u", lazy.spawn(terminal_with("taskwarrior-tui"))),
            Key([], "c", lazy.group["scratchpad"].dropdown_toggle("pomodoro")),
            Key([], "m", lazy.group["scratchpad"].dropdown_toggle("music")),
            Key([], "p", lazy.spawn(terminal_with("ipython"))),
            Key([], "g", lazy.spawn(terminal_with("yaegi"))),
            Key([], "h", lazy.spawn(terminal_with("btop"))),
            Key([], "n", lazy.spawn(terminal_with("newsboat")), desc="RSS feed"),
            # Binaries & Scripts
            Key([], "j", lazy.spawn(terminal_with("oj"))),
            Key([], "s", lazy.spawn("share")),
            Key([], "b", lazy.spawn("start_bluetooth_discovery")),
            Key([], "y", lazy.spawn("switch_alacritty_font")),
            Key([], "k", lazy.spawn(str(Path.home() / ".config/shell/keyboard.sh"))),
        ],
    ),
]

_screenshot_and_screencast_keys = [
    Key([], "Print", lazy.spawn("flameshot gui")),
    Key([SHIFT], "Print", lazy.spawn("flameshot full -c")),
    Key([CTRL], "Print", lazy.spawn(f'flameshot full -p {getenv("HOME")}')),
]

def pamixer_cmd(pamixer_cmd: str) -> LazyCall:
    notify_cmd = 'notify-send -t 1000 pamixer "volume=$(pamixer --get-volume), mute=$(pamixer --get-mute)"'
    return lazy.spawn(f"bash -c 'pamixer {pamixer_cmd} && {notify_cmd}'")

_audio_and_cmus_keys = [
    Key([], "XF86AudioPlay", (_pause := lazy.spawn("cmus-remote --pause"))),
    Key([], "XF86AudioStop", (_stop := lazy.spawn("cmus-remote --stop"))),
    Key([], "XF86AudioNext", (_next := lazy.spawn("cmus-remote --next"))),
    Key([], "XF86AudioPrev", (_prev := lazy.spawn("cmus-remote --prev"))),
    Key([], "XF86AudioMute", (_mute := pamixer_cmd("--toggle-mute"))),
    Key([], "XF86AudioRaiseVolume", (_volup := pamixer_cmd("--increase 5"))),
    Key([], "XF86AudioLowerVolume", (_voldown := pamixer_cmd("--decrease 5"))),
    KeyChord(
        [MOD],
        "m",
        [
            Key([], "c", _pause),
            Key([], "v", _stop),
            Key([], "n", _mute),
        ],
    ),
    KeyChord(
        [MOD, SHIFT],
        "m",
        [
            Key([], "u", _voldown),
            Key([], "i", _volup),
            Key([], "j", _next),
            Key([], "k", _prev),
            # Duplicates for convinience
            Key([], "c", _pause),
            Key([], "v", _stop),
            Key([], "n", _mute),
        ],
        mode=True,
    ),
]

_windows_keys = [
    # Other window-related
    Key(
        [MOD],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Put the focused window to/from fullscreen mode",
    ),
    Key(
        [MOD, SHIFT],
        "p",
        lazy.window.toggle_floating(),
        desc="Put the focused window to/from floating mode",
    ),
    Key([MOD, SHIFT], "c", lazy.window.kill(), desc="Kill focused window"),
    Key([MOD, SHIFT], "n", lazy.group.next_window()),
    Key([MOD, SHIFT], "b", lazy.group.prev_window()),
]

_layout_keys = [
    # Manipulate with layout windows
    Key([MOD], "h", lazy.layout.left()),
    Key([MOD], "l", lazy.layout.right()),
    Key([MOD], "j", lazy.layout.down()),
    Key([MOD], "k", lazy.layout.up()),
    Key([MOD, SHIFT], "h", lazy.layout.shuffle_left()),
    Key([MOD, SHIFT], "l", lazy.layout.shuffle_right()),
    Key([MOD, SHIFT], "j", lazy.layout.shuffle_down()),
    Key([MOD, SHIFT], "k", lazy.layout.shuffle_up()),
    Key([MOD, CTRL], "h", lazy.layout.grow_left()),
    Key([MOD, CTRL], "l", lazy.layout.grow_right()),
    Key([MOD, CTRL], "j", lazy.layout.grow_down()),
    Key([MOD, CTRL], "k", lazy.layout.grow_up()),
    # Key([mod, ctrl], "n", lazy.layout.normilize(), desc="Reset win sizes"),
    # Toggle between different layouts
    Key([MOD], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([MOD, SHIFT], "Tab", lazy.prev_layout(), desc="in other direction"),
    Key([MOD], "period", lazy.next_screen(), desc="Next monitor"),
    # Monad layout specifics
    Key(
        [MOD],
        "semicolon",
        lazy.layout.swap_main(),
        desc="Switch focused slave and master (Monad layout)",
    ),
    # Column layout specifics
    Key(
        [MOD, CTRL],
        "semicolon",
        lazy.layout.swap_column_left(),
        desc="Swap column; useful after toggle_fullscreen (Column layout)",
    ),
    Key(
        [MOD, SHIFT],
        "semicolon",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack (Column layout)",
    ),
    Key([MOD, CTRL], "n", lazy.hide_show_bar()),
]


keys = [
    *_system_keys,
    *_application_launcher_keys,
    *_screenshot_and_screencast_keys,
    *_audio_and_cmus_keys,
    *_windows_keys,
    *_layout_keys,
]


# dgroups_key_binder = simple_key_binder(mod)
dgroups_app_rules = []

for group in groups:
    name = group.name
    if name == "scratchpad":
        continue
    keys.extend(
        [
            Key([MOD], name, lazy.group[name].toscreen(toggle=True)),
            # Key([mod, shift], name, lazy.window.togroup(name, switch_group=True)),
            Key([MOD, SHIFT], name, lazy.window.togroup(name, switch_group=False)),
            # Key([mod, ctrl], name, lazy.group.switch_groups(name)),
        ]
    )
