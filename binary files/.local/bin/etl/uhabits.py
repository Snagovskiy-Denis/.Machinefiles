#!/usr/bin/env python
"""
Parses org.isoron.uhabits app backup for requested habits

You shall describe habits you want to transfer in the vault db, providing an
external_id that matches id of a habit in the Loop backup.

Loop tracker data anomaly: timestamps and values of numeric habits are
multiplied by 1000.
"""

import sqlite3
import logging

from pathlib import Path


__datasource__ = "org.isoron.uhabits"
__datasourcetype__ = "android:package"


ANOMALY_TYPE = 1
ANOMALY_MULTIPLIER = 1000


# logger = logging.getLogger(Path(__file__).name)
logger = logging.root


def main(vault_db: Path, outer_db: Path) -> int:
    connection = sqlite3.connect(vault_db, timeout=10)
    cursor = connection.cursor()

    cursor.execute(f"ATTACH DATABASE '{outer_db}' AS outer_db")

    query = f"""
        INSERT OR IGNORE INTO
            habits_repetitions (habit_id, timestamp, value, notes)
        SELECT
            vault_habits.id AS habit_id,
            timestamp / {ANOMALY_MULTIPLIER},
            CASE
                WHEN outer_habits.type != {ANOMALY_TYPE} THEN value
                ELSE value / {ANOMALY_MULTIPLIER}
            END AS value,
            notes
        FROM
            outer_db.Repetitions
            INNER JOIN outer_db.Habits as outer_habits
            ON habit = outer_habits.id
            INNER JOIN habits AS vault_habits
            ON habit = vault_habits.external_id
    """

    cursor.execute("BEGIN")
    try:
        cursor.execute(query)
    except sqlite3.OperationalError:
        cursor.execute("ROLLBACK")
        logger.error("error during insert query execution")
        raise

    connection.commit()
    inserted_rows = cursor.rowcount
    cursor.execute("DETACH DATABASE outer_db")
    connection.close()

    return inserted_rows
