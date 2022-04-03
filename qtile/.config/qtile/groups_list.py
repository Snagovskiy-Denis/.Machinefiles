from libqtile.config import Group, Match

groups = [
    Group('1', layout='monadwide',
          matches=[Match(title=['oj', 'Oj'])],
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
