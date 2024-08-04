#!/usr/bin/env python
import sys
import sqlite3
import logging
import enum

from typer import run, FileText

from userlib.common_types import VaultDB
from userlib.loggers import setup_default_logging


__datasource__ = "A0:77:9E:6E:BC:C8"
__datasourcetype__ = "device:scales:lxl-2112"

UNIT_OR_CMD_IDX = 6


class CMD(int, enum.Enum):
    null_kg = 36
    null_lb = 48


class Unit(int, enum.Enum):
    kg = 37
    lb = 49


def deserialize_weight(hexidecimal: str) -> float:
    data = bytearray.fromhex(hexidecimal)
    raw_weight = int.from_bytes(data[:2])
    match data[UNIT_OR_CMD_IDX]:
        case Unit.kg:
            return raw_weight / 100
        case Unit.lb:
            return (raw_weight / 10) / 2.205  # convert to kg
        case CMD.null_kg | CMD.null_lb:
            raise ValueError("Ignore 'display on' cmd")
        case _ as v:
            raise TypeError(f"Unknown cmd/unit {v} from {hexidecimal}")


def store(*, stdin: FileText = sys.stdin, vault_db: VaultDB):  # type: ignore
    for raw_data in stdin:
        try:
            logging.info(f"received {raw_data.strip('\n')}")
            weight = deserialize_weight(raw_data)
        except ValueError as e:
            logging.debug(str(e))
            continue
        except TypeError as e:
            logging.error(f"invalid scales data {e}")
            raise

        with sqlite3.connect(vault_db) as conn:
            where_today = " WHERE timestamp = unixepoch(date('now'))"

            if conn.execute(f"SELECT weight FROM biometry {where_today}").fetchone():
                logging.debug("today's weight is already in the db")
                continue

            query_insert = "INSERT OR IGNORE INTO biometry (weight) VALUES(?)"
            query_update = f"UPDATE biometry SET weight = ? {where_today}"
            for query in query_insert, query_update:
                conn.execute(query, [str(weight)])
            conn.commit()

            logging.warning(f"Today's weight is {weight}")


if __name__ == "__main__":
    setup_default_logging(logging.root, "etl/lxl_2112.py")
    run(store)
