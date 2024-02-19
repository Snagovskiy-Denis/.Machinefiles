#!/usr/bin/env python
import csv
import sqlite3
import logging

from typing import Iterable
from pathlib import Path
from datetime import datetime
from collections import defaultdict
from itertools import chain


__datasource__ = "com.cronometer.android.gold"
__datasourcetype__ = "android:package"


# logger = logging.getLogger(Path(__file__).name)
logger = logging.root


def to_SQL_list(items: Iterable) -> str:
    comma_separated_items = ",".join(str(item) for item in items)
    return f"({comma_separated_items})"


def main(vault_db: Path, outer_csv: Path) -> int:
    csv_days = defaultdict(list)
    with open(outer_csv) as csvfile:
        reader = csv.reader(csvfile)
        csv_header = next(reader)
        for row in reader:
            day = int(datetime.fromisoformat(row[0]).timestamp())
            row[0] = day
            csv_days[day].append(row)

    connection = sqlite3.connect(vault_db, timeout=10)
    cursor = connection.cursor()

    select_query = f"""
        SELECT
            timestamp AS day,
            SUM(energy__kcal) AS kcal
        FROM
            food_tracks
        WHERE
            timestamp IN {to_SQL_list(csv_days)}
        GROUP BY
            timestamp
    """
    cursor.execute(select_query)
    kcal_sums_in_db = {day: sum_ for day, sum_ in cursor.fetchall()}

    days_to_import = defaultdict(list)
    for day, food_tracks in csv_days.items():
        if not kcal_sums_in_db.get(day):
            days_to_import[day] = food_tracks
            continue

        CALORIES_INDEX = 3
        kcal_sum_in_csv = sum(float(track[CALORIES_INDEX]) for track in food_tracks)
        if kcal_sum_in_csv > kcal_sums_in_db[day]:  # overwrite existing food_tracks
            days_to_import[day] = food_tracks

    if not days_to_import.values():
        return 0

    headers = ["timestamp"]
    csv_header.pop(0)
    for header in csv_header:
        for old_and_new in (" ", "_"), ("(", "_"), (")", ""), ("-", "_"):
            header = header.replace(*old_and_new)
        headers.append(header.lower())

    insert_query = f"""
        INSERT OR IGNORE INTO food_tracks {to_SQL_list(headers)}
        VALUES {to_SQL_list(["?"] * len(headers))}
    """

    delete_query = f"DELETE FROM food_tracks WHERE timestamp IN {to_SQL_list(days_to_import)}"

    food_tracks_to_import = list(chain.from_iterable(days_to_import.values()))

    cursor.execute("BEGIN")
    cursor.execute(delete_query)
    try:
        cursor.executemany(insert_query, food_tracks_to_import)
    except sqlite3.OperationalError:
        cursor.execute("ROLLBACK")
        logger.error("error during insert query execution")
        raise

    connection.commit()
    inserted_rows = cursor.rowcount
    connection.close()

    return inserted_rows
