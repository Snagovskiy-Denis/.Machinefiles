from systemd import journal

from tasklib import TaskWarrior, Task
from tasklib.backends import TaskWarriorException
from libqtile.widget import base


class TaskWarriorWidget(base.ThreadPoolText):
    """Widget that shows the most urgent task"""

    defaults = [
        ("update_interval", 5, "Update interval in seconds"),
        ("max_chars", 30, "Maximum number of characters to display in widget."),
    ]

    def __init__(self, text="", **config):
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
            # for whatever reason, I need to use pending twice
            tasks = tasks.filter(context_read_filter).pending()
        return max(tasks, key=lambda task: task["urgency"], default=None)

    def open_annotated_urls(self):
        if self.task:
            args = ["open", "batch", "--include", "url", self.task["id"]]
            self.tw.execute_command(args, allow_failure=False)

    def poll(self):
        try:
            self.task = self.next_task()
            return f"{self.task['id']}:{self.task}" if self.task else "No matches"
        except TaskWarriorException as e:
            journal.send(f"qtile - error - TaskWarriorWidget: {e}")
            return "oops"

