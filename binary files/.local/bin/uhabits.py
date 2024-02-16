#!/usr/bin/env python
"""
Parses org.isoron.uhabits app backup for requested habits

Accepts path to backup as a first argument.

You shall describe habits you want to transfer in the vault db, providing an
external_id that matches id of a habit in the Loop backup.
"""

import os
import sys
import sqlite3
import logging
import logging.handlers

from pathlib import Path
from dataclasses import dataclass


VAULT_ENV = "ZETTELKASTEN"
VAULT_DB_NAME = "../db.sqlite3"

__appname__ = f"parsers/{Path(__file__).name}"

syslog_handler = logging.handlers.SysLogHandler(address="/dev/log")
formatter = logging.Formatter(f"{__appname__} - %(levelname)s - %(message)s")
syslog_handler.setFormatter(formatter)
logging.root.addHandler(syslog_handler)
logging.root.setLevel(logging.INFO)


@dataclass(frozen=True)
class Habit:
    id: int
    external_id: int
    value_cleaner: str | None = None

    @classmethod
    def factory(cls, _, row):
        return cls(*row)


def main(*, outer_db: Path, vault_db: Path) -> None:
    connection = sqlite3.connect(vault_db)
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

    # generate dynamic sql statement parts
    internal_habits_ids = ",".join([str(h.id) for h in habits])
    value_cleaners = []
    for habit in habits:
        if habit.external_id and habit.value_cleaner:
            external_id, corrector = habit.external_id, habit.value_cleaner
            value_cleaners.append(f"WHEN habit = {external_id} THEN {corrector}")
    if not value_cleaners:
        value_cleaners.append("WHEN true THEN value")
    value_correctors_sql = "\n".join(stmt for stmt in value_cleaners)

    select_query = f"""
    SELECT
        h.id AS habit_id,
        timestamp,
        CASE
            {value_correctors_sql}
            ELSE value
        END AS value,
        notes
    FROM
        outer_db.Repetitions
        JOIN habits AS h ON habit = h.external_id
    WHERE
        (h.id, timestamp) NOT IN (
            SELECT
                habit_id,
                timestamp
            FROM
                habits_repetitions
            WHERE
                habit_id IN ({internal_habits_ids})
        )
    """
    insert_query = """
    INSERT OR IGNORE INTO habits_repetitions (habit_id, timestamp, value, notes)
    """

    query = f"{insert_query}\n{select_query}"

    try:
        cursor.execute(query)
    except sqlite3.OperationalError:
        logging.exception("Error during data transfer")
        raise

    connection.commit()
    cursor.execute("DETACH DATABASE outer_db")
    connection.close()


if __name__ == "__main__":
    try:
        vault = Path(os.environ[VAULT_ENV])
    except KeyError:
        msg = f"Improper system configuration. Missing {VAULT_ENV=}"
        logging.error(msg)
        print(msg, file=sys.stderr)
        exit(1)
    else:
        vault_db = vault / VAULT_DB_NAME

    if len(sys.argv) < 2:
        print("Missing backup file path.", file=sys.stderr)
        exit(1)

    outer_db = Path(sys.argv[1])
    logging.info(f"processing {outer_db}")

    try:
        main(outer_db=outer_db, vault_db=vault_db)
    except Exception:
        logging.exception("cannot import backup data")
        raise
