#!/usr/bin/env python
import csv
import sqlite3
import logging

from pathlib import Path
from datetime import datetime


__datasource__ = "net.daylio"
__datasourcetype__ = "android:package"


# logger = logging.getLogger(Path(__file__).name)
logger = logging.root


def main(vault_db: Path, outer_csv: Path) -> int:
    connection = sqlite3.connect(vault_db, timeout=10)
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
        logger.exception("Error during data import")
        raise

    connection.commit()
    inserted_rows = cursor.rowcount
    connection.close()

    return inserted_rows
