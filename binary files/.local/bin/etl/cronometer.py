#!/usr/bin/env python
import csv
import sqlite3
import logging

from typing import Iterable
from pathlib import Path
from collections import defaultdict
from itertools import chain


__datasource__ = "com.cronometer.android.gold"
__datasourcetype__ = "android:package"


# logger = logging.getLogger(Path(__file__).name)
logger = logging.root


def to_SQL_list(items: Iterable) -> str:
    comma_separated_items = ",".join(str(item) for item in items)
    return f"({comma_separated_items})"


def to_SQL_list_of_strings(strings: Iterable) -> str:
    return to_SQL_list(f"'{string}'" for string in strings)


def parse_csv(cronometer_csv: Path) -> tuple[dict, list]:
    csv_days = defaultdict(list)
    with open(cronometer_csv) as csvfile:
        reader = csv.reader(csvfile)
        csv_header = next(reader)
        for row in reader:
            day = row[0]
            csv_days[day].append(row)

    headers = ["timestamp"]
    csv_header.pop(0)
    for header in csv_header:
        for old_and_new in (" ", "_"), ("(", "_"), (")", ""), ("-", "_"):
            header = header.replace(*old_and_new)
        headers.append(header.lower())

    return csv_days, headers


def import_data(csv_days: dict, headers: list, cursor: sqlite3.Cursor) -> int:
    select_query = f"""
        SELECT
            date(timestamp, 'auto') AS day,
            SUM(energy__kcal) AS kcal
        FROM
            food_tracks
        WHERE
            day IN {to_SQL_list_of_strings(csv_days)}
        GROUP BY
            day
    """
    cursor.execute(select_query)
    kcal_sums_in_db = {day: sum_ for day, sum_ in cursor.fetchall()}
    logging.debug(f"{kcal_sums_in_db=}")

    days_to_import = defaultdict(list)
    for day, food_tracks in csv_days.items():
        if not kcal_sums_in_db.get(day):
            logging.debug(f"{day} kcal in db IS NULL")
            days_to_import[day] = food_tracks
            continue

        CALORIES_INDEX = 3
        kcal_sum_in_csv = sum(float(track[CALORIES_INDEX]) for track in food_tracks)
        logging.debug(f"{day} {kcal_sum_in_csv = :.2f}, {kcal_sums_in_db[day] = :.2f}")
        if int(kcal_sum_in_csv) > int(kcal_sums_in_db[day]):  # overwrite existing food_tracks
            logging.debug(f"include {day} food tracks")
            days_to_import[day] = food_tracks
        else:
            logging.debug(f"exclude {day} food tracks")

    if not days_to_import.values():
        return 0

    values_bind = ["unixepoch(date(?))"] + ["?"] * (len(headers) - 1)
    insert_query = f"""
        INSERT OR IGNORE INTO food_tracks {to_SQL_list(headers)}
        VALUES {to_SQL_list(values_bind)}
    """

    delete_query = f"""
    DELETE FROM
        food_tracks
    WHERE
        date(timestamp, 'auto') IN {to_SQL_list_of_strings(days_to_import)}
    """

    food_tracks_to_import = list(chain.from_iterable(days_to_import.values()))

    cursor.execute("BEGIN")
    cursor.execute(delete_query)
    try:
        cursor.executemany(insert_query, food_tracks_to_import)
        return cursor.rowcount
    except sqlite3.OperationalError:
        cursor.execute("ROLLBACK")
        logger.error("error during insert query execution")
        raise


def main(vault_db: Path, outer_csv: Path) -> int:
    csv_days, csv_header = parse_csv(outer_csv)
    logging.debug(f"found {len(csv_days)} days from csv")
    with sqlite3.connect(vault_db, timeout=10) as connection:
        inserted_entries = import_data(csv_days, csv_header, connection.cursor())
        connection.commit()
    return inserted_entries
