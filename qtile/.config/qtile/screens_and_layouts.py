import json
from pathlib import Path

from libqtile import bar, layout, widget
from libqtile.config import Screen


with open(Path.home().joinpath('.config/aesthetics.json')) as f:
    aesthetics = json.loads(f.read())
    colors = aesthetics['colors']
    font = aesthetics['font']


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
        single_border_width=0,
        # border_focus='#000000',
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
                # widget.Notify(),
                widget.Chord(
                    chords_colors={
                        'launch': (colors['red'], colors['white']),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                # TODO: decorator for Cmus.get_info func that returns default string if cmus output is empty
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
                widget.Clock(format=' %Y-%m-%d  %H:%M'),
                widget.QuickExit(default_text='[襤]'),
            ],
            24,
        ),
    ),
]
