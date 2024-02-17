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

from contextlib import suppress
from pathlib import Path
from functools import partial
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
logging.root.setLevel(logging.DEBUG)


class LibnotifyHandler(logging.Handler):
    def emit(self, record: logging.LogRecord) -> None:
        notify_send("ETL", self.formatter.format(record), time=60 * 1000)


def notify_send(title: str, message: str, time=10000) -> None:
    subprocess.run(
        [
            "notify-send",
            title,
            message,
            f"--expire-time={time}",
        ]
    )


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
    input_file_regex: Annotated[
        str,
        Argument(
            help="Exclude input that doesn't match regex expression",
            metavar="PY_REGEX",
            show_default=False,
            parser=re_compile_parser,
        ),
    ] = "",
    unlink_input_file: Annotated[
        bool,
        Option(
            "--unlink/",
            help="Unlink input file after ETL completion",
        ),
    ] = False,
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
    if not (vault_db.exists() or vault_db.is_file()):
        raise BadParameter(f"db is not a file or does not exist '{vault_db}'")

    try:
        etl = importlib.import_module(etl_module)
    except ImportError as e:
        raise BadParameter(str(e))

    if not hasattr(etl, "main"):
        raise BadParameter(f"{etl_module} is missing main function")

    if etl.main.__annotations__.get("return") is not int:
        raise BadParameter(f"{etl_module}.main shall return number of inserted rows")

    etl_filename = Path(etl.__file__).name  # pyright: ignore
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

    inotify = INotify()
    watch_flags = flags.CLOSE_WRITE
    inotify.add_watch(watch_directory, watch_flags)

    logging.info(f"start listening inotify events for '{watch_directory}'")

    while True:
        for event in inotify.read():
            if not input_file_regex(event.name):
                logging.debug(f"skip {event.name}")
                continue

            outer_file: Path = watch_directory / event.name
            try:
                logging.info(f"start processing '{outer_file}'")
                inserted_rows = etl.main(vault_db, outer_file)
            except Exception as e:
                logging.exception(f"cannot import data from '{outer_file}'")
            else:
                if unlink_input_file:
                    with suppress(PermissionError):
                        outer_file.unlink()
                logging.info(f"{inserted_rows = } from '{outer_file}'")


if __name__ == "__main__":
    app()
