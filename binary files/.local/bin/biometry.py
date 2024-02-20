#!/usr/bin/env python
import sqlite3
import json

from pathlib import Path
from typing import Annotated
from itertools import chain
from enum import Enum

import pandas as pd
import matplotlib.pyplot as plt

from typer import Argument, Typer, Option, confirm, Exit
from rich import print
from rich.table import Table
from rich.console import Console


connection: sqlite3.Connection = None


def close_connection(_):
    global connection
    if connection.in_transaction:
        connection.commit()
    connection.close()


app = Typer(
    help="Helper functions to watch weight data",
    result_callback=close_connection,
)


def open_connection(db_path: Path):
    global connection
    connection = sqlite3.connect(db_path)
    return connection.cursor()


VaultDB = Annotated[
    sqlite3.Cursor,
    Option(
        envvar="ZETTELKASTEN_DB",
        exists=True,
        dir_okay=False,
        readable=True,
        resolve_path=True,
        show_default=False,
        callback=open_connection,
        help="Vault database file path",
    ),
]


class Resample(str, Enum):
    weekly = "W-Mon"
    monthly = "M"
    quarterly = "Q"
    yearly = "Y"

    def label(self, text: str) -> str:
        return f"{self.name.capitalize()} {text}"


class Metric(str, Enum):
    weight = "weight"
    waist = "waist"


SELECT_PROGRESS = f"""
    SELECT
        date(bio.timestamp, 'auto') AS day,
        bio.weight,
        bio.waist,
        food_totals.kcal AS kcal,
        steps.value AS steps
    FROM
        biometry AS bio
    LEFT JOIN
        habits_repetitions AS steps
        ON steps.habit_id = 1  -- Ходьба
        AND date(bio.timestamp, 'auto') = date(steps.timestamp, 'auto')
    LEFT JOIN (
            SELECT
                ft.timestamp,
                SUM(ft.energy__kcal) AS kcal
            FROM
                food_tracks AS ft
            GROUP BY
                ft.timestamp
        ) AS food_totals
        ON date(bio.timestamp, 'auto') = date(food_totals.timestamp, 'auto')
"""


@app.command()
def plot(
    delta_days_from_now: Annotated[
        int,
        Argument(min=0, help="Enter 0 to show all days"),
    ] = 30,
    exclude_today: bool = True,
    weight: bool = False,
    annotations: bool = True,
    balance: bool = True,
    calories: bool = True,
    steps: bool = True,
    resample: Resample = Resample.weekly,
    *,
    db: VaultDB,
):
    "Plots a graph showing trends in weight and energy balance."

    select_query = SELECT_PROGRESS
    if delta_days_from_now:
        select_query += f"""
        WHERE
            bio.timestamp > unixepoch('now', '-{delta_days_from_now} day')
        """
        if exclude_today:
            select_query += " AND bio.timestamp < unixepoch(date('now'))"
    select_query += " ORDER BY bio.timestamp"
    df = pd.read_sql_query(select_query, db.connection)
    df["day"] = pd.to_datetime(df["day"])

    df_resampled = df.resample(resample.value, on="day").mean()
    df_resampled["weight_diff"] = df_resampled["weight"].diff()

    plots = []
    fig, ax_w_diff = plt.subplots()

    color_reg = "tab:red"
    line_1 = ax_w_diff.plot(
        df_resampled.index,
        df_resampled["weight"],
        color=color_reg,
        label=resample.label("Weight Change (kg)"),
        linewidth=2,
        marker="x",
    )
    ax_w_diff.tick_params(axis="y", labelcolor=color_reg)
    ax_w_diff.set_ylabel("kg", color=color_reg)
    if annotations:
        for index, row in df_resampled.iterrows():
            bodyweight = row["weight"]
            weight_diff = row["weight_diff"]
            if not pd.isnull(weight_diff):
                ax_w_diff.annotate(
                    f"{weight_diff:.2f} ({weight_diff / bodyweight:.2%})",
                    xy=(index, row["weight"]),
                    textcoords="offset points",
                    xytext=(35, 10),
                    ha="center",
                )
    plots.append(line_1)

    color_skyblue = "skyblue"
    ax_waist = ax_w_diff.twinx()
    ax_waist.set_ylabel("cm", color=color_skyblue)
    ax_waist.yaxis.set_label_coords(1.05, 0.25)
    line_2 = ax_waist.plot(
        df_resampled.index,
        df_resampled["waist"],
        color=color_skyblue,
        label=resample.label("Waist Girth (cm)"),
        alpha=0.7,
        linewidth=2,
        marker="o",
    )
    ax_waist.set_ylim(bottom=85, top=115)
    ax_waist.tick_params(axis="y", labelcolor=color_skyblue)
    plots.append(line_2)

    if weight:
        ax_weight = ax_w_diff.twinx()
        color_orange = "orange"
        ax_weight.set_ylabel("kg", color=color_orange)
        line_3 = ax_weight.plot(
            df["day"],
            df["weight"],
            color=color_orange,
            alpha=0.3,
            label="Daily Weight (kg)",
        )
        ax_weight.tick_params(axis="y", labelcolor=color_orange)
        plots.append(line_3)

    if balance and calories:
        ax_kcal = ax_w_diff.twinx()
        color4 = "green"
        ax_kcal.set_ylabel("kcal", color=color4)
        ax_kcal.yaxis.set_label_coords(1.05, 0.85)
        line_4 = ax_kcal.plot(
            df_resampled.index,
            df_resampled["kcal"],
            color=color4,
            alpha=0.3,
            label=resample.label("Calories Intake (kcal)"),
        )
        ax_kcal.tick_params(axis="y", labelcolor=color4)
        ax_kcal.set_ylim(bottom=1000, top=2500)
        plots.append(line_4)

    if balance and steps:
        ax_steps = ax_w_diff.twinx()
        color5 = "brown"
        ax_steps.set_ylabel("steps", color=color5)
        line_5 = ax_steps.plot(
            df_resampled.index,
            df_resampled["steps"],
            color=color5,
            alpha=0.3,
            label=resample.label("Number of Steps (steps)"),
        )
        ax_steps.tick_params(axis="y", labelcolor=color5)
        ax_steps.set_ylim(bottom=500, top=12000)
        plots.append(line_5)

    plots.append(plots.pop(1))  # resort waist
    plots = list(chain.from_iterable(plots))
    ax_w_diff.legend(plots, [p.get_label() for p in plots], loc="upper left")

    fig.set_size_inches(9, 9)
    fig.tight_layout()
    ax_w_diff.grid(True, axis="y")

    plt.show()


@app.command()
def today(db: VaultDB, as_json: bool = False, rotate: bool = False):
    "Show todays stats"

    db.execute(f"{SELECT_PROGRESS} WHERE date(bio.timestamp, 'auto') = date('now')")
    db.row_factory = sqlite3.Row  # pyright: ignore

    match db.fetchone(), as_json:
        case None, True:
            print(json.dumps(None))
        case None, False:
            print("No today' data :(")
        case _ as result, True:
            print(json.dumps(dict(result)))
        case _ as result, False:
            if not rotate:
                table = Table(*result.keys())
                table.add_row(*[v if v is None else str(v) for v in result])
            else:
                table = Table("metric", "value")
                items = iter(dict(result).items())
                table.title = next(items)[1]
                for key, value in items:
                    table.add_row(key, value if value is None else str(value))
            Console().print(table)


@app.command()
def add(
    todays_metric: float,
    *,
    metric: Annotated[Metric, Option("-m", prompt=True)],
    db: VaultDB,
):
    "Add todays metric"

    today = "unixepoch(date('now'))"
    db.execute(f"SELECT {metric.name} FROM biometry WHERE timestamp >= {today}")
    if row := db.fetchone():
        db_metric = row[0]
        if db_metric == todays_metric:
            print(f"{db_metric} is already set as todays {metric.name}.")
            raise Exit()
        confirm(f"Overwrite {metric.name} {db_metric} with {todays_metric}?", abort=True)

    query_i = f"INSERT OR IGNORE INTO biometry (timestamp, {metric.name}) VALUES({today},?)"
    db.execute(query_i, [todays_metric])
    query_u = f"UPDATE biometry SET {metric.name} = ? WHERE timestamp = {today}"
    db.execute(query_u, [todays_metric])
    print("Done ✅")


if __name__ == "__main__":
    app()
