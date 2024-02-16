#!/usr/bin/env python
"""
Imports cronometer data into locale db

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
from collections import defaultdict
from itertools import chain


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
    days = defaultdict(list)
    with open(outer_csv) as csvfile:
        reader = csv.reader(csvfile)
        columns_raw = next(reader)
        for row in reader:
            day = int(datetime.fromisoformat(row[0]).timestamp())
            row[0] = day
            days[day].append(row)

    connection = sqlite3.connect(vault_db)
    cursor = connection.cursor()

    timestamps = ",".join(str(timestamp) for timestamp in days)
    select_query = f"""
        SELECT
            timestamp AS day,
            SUM(energy__kcal) AS kcal
        FROM
            food_tracks
        WHERE
            timestamp IN ({timestamps})
        GROUP BY
            timestamp
    """
    cursor.execute(select_query)
    kcal_sums_in_db = {day: sum_ for day, sum_ in cursor.fetchall()}

    days_to_import = defaultdict(list)
    for day, food_tracks in days.items():
        if not kcal_sums_in_db.get(day):
            days_to_import[day] = food_tracks
            continue

        CALORIES_INDEX = 3
        kcal_sum_in_csv = sum(float(track[CALORIES_INDEX]) for track in food_tracks)
        if kcal_sum_in_csv > kcal_sums_in_db[day]:  # overwrite existing food_tracks
            days_to_import[day] = food_tracks

    if not days_to_import.values():
        return 0

    delete_days = ",".join(str(timestamp) for timestamp in days_to_import)
    delete_query = f"DELETE FROM food_tracks WHERE timestamp IN ({delete_days})"
    cursor.execute(delete_query)

    columns_list = ["timestamp"]
    columns_raw.pop(0)
    for column in columns_raw:
        for old_and_new in (" ", "_"), ("(", "_"), (")", ""), ("-", "_"):
            column = column.replace(*old_and_new)
        columns_list.append(column.lower())
    columns = ",".join(column for column in columns_list)

    entries = list(chain.from_iterable(days_to_import.values()))
    bind_str = ",".join("?" for _ in entries[0])
    insert_query = f"""
        INSERT OR IGNORE INTO food_tracks ({columns})
        VALUES ({bind_str})
    """

    try:
        cursor.executemany(insert_query, entries)
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
    if "cronometer_export" not in outer_csv.name:
        logging.debug(f"Skipping non cronometer export file {outer_csv}")
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
