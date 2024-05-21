import json

from pathlib import Path

from libqtile import bar, layout, widget
from libqtile.config import Screen


with open(Path.home().joinpath(".config/aesthetics.json")) as f:
    aesthetics = json.loads(f.read())
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


from tasklib import TaskWarrior, Task
from libqtile.widget import base


class TaskWarriorWidget(base.ThreadPoolText):
    """Widget that shows the most urgent task"""

    defaults = [
        ("update_interval", 5, "Update interval in seconds"),
        ("max_chars", 30, "Maximum number of characters to display in widget."),
    ]

    def __init__(self, text = "", **config):
        super().__init__(text, **config)
        self.add_defaults(self.defaults)
        self.add_callbacks({"Button1": self.open_annotated_urls})

        self.task: Task | None = None
        self.tw = TaskWarrior(create=False)

    def _get_tw_context_filter(self) -> str | None:
        """Make tasklib respect current context"""
        self.tw._config = None  # reset cached config to catch the context mutation
        context = self.tw.config.get("context")
        return context and self.tw.config.get(f"context.{context}.read")

    def next_task(self) -> Task | None:
        tasks = self.tw.tasks.pending()
        if context_read_filter := self._get_tw_context_filter():
            tasks = tasks.filter(context_read_filter)
        return max(tasks, key=lambda task: task["urgency"], default=None)

    def open_annotated_urls(self):
        if self.task:
            args = ["open", "batch", "--include", "url", self.task["id"]]
            self.tw.execute_command(args, allow_failure=False)

    def poll(self):
        self.task = self.next_task()
        return str(self.task) if self.task else "No matches."


screens = [
    Screen(
        top=bar.Bar(
            [
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
            ],
            24,
        ),
    ),
]
