from os import getenv

from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from libqtile.config import Click, Drag, Key, KeyChord

from groups_list import groups


TERMINAL = getenv('TERMINAL', guess_terminal())
BROWSER = getenv('BROWSER', 'vivaldi-stable')
EDITOR = getenv('EDITOR',  'nvim')


# space = 'mod3'
sup = 'mod3'
shift = 'shift'
alt = 'mod1'
ctrl = 'control'

# mod = space
mod = alt

lmb = 'Button1'
rmb = 'Button3'


def cli_app(app: str) -> str:
    '''Fix https://github.com/qtile/qtile/issues/2167

    app: str = Name of $PATH located application
    '''
    # return f'{TERMINAL} -t {app.capitalize()} -e {app}'
    return f'{TERMINAL} -t {app.capitalize()} -e sh -c "sleep 0.1 && {app}"'


# Drag floating layouts.
mouse = [
    Drag([mod], lmb, lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], rmb, lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    # Click([mod], 'Button2', lazy.window.bring_to_front()),
    Click([mod, shift], lmb, lazy.window.toggle_floating()),
    Click([mod, shift], rmb, lazy.window.kill()),
]


_disable_all_other_keys_mode = KeyChord(
    [],
    'Alt_R',
    [
        Key([], 'Alt_R', lazy.ungrab_chord()),
        Key([], 'Tab', lazy.layout.next()),
        Key([shift], 'Tab', lazy.layout.previous()),
    ],
    name='dzen-typing',
)


_system_keys = [
    Key([alt], 'F2', lazy.spawncmd(), desc='Run shell command'),
    Key([mod], 'Home', lazy.restart(),  desc='Reload config'),
    Key(
        [mod, shift],
        'Delete',
        lazy.spawn(
            'dmprompt "Are you sure you want to exit qtile?"'
            ' "qtile cmd-obj -o cmd -f shutdown"'
        ),
        desc='Shutdown Qtile',
    ),
    Key(
        [mod, shift],
        'End',
        lazy.spawn('dmprompt "POWEROFF the PC?" "poweroff"'),
        desc='Shutdown PC',
    ),
    Key(
        [mod, shift],
        'Home',
        lazy.spawn('dmprompt "REBOOT the PC?" "reboot"'),
        desc='Reboot PC',
    ),
]

_application_launcher_keys = [
    Key([mod], 'Return', lazy.spawn(TERMINAL)),
    Key([mod, shift], 'Return', lazy.spawn('rofi -modi drun,run -show drun')),
    Key([mod], 'w', lazy.spawn(BROWSER), desc='Web browser'),
    Key([mod], 'e', lazy.spawn(cli_app(EDITOR)), desc='Text editor'),
    Key([mod], 'r', lazy.spawn(cli_app('ranger')), desc='File browser'),
    Key([mod], 't', lazy.spawn('torbrowser-launcher')),

    Key([mod], 'a', lazy.spawn('login.sh'), desc='Auto-login into standart form'),
    Key([mod], 'q', lazy.spawn('passmenu'), desc='Frontend for pass'),
    Key([mod], 's', lazy.spawn(cli_app('dmconf')), desc='Edit bm-file'),

    Key([], 'XF86Calculator', lazy.spawn('rofi -modi calc -show calc')),
    Key([], 'XF86Explorer', lazy.spawn('rofi -modi emoji -show emoji')),
    Key([], 'XF86HomePage', lazy.spawn('rofi-pass')),
    # Key([], 'XF86Tools', lazy.spawn()),  # music btn
    # Key([], 'XF86Mail', lazy.spawn()),

    KeyChord([mod], 'd', [
        # GUI applications
        Key([], 'o', lazy.spawn('obsidian')),
        Key([], 'z', lazy.spawn('anki')),
        Key([], 'c', lazy.spawn('gnome-pomodoro')),
        Key([], 'v', lazy.spawn('telegram-desktop')),
        Key([], 'x', lazy.spawn('discord')),

        # CLI & TUI applications
        Key([], 'u', lazy.spawn(cli_app('taskwarrior-tui'))),
        Key([], 'm', lazy.spawn(cli_app('cmus'))),
        Key([], 'p', lazy.spawn(cli_app('ipython'))),
        Key([], 'h', lazy.spawn(cli_app('btop'))),
        Key([], 'n', lazy.spawn(cli_app('newsboat')), desc='RSS feed'),

        # Binaries & Scripts
        Key([], 'j', lazy.spawn(cli_app('oj'))),
        Key([], 's', lazy.spawn('share')),
    ]),
]

_screenshot_and_screencast_keys = [
    Key([], 'Print', lazy.spawn('flameshot gui')),
    Key([shift], 'Print', lazy.spawn('flameshot full -c')),
    Key([ctrl], 'Print', lazy.spawn(f'flameshot full -p {getenv("HOME")}')),
]

_audio_and_cmus_keys = [
    Key([], 'XF86AudioPlay',        lazy.spawn('cmus-remote --pause')),
    Key([], 'XF86AudioStop',        lazy.spawn('cmus-remote --stop')),
    Key([], 'XF86AudioNext',        lazy.spawn('cmus-remote --next')),
    Key([], 'XF86AudioPrev',        lazy.spawn('cmus-remote --prev')),
    Key([], 'XF86AudioMute',        lazy.spawn('pamixer --toggle-mute')),
    Key([], 'XF86AudioRaiseVolume', lazy.spawn('pamixer --increase 5')),
    Key([], 'XF86AudioLowerVolume', lazy.spawn('pamixer --decrease 5')),
    KeyChord(
        [mod], "m", mode=True,
        submappings=[
            Key([], "d", lazy.spawn("cmus-remote --pause")),
            Key([], "s", lazy.spawn("cmus-remote --stop")),
            Key([], "j", lazy.spawn("cmus-remote --next")),
            Key([], "k", lazy.spawn("cmus-remote --prev")),
            Key([], "n", lazy.spawn("pamixer --toggle-mute")),
            Key([], "u", lazy.spawn("pamixer --decrease 5")),
            Key([], "i", lazy.spawn("pamixer --increase 5")),
        ],
    )
]

_windows_keys = [
    # Other window-related
    Key([mod], 'f',
        lazy.window.toggle_fullscreen(),
        desc='Put the focused window to/from fullscreen mode'
        ),
    Key([mod, shift], 'p',
        lazy.window.toggle_floating(),
        desc='Put the focused window to/from floating mode'
        ),
    Key([mod, shift], 'c', lazy.window.kill(), desc='Kill focused window'),
]

_layout_keys = [
    # Manipulate with layout windows
    Key([mod],        'h', lazy.layout.left()),
    Key([mod],        'l', lazy.layout.right()),
    Key([mod],        'j', lazy.layout.down()),
    Key([mod],        'k', lazy.layout.up()),

    Key([mod, shift], 'h', lazy.layout.shuffle_left()),
    Key([mod, shift], 'l', lazy.layout.shuffle_right()),
    Key([mod, shift], 'j', lazy.layout.shuffle_down()),
    Key([mod, shift], 'k', lazy.layout.shuffle_up()),

    Key([mod,  ctrl], 'h', lazy.layout.grow_left()),
    Key([mod,  ctrl], 'l', lazy.layout.grow_right()),
    Key([mod,  ctrl], 'j', lazy.layout.grow_down()),
    Key([mod,  ctrl], 'k', lazy.layout.grow_up()),
    Key([mod,  ctrl], 'n', lazy.layout.normilize(), desc='Reset win sizes'),

    # Toggle between different layouts
    Key([mod], 'Tab', lazy.next_layout(), desc='Toggle between layouts'),
    Key([mod, shift], 'Tab', lazy.prev_layout(), desc='in other direction'),

    Key([mod], 'period', lazy.next_screen(), desc='Next monitor'),

    # Monad layout specifics
    Key([mod], 'semicolon',
        lazy.layout.swap_main(),
        desc='Switch focused slave and master (Monad layout)'
        ),

    # Column layout specifics
    Key([mod, ctrl], 'semicolon',
        lazy.layout.swap_column_left(),
        desc='Swap column; useful after toggle_fullscreen (Column layout)'
        ),
    Key([mod, shift], 'semicolon',
        lazy.layout.toggle_split(),
        desc='Toggle between split and unsplit sides of stack (Column layout)'
        ),

    Key([mod, shift], 'm', lazy.hide_show_bar())
]


keys = [
    # _disable_all_other_keys_mode,

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
    keys.extend([
        Key([mod], name, lazy.group[name].toscreen(toggle=True)),
        Key([mod, shift], name, lazy.window.togroup(name, switch_group=True)),
        Key([mod, ctrl], name, lazy.group.switch_groups(name)),
    ])
