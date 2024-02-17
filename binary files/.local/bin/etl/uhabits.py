#!/usr/bin/env python
"""
Parses org.isoron.uhabits app backup for requested habits

You shall describe habits you want to transfer in the vault db, providing an
external_id that matches id of a habit in the Loop backup.
"""

import sqlite3
import logging

from pathlib import Path
from dataclasses import dataclass


# logger = logging.getLogger(Path(__file__).name)
logger = logging.root


@dataclass(frozen=True, slots=True)
class Habit:
    id: int
    external_id: int
    value_cleaner: str | None

    @classmethod
    def factory(cls, _, row):
        return cls(*row)


def main(*, outer_db: Path, vault_db: Path) -> int:
    connection = sqlite3.connect(vault_db, timeout=10)
    cursor = connection.cursor()

    cursor.execute(f"ATTACH DATABASE '{outer_db}' AS outer_db")

    cursor_habits = connection.cursor()
    sql = """
        SELECT
            id,
            external_id,
            metadata ->> 'value_cleaner'
        FROM
            habits
    """
    cursor_habits.execute(sql)
    cursor_habits.row_factory = Habit.factory
    habits: list[Habit] = cursor_habits.fetchall()
    cursor_habits.close()

    # generate dynamic sql statement parts for data cleaning
    value_cleaners = []
    for habit in habits:
        if habit.external_id and habit.value_cleaner:
            external_id, corrector = habit.external_id, habit.value_cleaner
            value_cleaners.append(f"WHEN habit = {external_id} THEN {corrector}")
    if not value_cleaners:
        value_cleaners.append("WHEN true THEN value")
    value_cleaner_sql = "\n".join(stmt for stmt in value_cleaners)

    query = f"""
        INSERT OR IGNORE INTO
            habits_repetitions (habit_id, timestamp, value, notes)
        SELECT
            vault_habits.id AS habit_id,
            timestamp,
            CASE
                {value_cleaner_sql}
                ELSE value
            END AS value,
            notes
        FROM
            outer_db.Repetitions
            INNER JOIN habits AS vault_habits
            ON habit = vault_habits.external_id
    """

    try:
        cursor.execute(query)
    except sqlite3.OperationalError:
        logger.exception("error during data transfer")
        raise

    connection.commit()
    inserted_rows = cursor.rowcount
    cursor.execute("DETACH DATABASE outer_db")
    connection.close()

    return inserted_rows
