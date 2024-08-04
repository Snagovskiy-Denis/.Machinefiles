from typing import Annotated
from pathlib import Path

from typer import Option


VaultDB = Annotated[
    Path,
    Option(
        envvar="ZETTELKASTEN_DB",
        exists=True,
        dir_okay=False,
        readable=True,
        resolve_path=True,
        show_default=False,
        is_eager=True,
        help="Vault database file path",
    )
]
