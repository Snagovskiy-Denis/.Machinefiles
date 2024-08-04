import logging
import logging.handlers
import subprocess

from os.path import expandvars
from textwrap import fill


def notify_send(title: str, message: str, time=10_000, icon: str = "") -> None:
    arguments = ["notify-send", title, fill(message), f"--expire-time={time}"]
    if icon:
        icons_home = expandvars("$USER_ICONS")
        arguments.append(f"--icon={icons_home}{icon}")
    subprocess.run(arguments)


class LibnotifyHandler(logging.Handler):
    def __init__(self, level, app_name, icon="") -> None:
        super().__init__(level)
        self.app_name = app_name
        if not icon and app_name.lower().startswith("etl"):
            icon = "db.png"
        self.icon = icon

    def emit(self, record: logging.LogRecord) -> None:
        notify_send(self.app_name, record.message, time=60 * 1000, icon=self.icon)


class HandlersFactory:
    def __init__(self, app_name: str) -> None:
        self.app_name = app_name

    @property
    def formatter(self) -> logging.Formatter:
        return logging.Formatter(f"{self.app_name} - %(levelname)s - %(message)s")

    def syslog(self) -> logging.handlers.SysLogHandler:
        handler = logging.handlers.SysLogHandler(address="/dev/log")
        handler.setLevel(logging.INFO)
        handler.setFormatter(self.formatter)
        return handler

    def notify(self) -> LibnotifyHandler:
        return LibnotifyHandler(logging.WARNING, self.app_name)

    def stream(self) -> logging.StreamHandler:
        handler = logging.StreamHandler()
        handler.setLevel(logging.DEBUG)
        handler.setFormatter(self.formatter)
        return handler


def setup_default_logging(logger: logging.Logger, app_name: str) -> None:
    logger.setLevel(logging.DEBUG)

    factory = HandlersFactory(app_name)
    for handler in factory.syslog(), factory.stream():
        logger.addHandler(handler)
    logger.addHandler(factory.notify())
