#!/usr/bin/env python
"""
Imports daylio data into locale db

Accepts path to csv as a first argument.
"""

import os
import csv
import sys
import sqlite3
import logging
import logging.handlers

from pathlib import Path
from datetime import datetime


VAULT_ENV = "ZETTELKASTEN"
VAULT_DB_NAME = "../db.sqlite3"

__appname__ = f"parsers/{Path(__file__).name}"

syslog_handler = logging.handlers.SysLogHandler(address="/dev/log")
formatter = logging.Formatter(f"{__appname__} - %(levelname)s - %(message)s")
syslog_handler.setFormatter(formatter)
syslog_handler.setLevel(logging.INFO)

stream_handler = logging.StreamHandler()
stream_handler.setLevel(logging.DEBUG)

logging.root.setLevel(logging.DEBUG)
for handler in syslog_handler, stream_handler:
    logging.root.addHandler(handler)


def main(*, outer_csv: Path, vault_db: Path) -> int:
    connection = sqlite3.connect(vault_db)
    cursor = connection.cursor()
    moods = cursor.execute("SELECT id, name FROM moods").fetchall()

    records = []
    with open(outer_csv) as csvfile:
        reader = csv.reader(csvfile)
        next(reader)  # skip the header
        for row in reader:
            str_iso_datetime = f"{row[0]}T{row[3]}"
            timestamp = datetime.fromisoformat(str_iso_datetime).timestamp()
            str_mood = row[4]
            mood_id = next(filter(lambda mood: str_mood == mood[1], moods))[0]
            activities, notes = row[5], row[7]
            record = timestamp, mood_id, activities, notes
            records.append(record)

    query = """
        INSERT OR IGNORE INTO mood_tracks (timestamp, mood_id, activities, notes)
        VALUES (?, ?, ?, ?)
    """

    try:
        cursor.executemany(query, records)
    except sqlite3.OperationalError:
        logging.exception("Error during data import")
        raise

    connection.commit()
    inserted_rows = cursor.rowcount
    connection.close()

    return inserted_rows


if __name__ == "__main__":
    try:
        vault = Path(os.environ[VAULT_ENV])
    except KeyError:
        logging.critical(f"Improper configuration. Missing {VAULT_ENV=}")
        exit(1)
    else:
        vault_db = vault / VAULT_DB_NAME

    if len(sys.argv) < 2:
        logging.error("Missing file path.")
        exit(1)

    outer_csv = Path(sys.argv[1])
    if "daylio_export_" not in outer_csv.name:
        logging.debug(f"Skipping non daylio export file {outer_csv}")
        exit(0)

    try:
        logging.info(f"start processing '{outer_csv}'")
        inserted_rows = main(outer_csv=outer_csv, vault_db=vault_db)
    except Exception:
        logging.exception("cannot import data")
        raise
    else:
        outer_csv.unlink()
        logging.info(f"{inserted_rows = } from '{outer_csv}'")
