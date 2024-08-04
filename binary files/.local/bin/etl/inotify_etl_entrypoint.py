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
import signal

from contextlib import suppress
from pathlib import Path
from types import ModuleType
from typing import Annotated

try:
    from typer import Typer, Argument, Option, BadParameter
    from inotify_simple import INotify, flags
except ImportError as e:
    import sys

    print(f"Missing dependency: {e.name}", file=sys.stderr)
    sys.exit(1)


from userlib.common_types import VaultDB
from userlib.loggers import setup_default_logging


app = Typer(
    name="Inotify Parser Entrypoint",
    help="Sets ETL script as handler on filesystem events",
)


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

    etl_filename = Path(etl.__file__).name  # pyright: ignore
    # etl_logger = logging.getLogger(etl_filename)  # separate logger
    etl_logger = logging.root
    __appname__ = f"etl/{etl_filename}"
    setup_default_logging(etl_logger, __appname__)

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
    vault_db: VaultDB,
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
    app()
