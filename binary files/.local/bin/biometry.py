#!/usr/bin/env python
import sqlite3

from pathlib import Path
from typing import Annotated
from itertools import chain
from enum import Enum

from typer import Argument, Typer, Option, confirm, Exit
from rich import print, print_json


connection: sqlite3.Connection = None


def close_connection(_):
    if connection.in_transaction:
        connection.commit()
    connection.close()


app = Typer(
    help="Helper functions for interacting with your body data",
    result_callback=close_connection,
)


def open_connection(db_path: Path):
    global connection
    connection = sqlite3.connect(db_path)
    return connection.cursor()


DB = Annotated[
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
    # daily = "D"
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
    resample: Resample = Resample.weekly,
    annotations: bool = True,
    energy_balance: bool = True,
    calories: bool = True,
    steps: bool = True,
    daily_weight: bool = False,
    *,
    db: DB,
):
    "Plots a graph showing trends in weight and energy balance."

    # move heavy imports here to speed up cli autocompletions and other biometry commands
    import pandas as pd
    import matplotlib.pyplot as plt

    select_query = SELECT_PROGRESS
    if delta_days_from_now:
        select_query += f"""
        WHERE
            bio.timestamp > unixepoch('now', '-{delta_days_from_now} day')
            -- AND bio.timestamp < unixepoch(date('now'))
        """
    select_query += " ORDER BY bio.timestamp"
    df_raw = pd.read_sql_query(select_query, db.connection)
    df_raw["day"] = pd.to_datetime(df_raw["day"])

    df = df_raw.resample(resample.value, on="day").mean()
    df["weight_diff"] = df["weight"].diff()
    df["weight_diff_percentage"] = (df["weight_diff"] / df["weight"].shift(1))

    plots = []
    fig, ax_w_diff = plt.subplots()

    color_reg = "tab:red"
    line_1 = ax_w_diff.plot(
        df.index,
        df["weight"],
        color=color_reg,
        label="Weight Change (kg)",
        linewidth=2,
        marker="x",
    )
    ax_w_diff.tick_params(axis="y", labelcolor=color_reg)
    ax_w_diff.set_ylabel("kg", color=color_reg)
    if annotations:
        for index, row in df.iterrows():
            weight_diff = row["weight_diff"]
            weight_diff_percentage = row["weight_diff_percentage"]
            if not pd.isnull(weight_diff):
                ax_w_diff.annotate(
                    f"Δ {weight_diff:+.2f} ({weight_diff_percentage:.2%})",
                    xy=(index, row["weight"]),
                    textcoords="offset points",
                    xytext=(45, 10),
                    ha="center",
                )
    plots.append(line_1)

    color_skyblue = "skyblue"
    ax_waist = ax_w_diff.twinx()
    line_2 = ax_waist.plot(
        df.index,
        df["waist"],
        color=color_skyblue,
        label="Waist Girth (cm)",
        alpha=0.7,
        linewidth=2,
        marker="o",
    )
    ax_waist.set_ylim(bottom=85, top=115)
    ax_waist.yaxis.set_label_position("left")
    ax_waist.set_ylabel("cm", color=color_skyblue, loc="bottom")
    ax_waist.tick_params(
        axis="y",
        labelcolor=color_skyblue,
        labelleft=True,
        labelright=False,
    )
    plots.append(line_2)

    if daily_weight:
        ax_weight = ax_w_diff.twinx()
        color_orange = "orange"
        line_3 = ax_weight.plot(
            df_raw["day"],
            df_raw["weight"],
            color=color_orange,
            alpha=0.2,
            label="Daily Weight (kg)",
        )
        # ax_weight.set_ylabel("kg", color=color_orange)
        # ax_weight.tick_params(axis="y", labelcolor=color_orange)
        ax_weight.set_yticklabels([])
        plots.append(line_3)

    if energy_balance and calories:
        ax_kcal = ax_w_diff.twinx()
        color4 = "green"
        line_4 = ax_kcal.plot(
            df.index,
            df["kcal"],
            color=color4,
            alpha=0.3,
            label="Calories Intake (kcal)",
        )
        ax_kcal.set_ylabel("kcal", color=color4, loc="bottom")
        ax_kcal.tick_params(axis="y", labelcolor=color4)
        ax_kcal.set_ylim(bottom=1000, top=2500)
        plots.append(line_4)

    if energy_balance and steps:
        ax_steps = ax_w_diff.twinx()
        color5 = "brown"
        line_5 = ax_steps.plot(
            df.index,
            df["steps"],
            color=color5,
            alpha=0.3,
            label="Number of Steps (steps)",
        )
        ax_steps.set_ylabel("steps", color=color5, loc="top")
        ax_steps.tick_params(axis="y", labelcolor=color5)
        ax_steps.set_ylim(bottom=500, top=12000)
        plots.append(line_5)

    plots = list(chain.from_iterable(plots))
    ax_w_diff.legend(plots, [p.get_label() for p in plots], loc="upper right")

    fig.set_size_inches(9, 9)
    fig.tight_layout()
    ax_w_diff.grid(True, axis="y")

    plt.title(resample.label("Trends: Body Composition and Energy Balance"))
    plt.show()


@app.command()
def today(db: DB):
    "Show todays metrics"

    db.execute(f"{SELECT_PROGRESS} WHERE date(bio.timestamp, 'auto') = date('now')")
    db.row_factory = sqlite3.Row  # pyright: ignore
    result = db.fetchone() or {}
    print_json(data=dict(result))


@app.command()
def add(
    todays_metric: float,
    *,
    metric: Annotated[Metric, Option("-m", prompt=True)],
    db: DB,
):
    "Add todays metric to database"

    today_ts = "unixepoch(date('now'))"
    db.execute(f"SELECT {metric.name} FROM biometry WHERE timestamp >= {today_ts}")
    if row := db.fetchone():
        db_metric = row[0]
        if db_metric == todays_metric:
            print(f"{db_metric} is already set as todays {metric.name}.")
            raise Exit()
        confirm(f"Overwrite {metric.name} {db_metric} with {todays_metric}?", abort=True)

    query_i = f"INSERT OR IGNORE INTO biometry (timestamp, {metric.name}) VALUES({today_ts},?)"
    db.execute(query_i, [todays_metric])
    query_u = f"UPDATE biometry SET {metric.name} = ? WHERE timestamp = {today_ts}"
    db.execute(query_u, [todays_metric])
    print("Done ✅\n")
    today(db)


if __name__ == "__main__":
    app()
