#!/usr/bin/env python
import sys

from systemd import journal
from enum import Enum

from typer import Typer
from plumbum.cmd import notify_send


app = Typer()


__datasource__ = "A0:77:9E:6E:BC:C8"
__datasourcetype__ = "device:scales:lxl-2112"


class Unit(int, Enum):
    null_kg = 36
    null_lb = 48

    kg = 37
    lb = 49
    # lb = 10
    # kg = 100

    @classmethod
    def from_byte(cls, byte: int):
        return next(filter(lambda unit: unit.value == byte, cls))

    def apply_to(self, raw_weight: int) -> float:
        divisor = {Unit.kg: 100, Unit.lb: 10}.get(self, 1)
        return raw_weight / divisor


def deserialize():
    pass


@app.command()
def store():
    # parse and validate stind by line,
    # filter out empty data and insert to db if today is missing
    # log and notify-send result
    pass


@app.command(help="print defenition of bytes in a table format")
def legend():
    # print reverse engineering bytes table
    pass


if __name__ == "__main__":
    app()
