#!/usr/bin/env python
import sqlite3
import os
import json


SELECT_QUERY = f"""
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
    WHERE
        date(bio.timestamp, 'auto') = date('now')
"""

with sqlite3.connect(os.environ["ZETTELKASTEN_DB"]) as connection:
    cursor = connection.cursor()
    cursor.execute(SELECT_QUERY)
    cursor.row_factory = sqlite3.Row  # pyright: ignore
    result = cursor.fetchone() or {}
    print(json.dumps(dict(result)))

# time (./test_biometry.py | jq)
# 0.06s


# from plumbum import local
# from plumbum.cmd import sqlite3, jq

# db_json = sqlite3["-cmd", ".mode json", local.env["ZETTELKASTEN_DB"]] << SELECT_QUERY
# format_json = jq[".[0]", "-C"] << db_json()
# print(format_json())
# # time ./test_biometry.py
# # 0.19s
