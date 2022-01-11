"""qtile config file

Config debug help:
   1. check syntax with: $ python -m py_compile ~/.config/qtile/config.py
   2. chech log on path ~/.local/share/qtile/qtile.log for errors
"""
# TODO: aesthetics
# TODO: break config to multiple files: config, keys + mouse, groups, screens
# TODO: look at keypirinha for missed features...


import json
from os import getenv
from subprocess import run
from pathlib import Path

from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, KeyChord, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal


def cli_app(app: 'Name of $PATH located application') -> str:
    return f'{TERMINAL} -t {app.capitalize()} -e {app}'


TERMINAL = getenv('TERMINAL', guess_terminal())
BROWSER  = getenv('BROWSER', 'vivaldi-stable')
EDITOR   = getenv('EDITOR',  'nvim')

with open(Path.home().joinpath('.config/aesthetics.json')) as f:
    aesthetics = json.loads(f.read())
    colors = aesthetics['colors']
    font = aesthetics['font']

space = 'mod3'
# sup = 'mod3'
shift = 'shift'
alt   = 'mod1'
ctrl  = 'control'
mod   = space

lmb   = 'Button1'
rmb   = 'Button3'


keys = [
# DISABLE ALL OTHER KEYS
    KeyChord([], 'Alt_R', 
             [
                 Key([], 'Alt_R', lazy.ungrab_chord()),
                 Key([], 'Tab', lazy.layout.next()),
                 Key([shift], 'Tab', lazy.layout.previous()),
             ], 
             mode='dzen-typing'
    ),


# SYSTEM
    Key([mod], 'F2', lazy.spawncmd(), desc='Run shell command'),
    Key([mod], 'Insert', lazy.restart(),  desc='Reload config'),
    Key([mod, shift], 'Delete', 
        lazy.spawn('dmprompt "Are you sure you want to exit qtile?"'
                   ' "qtile cmd-obj -o cmd -f shutdown"'),
        desc='Shutdown Qtile'
    ),
    Key([mod, shift], 'End', 
        lazy.spawn('dmprompt "POWEROFF the PC?" "poweroff"'),
        desc='Shutdown PC'
    ),
    Key([mod, shift], 'Insert', 
        lazy.spawn('dmprompt "REBOOT the PC?" "reboot"'),
        desc='Reboot PC'
    ),

# APPLICATION LAUNCHERS
    # Launch main applications
    Key([mod], 'Return', lazy.spawn(TERMINAL)),
    Key([mod, shift], 'Return', lazy.spawn('rofi -modi drun,run -show drun')),
    Key([mod], 'w', lazy.spawn(BROWSER), desc='Web browser'),
    Key([mod], 'e', lazy.spawn(cli_app(EDITOR)), desc='Text editor'),
    Key([mod], 'r', lazy.spawn(cli_app('ranger')), desc='File browser'),
    # TODO: rewrite note bash function as a separate file?
    Key([mod, shift], 'n', 
        lazy.spawncmd(prompt='note', 
        command=f'echo "%s" >> {Path.home().joinpath(".notes")}'), 
        ),
        # desc='Scratch note'
    # Key([mod], 'n', 
        # lazy.spawncmd(prompt='note',
        # command='bash -c "note %s"'),
        # desc='Scratch note'
    # ),
    # Key([mod, shift], 'n', lazy.spawn('bash -c "note -c"'), desc='Scratch note'),


    Key([], 'XF86Calculator', lazy.spawn('rofi -modi calc -show calc')),
    Key([], 'XF86Explorer', lazy.spawn('rofi -modi emoji -show emoji')),
    Key([], 'XF86HomePage', lazy.spawn('rofi-pass')),
    # Key([], 'XF86Tools', lazy.spawn()),  # music btn
    # Key([], 'XF86Mail', lazy.spawn()),

    # Launch other applications
    KeyChord([mod], 'd', [
        # GUI applications
        Key([], 't', lazy.spawn('torbrowser-launcher')),
        Key([], 'o', lazy.spawn('obsidian')),
        Key([], 'z', lazy.spawn('anki')),
        Key([], 'c', lazy.spawn('gnome-pomodoro')),

        # CLI & TUI applications
        Key([], 'u', lazy.spawn(cli_app('taskwarrior-tui'))),
        Key([], 'm', lazy.spawn(cli_app('cmus'))),
        Key([], 'p', lazy.spawn(cli_app('ipython'))),
        Key([], 'h', lazy.spawn(cli_app('htop'))),
        Key([], 'n', lazy.spawn(cli_app('newsboat')), desc='RSS feed'),
        Key([], 'a', lazy.spawn('passmenu'), desc='Frontend for pass'),

        # Binaries & Scripts
        Key([], 'j', lazy.spawn(cli_app('oj'))),
        Key([], 'f', lazy.spawn(cli_app('dmconf')), desc='Edit bm-file'),
    ]),

# AUDIO AND CMUS
    Key([], 'XF86AudioPlay',        lazy.spawn('cmus-remote --pause')),
    Key([], 'XF86AudioStop',        lazy.spawn('cmus-remote --stop')),
    Key([], 'XF86AudioNext',        lazy.spawn('cmus-remote --next')),
    Key([], 'XF86AudioPrev',        lazy.spawn('cmus-remote --prev')),
    Key([], 'XF86AudioMute',        lazy.spawn('pamixer --toggle-mute')),
    Key([], 'XF86AudioRaiseVolume', lazy.spawn('pamixer --increase 5')),
    Key([], 'XF86AudioLowerVolume', lazy.spawn('pamixer --decrease 5')),

# WINDOW
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

# LAYOUT
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

    # Toggle between different layouts as defined below
    Key([mod], 'Tab', lazy.next_layout(), desc='Toggle between layouts'),
    Key([mod, shift], 'Tab', lazy.prev_layout(), desc='in other direction'),

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
]


groups = [
        Group('1', layout='monadwide',
              matches=[Match(title=['oj'])],
              label='', position=1,
        ),

        Group('2', label='爵', position=2,),

        Group('3', label='', position=3,),

        Group('4', label='4', position=4,),

        Group('5', label='5', position=5,),

        Group('6', label='6', position=6),

        Group('7',
              matches=[Match(wm_class=['telegram-desktop', 'discord']),
                       Match(title=['irssi']),
              ],
              label='', position=7,
        ),

        Group('8', exclusive=False, layout='max',
              matches=[Match(title=['cmus'])],
              label='', position=8,
        ),

        Group('9', layout='max',
              matches=[Match(wm_class=['gnome-pomodoro', 'anki'])],
              label='9', position=9,
        ),

        Group('0',
              matches=[Match(wm_class=['Tor Browser'])],
              label='ﴣ', position=10,
        ),
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


layouts = [
    layout.Columns(
        border_focus_stack=['#d75f5f', '#8f3d3d'], 
        border_width=2,
    ),
    layout.Max(),
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadTall(
        # ratio=0.6,
    # ),
    layout.MonadWide(
        ratio=0.75,
    ),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]


widget_defaults = dict(
    font=font['name'],
    fontsize=font['size'],
    padding=3,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.GroupBox(),
                widget.CurrentLayoutIcon(scale=0.6),
                widget.Prompt(foreground=colors['dark-magenta']),
                widget.WindowName(),
                widget.Systray(padding=5),
                widget.Sep(),
                widget.Notify(),
                widget.Chord(
                    chords_colors={
                        'launch': (colors['red'], colors['white']),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                # TODO: decorator for Cmus.get_info if output is empty
                widget.Cmus(max_chars=70),
                # TODO: hide some widgets inside boxed
                # TODO: create task widget
                # widget.CheckUpdates(),
                # widget.Volume(
                    # emoji=True,
                    # vollume_app='pamixer',
                    # volume_up_command='pamixer --increase 5',
                    # volume_down_command='pamixer --decrease 5'),
                widget.Sep(),
                widget.Clock(format= ' %Y-%m-%d  %H:%M'),
                widget.QuickExit(default_text='[襤]'),
            ],
            24,
        ),
    ),
]


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


# Configurational booleans
follow_mouse_focus = True
bring_front_click = False
cursor_warp = True
floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    *layout.Floating.default_float_rules,
    Match(wm_class='confirmreset'),  # gitk
    Match(wm_class='makebranch'),  # gitk
    Match(wm_class='maketag'),  # gitk
    Match(wm_class='ssh-askpass'),  # ssh-askpass
    Match(title='branchdialog'),  # gitk
    Match(title='pinentry'),  # GPG key password entry
])
auto_fullscreen = True
focus_on_window_activation = 'smart'
reconfigure_screens = True
auto_minimize = True
wmname = 'LG3D'


# Hooks
@hook.subscribe.startup_once
def autostart():
    run(Path('~/.config/shell/autostart.sh').expanduser())
    # if you want to do Group(spawn=['app_name']) when
    # run([Path('~/.config/shell/autostart.sh').expanduser(), "NoFgJobs"])
