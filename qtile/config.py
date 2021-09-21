import os
from subprocess import run
from pathlib import Path

from typing import List

from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal


TERMINAL = os.getenv('TERMINAL', guess_terminal())
BROWSER  = os.getenv('BROWSER', 'vivaldi-stable')
EDITOR   = os.getenv('EDITOR', 'nvim')

mod = 'mod3'


def fix_cli_app(app: str) -> str:
    """Quick fix of github.com/qtile/qtile/issues/2167 bug"""
    return f'{TERMINAL} -t {app.capitalize()} -e sh -c "sleep 0.1 && {app}"'


keys = [
    # Switch focus between windows
    Key([mod], 'h', lazy.layout.left(), desc='Move focus to left'),
    Key([mod], 'l', lazy.layout.right(), desc='Move focus to right'),
    Key([mod], 'j', lazy.layout.down(), desc='Move focus down'),
    Key([mod], 'k', lazy.layout.up(), desc='Move focus up'),
    # Key([mod], 'space', lazy.layout.next(),
        # desc='Move window focus to other window'),

    # Move focused window
    Key([mod, 'shift'], 'h', lazy.layout.shuffle_left(),
        desc='Move window to the left'),
    Key([mod, 'shift'], 'l', lazy.layout.shuffle_right(),
        desc='Move window to the right'),
    Key([mod, 'shift'], 'j', lazy.layout.shuffle_down(),
        desc='Move window down'),
    Key([mod, 'shift'], 'k', lazy.layout.shuffle_up(), desc='Move window up'),

    # Resize window
    Key([mod, 'control'], 'h', lazy.layout.grow_left(),
        desc='Grow window to the left'),
    Key([mod, 'control'], 'l', lazy.layout.grow_right(),
        desc='Grow window to the right'),
    Key([mod, 'control'], 'j', lazy.layout.grow_down(),
        desc='Grow window down'),
    Key([mod, 'control'], 'k', lazy.layout.grow_up(), desc='Grow window up'),
    Key([mod], 'n', lazy.layout.normalize(), desc='Reset all window sizes'),

    # Other window-related
    Key([mod], 'f', lazy.window.toggle_fullscreen(), 
        desc='Put the focused window to/from fullscreen mode'),
    Key([mod, 'shift'], 'p', lazy.window.toggle_floating(), 
        desc='Put the focused window to/from floating mode'),
    Key([mod, 'shift'], 'c', lazy.window.kill(), desc='Kill focused window'),

    # Launch main applications
    Key([mod], 'Return', lazy.spawn(TERMINAL), desc='Launch terminal'),
    Key([mod, 'shift'], 'Return', 
        lazy.spawn('rofi -modi drun,run -show drun'), desc='Launch launcher'),
    Key([mod], 'w', lazy.spawn('vivaldi-stable'), desc='Launch web browser'),
    Key([mod], 'r', lazy.spawn(fix_cli_app('ranger')), 
        desc='Launch file browser'),

    # Launch other applications
    Key([mod, 'control'], 't', lazy.spawn('torbrowser-launcher')),
    Key([mod, 'control'], 'o', lazy.spawn('obsidian')),
    Key([mod, 'control'], 'z', lazy.spawn('anki')),
    Key([mod, 'control'], 'u', lazy.spawn('taskwarrior-tui')),
    Key([mod, 'control'], 'f', lazy.spawn(fix_cli_app('dmconf'))),
    Key([mod, 'control'], 'j', lazy.spawn(fix_cli_app('oj'))),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    # Key([mod, 'shift'], 'Return', lazy.layout.toggle_split(),
        # desc='Toggle between split and unsplit sides of stack'),

    # Toggle between different layouts as defined below
    Key([mod], 'Tab', lazy.next_layout(), desc='Toggle between layouts'),
    Key([mod, 'shift'], 'Tab', lazy.previous_layout(), 
        desc='Toggle between layouts in other direction'),

    Key([mod], 'F1', lazy.restart(), desc='Restart Qtile'),
    Key([mod, 'shift'], 'Delete', lazy.shutdown(), desc='Shutdown Qtile'),
    Key([mod], 'F2', lazy.spawncmd(),
        desc='Spawn a command using a prompt widget'),

    # XF86 keys
    # xev OR /usr/include/X11/XF86keysym.h AND gh.com/qtile/xkeysyms.py
    Key([], 'XF86Calculator', lazy.spawn('rofi -modi calc -show calc'),
            desc='Calculator through rofi interface'),
    Key([], 'XF86Explorer', lazy.spawn('rofi -modi emoji -show emoji'),
            desc='Rofi powered emoji picker'),
    Key([], 'XF86HomePage', lazy.spawn('rofi-pass'), 
            desc='Rofi interface to pass'),

    # Audio and cmus
    Key([], 'XF86AudioPlay',        lazy.spawn('cmus-remote --pause')),
    Key([], 'XF86AudioStop',        lazy.spawn('cmus-remote --stop')),
    Key([], 'XF86AudioNext',        lazy.spawn('cmus-remote --next')),
    Key([], 'XF86AudioPrev',        lazy.spawn('cmus-remote --prev')),
    Key([], 'XF86AudioMute',        lazy.spawn('pamixer --toggle-mute')),
    Key([], 'XF86AudioRaiseVolume', lazy.spawn('pamixer --increase 5')),
    Key([], 'XF86AudioLowerVolume', lazy.spawn('pamixer --decrease 5')),
]


group_names = [' ', '爵 ', ' ', '4', '5', '6', ' ', ' ', '9', 'ﴣ ']
groups = [Group(name) for name in group_names]
if len(group_names) > 10: 
    raise Exception('I haven\'t numeric keys for more than 10 groups')

for i, name in enumerate(group_names):
    group_key = str((i + 1) % 10)
    keys.extend([
        Key([mod], group_key, lazy.group[name].toscreen(),
            desc=f'Switch to group {group_key}'),
        Key([mod, 'shift'], group_key,
            lazy.window.togroup(name, switch_group=True),
            desc=f'Switch to & move focused window to group {group_key}'),
    ])


layouts = [
    layout.Columns(border_focus_stack=['#d75f5f', '#8f3d3d'], border_width=4),
    layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font='Hack Nerd Font',
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.CurrentLayout(),
                widget.GroupBox(),
                widget.Prompt(),
                widget.WindowName(),
                widget.Chord(
                    chords_colors={
                        'launch': ('#ff0000', '#ffffff'),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                # widget.TextBox('default config', name='default'),
                # widget.TextBox('Press &lt;M-r&gt; to spawn', 
                    # foreground='#d75f5f'),
                widget.Systray(),
                widget.Clock(format= ' %Y-%m-%d  %H:%M'),
                widget.QuickExit(),
            ],
            24,
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], 'Button1', lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], 'Button3', lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], 'Button2', lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
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

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

wmname = 'LG3D'  # Java-apps compability stuff


@hook.subscribe.startup_once
def autostart():
    run([Path('~/.config/shell/autostart.sh').expanduser()])


# @hook.subscribe.startup
# def autostart_keyboard_tweak():
    # run([Path('~/.config/shell/keyboard.sh').expanduser()])


# TODO: look at keypirinha...
# TODO: full featured audio-controller
# TODO: dzen-typing rAlt
#
# Config debug help:
#    1. syntax check = python -m py_compile ~/.config/qtile/config.py
#    2. log path = ~/.local/share/qtile/qtile.log
