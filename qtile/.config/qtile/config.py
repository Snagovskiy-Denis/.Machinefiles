"""qtile config file

Config debug help:
   1. check syntax with: $ python -m py_compile ~/.config/qtile/config.py
   2. chech log on path ~/.local/share/qtile/qtile.log for errors
"""
import subprocess

from pathlib import Path

from libqtile import hook
from libqtile.config import Match
from libqtile import layout

from keys_and_mouse import *
from groups_list import *
from screens_and_layouts import *


# Configurational booleans
follow_mouse_focus = True
bring_front_click = False
cursor_warp = True
floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    *layout.Floating.default_float_rules,
    Match(wm_class="floating"),  # my custom scripts
    Match(wm_class="confirmreset"),  # gitk
    Match(wm_class="makebranch"),  # gitk
    Match(wm_class="maketag"),  # gitk
    Match(wm_class="ssh-askpass"),  # ssh-askpass
    Match(title="branchdialog"),  # gitk
    Match(title="pinentry"),  # GPG key password entry
])
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True
wmname = "LG3D"


# Hooks
@hook.subscribe.startup_once
def autostart():
    subprocess.run(Path("~/.config/shell/autostart.sh").expanduser())
