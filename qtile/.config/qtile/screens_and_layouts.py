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
    layout.MonadTall(
        ratio=0.75,
        single_border_width=0,
    ),
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


from tasklib import TaskWarrior
from libqtile.widget import base

class TaskWarriorWidget(base.ThreadPoolText):
    defaults = [
        ('update_interval', 5, 'Update interval in seconds'),
    ]

    def __init__(self, text = 'No tasks', **config):
        super().__init__(text, **config)
        self.add_defaults(self.defaults)

    def poll(self):
        tasks = self.get_tasks()

        if not tasks:
            return 'No tasks'

        most_urgent_task = sorted(
            tasks,
            key=lambda task: task.pending and task['urgency'],
            reverse=True,
        )[0]

        return f'{most_urgent_task["id"]} {most_urgent_task["description"]}'

    def get_tasks(self):
        tw = TaskWarrior()
        if context_filter := self.get_tw_context_filter(tw):
            return tw.tasks.filter(context_filter, status='pending')
        return tw.tasks.pending()

    @staticmethod
    def get_tw_context_filter(tw: TaskWarrior) -> str | None:
        config_path = Path('~/.config/taskrc').expanduser()
        if config_path.exists():
            config_lines = config_path.read_text().split('\n')
            for line in config_lines:
                if line.startswith(prefix := 'context='):
                    context_name = line.removeprefix(prefix)
                    return tw.config.get(f'context.{context_name}.read')


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
                TaskWarriorWidget(),
                widget.Sep(),
                # TODO: decorator for Cmus.get_info func that returns default string if cmus output is empty
                widget.Cmus(max_chars=70),
                # TODO: hide some widgets inside boxed
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
