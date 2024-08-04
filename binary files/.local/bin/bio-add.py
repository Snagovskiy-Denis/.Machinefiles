#!/usr/bin/env python
import sqlite3
import subprocess

from enum import Enum

from typer import Exit, confirm, run
from rich import print

from userlib.common_types import VaultDB


class Metric(str, Enum):
    weight = "weight"
    waist = "waist"

    belly = "belly"
    neck = "neck"
    shoulders = "shoulders"
    chest = "chest"
    left_biceps = "left_biceps"
    right_biceps = "right_biceps"
    left_forearm = "left_forearm"
    right_forearm = "right_forearm"
    hip = "hip"
    left_thigh = "left_thigh"
    right_thigh = "right_thigh"
    left_calf = "left_calf"
    right_calf = "right_calf"


def add(value: float, metric: Metric, db: sqlite3.Cursor) -> None:
    "Add todays metric to database"

    today_ts = "unixepoch(date('now'))"
    db.execute(f"SELECT {metric.name} FROM biometry WHERE timestamp = {today_ts}")

    row = db.fetchone()
    db_metric = row[0] if row else None
    if db_metric == value:
        print(f"{db_metric} is already set as todays {metric.name}.")
        raise Exit()
    if db_metric is not None:
        confirm(f"Overwrite {metric.name} {db_metric} with {value}?", abort=True)

    query_insert = f"INSERT OR IGNORE INTO biometry ({metric.name}) VALUES(?)"
    query_update = f"UPDATE biometry SET {metric.name} = ? WHERE timestamp = {today_ts}"
    for query in query_insert, query_update:
        db.execute(query, [str(value)])


def main(value: float, metric: Metric, db_path: VaultDB):
    with sqlite3.connect(db_path) as connection:
        add(value, metric, connection.cursor())
        connection.commit()

    print("[green]Done ✅[/green]\n")
    subprocess.run(["bio-today"])


if __name__ == "__main__":
    run(main)
