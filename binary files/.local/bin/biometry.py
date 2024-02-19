#!/usr/bin/env python
import sqlite3

from pathlib import Path
from typing import Annotated
from itertools import chain

import pandas as pd
import matplotlib.pyplot as plt

from typer import Argument, Typer, Option, confirm, Exit
from rich import print


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


FROM_SQL = """
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
def weight(
    delta_days_from_now: Annotated[
        int,
        Argument(min=0, help="Enter 0 to show all days"),
    ] = 30,
    exclude_today: bool = True,
    weight: bool = False,
    annotations: bool = True,
    calories: bool = True,
    steps: bool = True,
    *,
    db: VaultDB,
):
    "Shows weight dynamics"

    select_query = f"""
    SELECT
        date(bio.timestamp, 'auto') AS day,
        bio.weight,
        bio.waist,
        food_totals.kcal AS kcal,
        steps.value AS steps
    {FROM_SQL}
    """
    if delta_days_from_now:
        select_query += f"""
        WHERE
            bio.timestamp > unixepoch('now', '-{delta_days_from_now} day')
        """
        if exclude_today:
            select_query += " AND bio.timestamp < unixepoch(date('now'), 'utc')"
    df = pd.read_sql_query(select_query, db.connection)
    df["day"] = pd.to_datetime(df["day"])

    df_weekly = df.resample("W-Mon", on="day").mean()
    df_weekly["weight_diff"] = df_weekly["weight"].diff()
    waist_data = df[df["waist"].notnull()]

    # weight_mean = df["weight"].mean()

    plots = []
    fig, ax_w_diff = plt.subplots()

    color_reg = "tab:red"
    line_1 = ax_w_diff.plot(
        df_weekly.index,
        df_weekly["weight"],
        color=color_reg,
        label="Weekly Weight Change (kg)",
        linewidth=2,
        marker="x",
    )
    ax_w_diff.tick_params(axis="y", labelcolor=color_reg)
    ax_w_diff.set_ylabel("kg", color=color_reg)
    if annotations:
        for index, row in df_weekly.iterrows():
            weight_diff = row["weight_diff"]
            if not pd.isnull(weight_diff):
                ax_w_diff.annotate(
                    f"{weight_diff:.2f}",
                    xy=(index, row["weight"]),
                    textcoords="offset points",
                    xytext=(10, 10),
                    ha="center",
                )
    plots.append(line_1)

    color_skyblue = "skyblue"
    ax_waist = ax_w_diff.twinx()
    ax_waist.set_ylabel("cm", color=color_skyblue)
    ax_waist.yaxis.set_label_coords(1.05, 0.25)
    line_2 = ax_waist.plot(
        waist_data["day"],
        waist_data["waist"],
        color=color_skyblue,
        label="Waist Girth (cm)",
        alpha=0.7,
        linewidth=2,
        marker="o",
    )
    ax_waist.set_ylim(bottom=85, top=115)
    # ax_waist.set_aspect(weight_mean / waist_data["waist"].mean())
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

    if calories:
        ax_kcal = ax_w_diff.twinx()
        color4 = "green"
        ax_kcal.set_ylabel("kcal", color=color4)
        ax_kcal.yaxis.set_label_coords(1.05, 0.85)
        line_4 = ax_kcal.plot(
            df_weekly.index,
            df_weekly["kcal"],
            color=color4,
            alpha=0.3,
            label="Weekly Calories Intake (kcal)",
        )
        ax_kcal.tick_params(axis="y", labelcolor=color4)
        ax_kcal.set_ylim(bottom=1000, top=3000)
        # ax_kcal.set_aspect(weight_mean / df["kcal"].mean())
        plots.append(line_4)

    if steps:
        ax_steps = ax_w_diff.twinx()
        color5 = "brown"
        ax_steps.set_ylabel("steps", color=color5)
        line_5 = ax_steps.plot(
            df_weekly.index,
            df_weekly["steps"],
            color=color5,
            alpha=0.3,
            label="Weekly Number of Steps (steps)",
        )
        ax_steps.tick_params(axis="y", labelcolor=color5)
        ax_steps.set_ylim(bottom=500, top=12000)
        # ax_steps.set_aspect(weight_mean / df["steps"].mean())
        plots.append(line_5)

    plots = list(chain.from_iterable(plots))
    ax_w_diff.legend(plots, [p.get_label() for p in plots], loc="upper left")

    fig.set_size_inches(9, 9)
    fig.tight_layout()
    ax_w_diff.grid(True, axis="y")

    plt.show()


@app.command()
def today(db: VaultDB):
    "Show todays stats"

    select_query = f"""
    SELECT
        bio.weight IS NOT NULL AS weight_entered,
        bio.waist IS NOT NULL AS waist_entered,
        food_totals.kcal IS NOT NULL AS food_entered,
        steps.value IS NOT NULL AS steps_entered
    {FROM_SQL}
    WHERE
        date(bio.timestamp, 'auto') = date('now')
    """
    db.execute(select_query)
    db.row_factory = sqlite3.Row
    if result := db.fetchone():
        for k, v in dict(result).items():
            print(f"'{k}': {bool(v)}")
    else:
        print("No today's data :(")


@app.command()
def add(todays_weight: float, db: VaultDB):
    "Add todays weight"

    today = "unixepoch(date('now'))"
    db.execute(f"SELECT weight FROM biometry WHERE timestamp >= {today}")
    if row := db.fetchone():
        db_weight = row[0]
        if db_weight == todays_weight:
            print(f"{db_weight} is already set as todays weight.")
            raise Exit()
        confirm(f"Overwrite {db_weight} with {todays_weight}?", abort=True)

    qeury = f"INSERT OR REPLACE INTO biometry (timestamp, weight) VALUES({today},?)"
    db.execute(qeury, [todays_weight])
    print("Done ✅")


if __name__ == "__main__":
    app()
