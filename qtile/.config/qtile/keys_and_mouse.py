from os import getenv

from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from libqtile.config import Click, Drag, Key, KeyChord

from groups_list import groups


TERMINAL = getenv("TERMINAL", guess_terminal())
BROWSER = getenv("BROWSER", "vivaldi-stable")
EDITOR = getenv("EDITOR", "nvim")


# space = "mod3"
sup = "mod3"
shift = "shift"
alt = "mod1"
ctrl = "control"

# mod = space
mod = alt

lmb = "Button1"
rmb = "Button3"


def terminal_with(executable: str) -> str:
    return f"{TERMINAL} -t {executable} -e {executable}"


# Drag floating layouts.
mouse = [
    Drag(
        [mod],
        lmb,
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag([mod], rmb, lazy.window.set_size_floating(), start=lazy.window.get_size()),
    # Click([mod], 'Button2', lazy.window.bring_to_front()),
    Click([mod, shift], lmb, lazy.window.toggle_floating()),
    Click([mod, shift], rmb, lazy.window.kill()),
]


_system_keys = [
    Key([alt], "F2", lazy.spawncmd(), desc="Run shell command"),
    Key([mod], "Home", lazy.restart(), desc="Reload config"),
    Key(
        [mod, shift],
        "Delete",
        lazy.spawn(
            'dmprompt "Are you sure you want to exit qtile?"'
            ' "qtile cmd-obj -o cmd -f shutdown"'
        ),
        desc="Shutdown Qtile",
    ),
    Key(
        [mod, shift],
        "End",
        lazy.spawn('dmprompt "POWEROFF the PC?" "poweroff"'),
        desc="Shutdown PC",
    ),
    Key(
        [mod, shift],
        "Home",
        lazy.spawn('dmprompt "REBOOT the PC?" "reboot"'),
        desc="Reboot PC",
    ),
]

_application_launcher_keys = [
    Key([mod], "Return", lazy.spawn(TERMINAL)),
    Key([mod, shift], "Return", lazy.spawn("rofi -modi drun,run -show drun")),
    Key([mod], "w", lazy.spawn(BROWSER), desc="Web browser"),
    Key([mod], "e", lazy.spawn(terminal_with(EDITOR)), desc="Text editor"),
    Key([mod], "r", lazy.spawn(terminal_with("ranger")), desc="File browser"),
    Key([mod], "y", lazy.group["scratchpad"].dropdown_toggle("ai")),
    Key([mod], "t", lazy.group["scratchpad"].dropdown_toggle("terminal")),
    Key([mod], "a", lazy.spawn("login.sh"), desc="Auto-login into standart form"),
    Key([mod], "q", lazy.spawn("passmenu"), desc="Frontend for pass"),
    Key([mod], "s", lazy.spawn(terminal_with("dmconf")), desc="Edit bm-file"),
    Key([], "XF86Calculator", lazy.spawn("rofi -modi calc -show calc")),
    Key([], "XF86Explorer", lazy.spawn("rofi -modi emoji -show emoji")),
    # Key([], "XF86HomePage", lazy.spawn("rofi-pass")),
    # Key([], "XF86Tools", lazy.spawn()),  # music btn
    # Key([], "XF86Mail", lazy.spawn()),
    KeyChord(
        [mod],
        "d",
        [
            # GUI
            Key([], "o", lazy.spawn("obsidian")),
            Key([], "z", lazy.spawn("anki")),
            Key([], "c", lazy.group["scratchpad"].dropdown_toggle("pomodoro")),
            Key([], "v", lazy.spawn("telegram-desktop")),
            Key([], "x", lazy.spawn("discord")),
            Key([], "t", lazy.spawn("torbrowser-launcher")),
            # TUI
            Key([], "u", lazy.spawn(terminal_with("taskwarrior-tui"))),
            Key([], "m", lazy.group["scratchpad"].dropdown_toggle("music")),
            Key([], "p", lazy.spawn(terminal_with("ipython"))),
            Key([], "g", lazy.spawn(terminal_with("yaegi"))),
            Key([], "h", lazy.spawn(terminal_with("btop"))),
            Key([], "n", lazy.spawn(terminal_with("newsboat")), desc="RSS feed"),
            # Binaries & Scripts
            Key([], "j", lazy.spawn(terminal_with("oj"))),
            Key([], "s", lazy.spawn("share")),
            Key([], "b", lazy.spawn("start_bluetooth_discovery")),
        ],
    ),
]

_screenshot_and_screencast_keys = [
    Key([], "Print", lazy.spawn("flameshot gui")),
    Key([shift], "Print", lazy.spawn("flameshot full -c")),
    Key([ctrl], "Print", lazy.spawn(f'flameshot full -p {getenv("HOME")}')),
]

_audio_and_cmus_keys = [
    Key([], "XF86AudioPlay", (_pause := lazy.spawn("cmus-remote --pause"))),
    Key([], "XF86AudioStop", (_stop := lazy.spawn("cmus-remote --stop"))),
    Key([], "XF86AudioNext", (_next := lazy.spawn("cmus-remote --next"))),
    Key([], "XF86AudioPrev", (_prev := lazy.spawn("cmus-remote --prev"))),
    Key([], "XF86AudioMute", (_mute := lazy.spawn("pamixer --toggle-mute"))),
    Key([], "XF86AudioRaiseVolume", (_volup := lazy.spawn("pamixer --increase 5"))),
    Key([], "XF86AudioLowerVolume", (_voldown := lazy.spawn("pamixer --decrease 5"))),
    KeyChord(
        [mod],
        "m",
        [
            Key([], "c", _pause),
            Key([], "v", _stop),
            Key([], "n", _mute),
        ],
    ),
    KeyChord(
        [mod, shift],
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
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Put the focused window to/from fullscreen mode",
    ),
    Key(
        [mod, shift],
        "p",
        lazy.window.toggle_floating(),
        desc="Put the focused window to/from floating mode",
    ),
    Key([mod, shift], "c", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, shift], "n", lazy.group.next_window()),
    Key([mod, shift], "b", lazy.group.prev_window()),
]

_layout_keys = [
    # Manipulate with layout windows
    Key([mod], "h", lazy.layout.left()),
    Key([mod], "l", lazy.layout.right()),
    Key([mod], "j", lazy.layout.down()),
    Key([mod], "k", lazy.layout.up()),
    Key([mod, shift], "h", lazy.layout.shuffle_left()),
    Key([mod, shift], "l", lazy.layout.shuffle_right()),
    Key([mod, shift], "j", lazy.layout.shuffle_down()),
    Key([mod, shift], "k", lazy.layout.shuffle_up()),
    Key([mod, ctrl], "h", lazy.layout.grow_left()),
    Key([mod, ctrl], "l", lazy.layout.grow_right()),
    Key([mod, ctrl], "j", lazy.layout.grow_down()),
    Key([mod, ctrl], "k", lazy.layout.grow_up()),
    Key([mod, ctrl], "n", lazy.layout.normilize(), desc="Reset win sizes"),
    # Toggle between different layouts
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod, shift], "Tab", lazy.prev_layout(), desc="in other direction"),
    Key([mod], "period", lazy.next_screen(), desc="Next monitor"),
    # Monad layout specifics
    Key(
        [mod],
        "semicolon",
        lazy.layout.swap_main(),
        desc="Switch focused slave and master (Monad layout)",
    ),
    # Column layout specifics
    Key(
        [mod, ctrl],
        "semicolon",
        lazy.layout.swap_column_left(),
        desc="Swap column; useful after toggle_fullscreen (Column layout)",
    ),
    Key(
        [mod, shift],
        "semicolon",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack (Column layout)",
    ),
    Key([mod, ctrl], "n", lazy.hide_show_bar()),
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
            Key([mod], name, lazy.group[name].toscreen(toggle=True)),
            # Key([mod, shift], name, lazy.window.togroup(name, switch_group=True)),
            Key([mod, shift], name, lazy.window.togroup(name, switch_group=False)),
            Key([mod, ctrl], name, lazy.group.switch_groups(name)),
        ]
    )
