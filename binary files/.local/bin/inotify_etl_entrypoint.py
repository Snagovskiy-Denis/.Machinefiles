#!/usr/bin/env python
"""
Sets ETL scripts as handler on filesystem events.

System-level requirements:
    - typer - CLI parser
    - inotify_simple - python wrapper around inotify
"""

import re
import logging
import logging.handlers
import importlib
import subprocess
import signal

from contextlib import suppress
from pathlib import Path
from functools import partial
from types import ModuleType
from typing import Annotated, Any, Callable

try:
    from typer import Typer, Argument, Option, BadParameter, CallbackParam
    from inotify_simple import INotify, flags
except ImportError as e:
    print(f"Missing dependency: {e.name}")
    exit(1)


app = Typer(
    name="Inotify Parser Entrypoint",
    help="Sets ETL scripts as handler on filesystem events",
)


def notify_send(title: str, message: str, time=10000) -> None:
    subprocess.run(["notify-send", title, message, f"--expire-time={time}"])


class LibnotifyHandler(logging.Handler):
    def emit(self, record: logging.LogRecord) -> None:
        notify_send("ETL", self.formatter.format(record), time=60 * 1000)


def setup_logging(etl_module: ModuleType):
    etl_filename = Path(etl_module.__file__).name  # pyright: ignore
    # etl_logger = logging.getLogger(etl_filename)
    __appname__ = f"etl/{etl_filename}"
    formatter = logging.Formatter(f"{__appname__} - %(levelname)s - %(message)s")

    syslog_handler = logging.handlers.SysLogHandler(address="/dev/log")
    syslog_handler.setLevel(logging.INFO)

    stream_handler = logging.StreamHandler()
    stream_handler.setLevel(logging.DEBUG)

    libnotify_handler = LibnotifyHandler(logging.WARNING)

    for handler in syslog_handler, stream_handler, libnotify_handler:
        handler.setFormatter(formatter)
        logging.root.addHandler(handler)


def listen_events_forever(watch_directory: Path):
    inotify = INotify()
    watch_flags = flags.ATTRIB
    inotify.add_watch(watch_directory, watch_flags)
    killer = GracefulKiller()
    logging.info(f"start listening inotify events for '{watch_directory}'")
    while not killer.kill_now:
        yield from inotify.read(timeout=1)


class GracefulKiller:
    kill_now = False

    def __init__(self) -> None:
        signal.signal(signal.SIGINT, self.exit_gracefully)
        signal.signal(signal.SIGTERM, self.exit_gracefully)

    def exit_gracefully(self, signum, frame):
        self.kill_now = True


def envvar_is_set(param: CallbackParam, value: Any):
    if not value:
        raise BadParameter(f"Improper system configuration. Missing {param.envvar=}")
    return value


def re_compile_parser(value: str) -> Callable:
    if not value:
        return lambda _: True
    try:
        pattern = re.compile(value)
    except re.error as e:
        raise BadParameter(str(e)) from e
    else:
        return partial(re.match, pattern)


@app.command()
def main(
    etl_module: Annotated[
        str,
        Argument(
            metavar="MODULE",
            show_default=False,
            help="ETL script to set as inotify event handlers",
        ),
    ],
    watch_directory: Annotated[
        Path,
        Argument(
            exists=True,
            dir_okay=True,
            file_okay=False,
            resolve_path=True,
            show_default=False,
            help="Watch inotify events for this directory",
        ),
    ],
    filename_filter: Annotated[
        str,
        Argument(
            help="Skip files that doesn't match this regex expression",
            metavar="PY_REGEX",
            show_default=False,
            parser=re_compile_parser,
        ),
    ],
    unlink_processed_file: Annotated[
        bool,
        Option(
            "--no-unlink/",
            help="Unlink file after ETL completion",
        ),
    ] = True,
    vault_path: Annotated[
        Path,
        Option(
            envvar="ZETTELKASTEN",
            exists=True,
            dir_okay=True,
            file_okay=False,
            resolve_path=True,
            show_default=False,
            callback=envvar_is_set,
        ),
    ] = None,  # pyright: ignore
    db_name: Annotated[Path, Option(dir_okay=False)] = Path("../db.sqlite3"),
) -> None:
    "Sets ETL scripts as handler on filesystem events"
    vault_db = vault_path / db_name
    if not (vault_db.exists() and vault_db.is_file()):
        raise BadParameter(f"db is not a file or does not exist '{vault_db}'")

    try:
        etl = importlib.import_module(etl_module)
    except ImportError as e:
        raise BadParameter(str(e))

    if not hasattr(etl, "main"):
        raise BadParameter(f"{etl_module} is missing main function")
    if etl.main.__annotations__.get("return") is not int:
        raise BadParameter(f"{etl_module}.main shall return number of inserted rows")

    setup_logging(etl)

    for event in listen_events_forever(watch_directory):
        if not filename_filter(event.name):
            logging.debug(f"skip {event.name}")
            continue

        outer_file: Path = watch_directory / event.name

        try:
            logging.info(f"start processing '{outer_file}'")
            inserted_rows = etl.main(vault_db, outer_file)
        except Exception as e:
            logging.exception(f"cannot import data from '{outer_file}'")
        else:
            if unlink_processed_file:
                with suppress(PermissionError):
                    outer_file.unlink()
            logging.info(f"{inserted_rows = } from '{outer_file}'")

    logging.warn("SIGTERM received, exiting")


if __name__ == "__main__":
    logging.root.setLevel(logging.DEBUG)
    app()
