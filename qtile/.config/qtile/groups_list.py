import re

from libqtile.utils import guess_terminal
from libqtile.config import DropDown, Group, Match, ScratchPad

groups = [
    Group(
        '1',
        layout='monadtall',
        matches=[Match(title=re.compile(r"^(oj|Oj)$"))],
        label='',
        position=1,
    ),

    Group('2', label='', position=2,),

    Group('3', label='', position=3,),

    Group('4', label='4', position=4,),

    Group('5', label='5', position=5,),

    Group('6', label='6', position=6),

    Group(
        '7',
        matches=[
            Match(wm_class=re.compile(r"^(telegram\-desktop|discord)$")),
            Match(title=re.compile(r"^(irssi)$")),
        ],
        label='',
        position=7,
    ),

    Group(
        '8',
        exclusive=False,
        # layout='max',
        # label='',
        label='8',
        position=8,
    ),

    Group(
        '9',
        layout='monadwide',
        matches=[Match(wm_class=re.compile(r"^(gnome\-pomodoro|anki)$"))],
        label='9',
        position=9,
    ),

    Group(
        '0',
        matches=[Match(wm_class=re.compile(r"^(Tor\ Browser)$"))],
        label='󰠥',
        position=10,
    ),

    ScratchPad(
        "scratchpad",
        [
            DropDown(
                "ai",
                'firefox --new-window --class "floating" chatgpt.com',
                width=(_browser_width := 0.3),
                height=0.8,
                x=1/2-_browser_width/2,
                y=0.015,
                on_focus_lost_hide=False,
            ),
            DropDown(
                "music",
                'alacritty -t cmus -e sh -c "sleep 0.1 && cmus"',
                match=Match(title=re.compile(r"^(cmus)$")),
                width=0.5,
                height=0.5,
                y=0.1,
            ),
            DropDown(
                "terminal",
                guess_terminal(),  # pyright: ignore
                height=0.8,
                y=0.05,
            ),
        ],
    ),
]
