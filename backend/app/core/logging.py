"""Small logging bootstrap for the Phase 0 application."""

import logging as stdlib_logging


def configure_logging() -> None:
    """Configure a useful default log format without adding business behavior."""

    stdlib_logging.basicConfig(
        level=stdlib_logging.INFO,
        format="%(asctime)s %(levelname)s %(name)s %(message)s",
    )
