#!/usr/bin/env python3
"""Export helpers for experiment-result figures."""

from __future__ import annotations

from pathlib import Path
from typing import Union

import matplotlib.pyplot as plt

PathLike = Union[str, Path]

JOURNAL_EXPORTS = {
    "nature": {
        "line_art": {"formats": ["pdf", "png"], "dpi": 1000},
        "photo": {"formats": ["png"], "dpi": 300},
        "combination": {"formats": ["pdf", "png"], "dpi": 600},
    },
    "science": {
        "line_art": {"formats": ["pdf", "png"], "dpi": 1000},
        "photo": {"formats": ["png"], "dpi": 300},
        "combination": {"formats": ["pdf", "png"], "dpi": 600},
    },
    "cell": {
        "line_art": {"formats": ["pdf", "png"], "dpi": 1000},
        "photo": {"formats": ["png"], "dpi": 300},
        "combination": {"formats": ["pdf", "png"], "dpi": 600},
    },
    "plos": {
        "line_art": {"formats": ["pdf", "png"], "dpi": 600},
        "photo": {"formats": ["png"], "dpi": 300},
        "combination": {"formats": ["pdf", "png"], "dpi": 300},
    },
}

JOURNAL_WIDTHS_MM = {
    "nature": {"single": 89.0, "double": 183.0, "max_height": 247.0},
    "science": {"single": 55.0, "double": 175.0, "max_height": 233.0},
    "cell": {"single": 85.0, "double": 178.0, "max_height": 230.0},
    "plos": {"single": 83.0, "double": 173.0, "max_height": 233.0},
}

MM_PER_INCH = 25.4


def save_publication_figure(
    fig: plt.Figure,
    filename: PathLike,
    formats: list[str] | None = None,
    dpi: int = 300,
    transparent: bool = False,
    bbox_inches: str = "tight",
    pad_inches: float = 0.1,
    facecolor: str = "white",
    **kwargs,
) -> list[Path]:
    target = Path(filename)
    output_dir = target.parent if target.parent != Path("") else Path.cwd()
    output_dir.mkdir(parents=True, exist_ok=True)
    base_name = target.stem

    saved_files: list[Path] = []
    chosen_formats = formats or ["png", "pdf"]

    for fmt in chosen_formats:
        output_file = output_dir / f"{base_name}.{fmt}"
        save_kwargs = {
            "dpi": dpi if fmt not in {"pdf", "svg"} else min(dpi, 300),
            "bbox_inches": bbox_inches,
            "pad_inches": pad_inches,
            "transparent": transparent,
            "facecolor": "none" if transparent else facecolor,
            "edgecolor": "none",
            "format": fmt,
        }
        save_kwargs.update(kwargs)
        fig.savefig(output_file, **save_kwargs)
        saved_files.append(output_file)

    return saved_files


def save_for_journal(
    fig: plt.Figure,
    filename: PathLike,
    journal: str,
    figure_type: str = "combination",
) -> list[Path]:
    journal_key = journal.lower()
    if journal_key not in JOURNAL_EXPORTS:
        available = ", ".join(sorted(JOURNAL_EXPORTS))
        raise ValueError(f"Unknown journal '{journal}'. Available: {available}")

    specs = JOURNAL_EXPORTS[journal_key]
    if figure_type not in specs:
        available = ", ".join(sorted(specs))
        raise ValueError(
            f"Unknown figure type '{figure_type}'. Available: {available}"
        )

    config = specs[figure_type]
    return save_publication_figure(
        fig=fig,
        filename=filename,
        formats=config["formats"],
        dpi=config["dpi"],
    )


def check_figure_size(fig: plt.Figure, journal: str = "nature") -> dict[str, object]:
    journal_key = journal.lower()
    if journal_key not in JOURNAL_WIDTHS_MM:
        available = ", ".join(sorted(JOURNAL_WIDTHS_MM))
        raise ValueError(f"Unknown journal '{journal}'. Available: {available}")

    width_in, height_in = fig.get_size_inches()
    width_mm = width_in * MM_PER_INCH
    height_mm = height_in * MM_PER_INCH
    spec = JOURNAL_WIDTHS_MM[journal_key]

    column_type = None
    tolerance_mm = 5.0
    if abs(width_mm - spec["single"]) <= tolerance_mm:
        column_type = "single"
    elif abs(width_mm - spec["double"]) <= tolerance_mm:
        column_type = "double"

    return {
        "journal": journal_key,
        "width_inches": width_in,
        "height_inches": height_in,
        "width_mm": width_mm,
        "height_mm": height_mm,
        "column_type": column_type,
        "width_ok": column_type is not None,
        "height_ok": height_mm <= spec["max_height"],
        "compliant": column_type is not None and height_mm <= spec["max_height"],
        "recommendations": spec,
    }
