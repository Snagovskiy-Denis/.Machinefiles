#!/usr/bin/env python
import csv
import sqlite3
import logging

from pathlib import Path
from datetime import datetime
from collections import defaultdict
from itertools import chain


__datasource__ = "com.cronometer.android.gold"
__datasourcetype__ = "android:package"


# logger = logging.getLogger(Path(__file__).name)
logger = logging.root


def main(vault_db: Path, outer_csv: Path) -> int:
    days = defaultdict(list)
    with open(outer_csv) as csvfile:
        reader = csv.reader(csvfile)
        columns_raw = next(reader)
        for row in reader:
            day = int(datetime.fromisoformat(row[0]).timestamp())
            row[0] = day
            days[day].append(row)

    connection = sqlite3.connect(vault_db, timeout=10)
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

    columns_list = ["timestamp"]
    columns_raw.pop(0)
    for column in columns_raw:
        for old_and_new in (" ", "_"), ("(", "_"), (")", ""), ("-", "_"):
            column = column.replace(*old_and_new)
        columns_list.append(column.lower())

    columns = ",".join(column for column in columns_list)
    bind_str = ",".join("?" for _ in columns_raw)
    insert_query = f"""
        INSERT OR IGNORE INTO food_tracks ({columns})
        VALUES ({bind_str})
    """

    delete_days = ",".join(str(timestamp) for timestamp in days_to_import)
    delete_query = f"DELETE FROM food_tracks WHERE timestamp IN ({delete_days})"

    entries = list(chain.from_iterable(days_to_import.values()))

    cursor.execute(delete_query)
    try:
        cursor.executemany(insert_query, entries)
    except sqlite3.OperationalError:
        logger.exception("Error during data import")
        raise

    connection.commit()
    inserted_rows = cursor.rowcount
    connection.close()

    return inserted_rows
