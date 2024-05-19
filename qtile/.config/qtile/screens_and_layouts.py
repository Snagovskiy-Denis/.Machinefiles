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


from tasklib import TaskWarrior, Task
from libqtile.widget import base

class TaskWarriorWidget(base.ThreadPoolText):
    defaults = [
        ("update_interval", 5, "Update interval in seconds"),
    ]

    def __init__(self, text = "No tasks", **config):
        super().__init__(text, **config)
        self.add_defaults(self.defaults)

        # TODO: add callbacks - dmprompt to task done
        # look at cmus widget for callbacks examples.
        # Do I really want a mouse support?

        self.tw = TaskWarrior()

    def get_tw_context_filter(self) -> str | None:
        """Make TaskWarrior respect current context"""
        if context := self.tw.config.get("context"):
            return self.tw.config.get(f"context.{context}.read")

    def get_next_task(self) -> Task | None:
        """Get the most urgent task"""
        tasks = self.tw.tasks.pending()
        if context_filter := self.get_tw_context_filter():
            tasks = tasks.filter(context_filter)
        urgent_tasks = reversed(sorted(tasks, key=lambda task: task["urgency"]))
        return next(urgent_tasks, None)

    def poll(self):
        task = self.get_next_task()
        if not task:
            return "No tasks"
        return f'{task["id"]} {str(task)}'


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
                TaskWarriorWidget(),
                widget.Sep(),
                widget.Cmus(max_chars=70),
                widget.Sep(),
                widget.Clock(format=' %Y-%m-%d  %H:%M'),
                widget.QuickExit(default_text='[⏻]'),
            ],
            24,
        ),
    ),
]
