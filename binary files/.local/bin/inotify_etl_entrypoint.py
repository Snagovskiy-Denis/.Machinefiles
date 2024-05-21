#!/usr/bin/env python
"""
Sets ETL script as handler on filesystem events.

System-level requirements:
    - typer - CLI parser
    - inotify_simple - python wrapper for inotify
"""

import re
import logging
import logging.handlers
import importlib
import subprocess
import signal

from textwrap import fill
from os.path import expandvars
from contextlib import suppress
from pathlib import Path
from types import ModuleType
from typing import Annotated

try:
    from typer import Typer, Argument, Option, BadParameter
    from inotify_simple import INotify, flags
except ImportError as e:
    print(f"Missing dependency: {e.name}")
    exit(1)


app = Typer(
    name="Inotify Parser Entrypoint",
    help="Sets ETL script as handler on filesystem events",
)


def notify_send(title: str, message: str, time=10000, icon: str = "") -> None:
    arguments = ["notify-send", title, fill(message), f"--expire-time={time}"]
    if icon:
        icons_home = expandvars("$USER_ICONS")
        arguments.append(f"--icon={icons_home}{icon}")
    subprocess.run(arguments)


class LibnotifyHandler(logging.Handler):
    def __init__(self, level, app_name) -> None:
        super().__init__(level)
        self.app_name = app_name

    def emit(self, record: logging.LogRecord) -> None:
        notify_send(self.app_name, record.message, time=60 * 1000, icon="db.png")


def setup_logging(etl_module: ModuleType):
    etl_filename = Path(etl_module.__file__).name  # pyright: ignore
    # etl_logger = logging.getLogger(etl_filename)
    __appname__ = f"etl/{etl_filename}"
    formatter = logging.Formatter(f"{__appname__} - %(levelname)s - %(message)s")

    syslog_handler = logging.handlers.SysLogHandler(address="/dev/log")
    syslog_handler.setLevel(logging.INFO)

    stream_handler = logging.StreamHandler()
    stream_handler.setLevel(logging.DEBUG)

    for handler in syslog_handler, stream_handler:
        handler.setFormatter(formatter)
        logging.root.addHandler(handler)

    libnotify_handler = LibnotifyHandler(logging.WARNING, __appname__)
    logging.root.addHandler(libnotify_handler)


def listen_events_forever(directory_to_watch: Path, filename_pattern: re.Pattern):
    inotify = INotify()
    watch_flags = flags.ATTRIB
    inotify.add_watch(directory_to_watch, watch_flags)
    killer = GracefulKiller()
    logging.info(f"start listening inotify events for '{directory_to_watch}'")
    while not killer.kill_now:
        for event in inotify.read(timeout=1):
            if re.match(filename_pattern, event.name):
                yield directory_to_watch / event.name
            else:
                logging.debug(f"skip '{event.name}'")
    inotify.close()


class GracefulKiller:
    kill_now = False

    def __init__(self) -> None:
        signal.signal(signal.SIGINT, self.exit_gracefully)
        signal.signal(signal.SIGTERM, self.exit_gracefully)

    def exit_gracefully(self, signum, frame):
        self.kill_now = True
        logging.warning("SIGTERM received, exiting")


def py_module(etl_module: str) -> ModuleType:
    if etl_module.endswith(".py"):
        raise BadParameter("Expects python module name, not a path to python file")

    try:
        etl = importlib.import_module(etl_module)
    except ImportError as e:
        raise BadParameter(str(e))

    if not hasattr(etl, "main"):
        raise BadParameter(f"{etl_module} is missing main function")
    if etl.main.__annotations__.get("return") is not int:
        raise BadParameter(f"{etl_module}.main shall return number of inserted rows")

    setup_logging(etl)
    return etl


def py_regex(value: str) -> re.Pattern:
    try:
        return re.compile(value)
    except re.error as e:
        raise BadParameter(str(e)) from e


@app.command()
def main(
    etl: Annotated[
        ModuleType,
        Argument(
            show_default=False,
            parser=py_module,
            help="ETL script to set as inotify event handlers",
        ),
    ],
    directory_to_watch: Annotated[
        Path,
        Argument(
            exists=True,
            file_okay=False,
            resolve_path=True,
            show_default=False,
            metavar="DIRECTORY",
            help="Watch inotify events for this directory",
        ),
    ],
    filename_regex: Annotated[
        re.Pattern,
        Argument(
            show_default=False,
            parser=py_regex,
            help="Skip files that doesn't match this regex expression",
        ),
    ],
    *,
    unlink_processed_file: Annotated[
        bool,
        Option(
            "--unlink/--no-unlink",
            help="Unlink file after ETL completion",
        ),
    ] = True,
    vault_db: Annotated[
        Path,
        Option(
            envvar="ZETTELKASTEN_DB",
            exists=True,
            dir_okay=False,
            readable=True,
            resolve_path=True,
            show_default=False,
            is_eager=True,
            help="Vault database file path",
        ),
    ],
) -> None:
    "Sets ETL script as handler on filesystem events"

    for path in listen_events_forever(directory_to_watch, filename_regex):
        try:
            logging.debug(f"start processing '{path}'")
            inserted_rows = etl.main(vault_db, path)
        except Exception:
            logging.exception(f"cannot import data from '{path}'. See systemd journal for traceback")
        else:
            if unlink_processed_file:
                with suppress(PermissionError):
                    path.unlink()
            logging.info(f"{inserted_rows = } from '{path}'")
            if inserted_rows:
                logging.warning(f"{inserted_rows} new entries")


if __name__ == "__main__":
    logging.root.setLevel(logging.DEBUG)
    app()
