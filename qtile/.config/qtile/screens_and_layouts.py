import json
import subprocess

from pathlib import Path
from libqtile import bar, layout, widget
from libqtile.config import Screen

from taskwarrior_widget import TaskWarriorWidget


aesthetics_file = Path.home() / ".config/aesthetics.json"
aesthetics = json.loads(aesthetics_file.read_text())
colors = aesthetics["colors"]
font = aesthetics["font"]


layouts = [
    layout.Columns(
        border_focus_stack=["#d75f5f", "#8f3d3d"],
        border_width=2,
    ),
    layout.Max(),
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    layout.MonadTall(
        ratio=0.75,
        single_border_width=0,
    ),
    layout.MonadWide(
        ratio=0.75,
        single_border_width=0,
        # border_focus="#000000",
    ),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]


widget_defaults = dict(
    font=font["name"],
    fontsize=font["size"],
    padding=3,
)
extension_defaults = widget_defaults.copy()

widgets = (
    widget.GroupBox(),
    widget.CurrentLayoutIcon(scale=0.6),
    widget.Prompt(foreground=colors["dark-magenta"]),
    widget.WindowName(),
    widget.Systray(padding=5),
    widget.Sep(),
    TaskWarriorWidget(),
    widget.Sep(),
    widget.Cmus(max_chars=70),
    widget.Sep(),
    widget.Clock(format="🗓️%Y-%m-%d ⏱%H:%M"),
    widget.QuickExit(default_text="❎ "),
)

screens = []
xrandr = subprocess.run(["xrandr", "--listmonitors"], capture_output=True)
monitors_count = int(xrandr.stdout.splitlines()[0].split(b":")[1].strip())

if monitors_count == 2:
    # widgets_without_systray = [*widgets[:4], *widgets[5:]]
    screens.append(Screen())
screens.append(Screen(top=bar.Bar(list(widgets), 24)))
