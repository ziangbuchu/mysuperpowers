#!/usr/bin/env python3
"""Style helpers for experiment-result figures."""

from __future__ import annotations

from typing import Any

import matplotlib as mpl
import matplotlib.pyplot as plt

MM_PER_INCH = 25.4

OKABE_ITO_COLORS = [
    "#E69F00",
    "#56B4E9",
    "#009E73",
    "#F0E442",
    "#0072B2",
    "#D55E00",
    "#CC79A7",
    "#000000",
]

PALETTES = {
    "okabe_ito": OKABE_ITO_COLORS,
    "tol_bright": [
        "#4477AA",
        "#EE6677",
        "#228833",
        "#CCBB44",
        "#66CCEE",
        "#AA3377",
        "#BBBBBB",
    ],
    "tol_muted": [
        "#332288",
        "#88CCEE",
        "#44AA99",
        "#117733",
        "#999933",
        "#DDCC77",
        "#CC6677",
        "#882255",
        "#AA4499",
    ],
}

JOURNAL_WIDTHS_MM = {
    "nature": {"single": 89.0, "double": 183.0},
    "science": {"single": 55.0, "double": 175.0},
    "cell": {"single": 85.0, "double": 178.0},
    "plos": {"single": 83.0, "double": 173.0},
}


def mm_to_inches(value_mm: float) -> float:
    return value_mm / MM_PER_INCH


def get_base_style() -> dict[str, Any]:
    return {
        "figure.dpi": 100,
        "figure.facecolor": "white",
        "figure.constrained_layout.use": True,
        "font.family": "sans-serif",
        "font.sans-serif": ["Arial", "Helvetica", "DejaVu Sans"],
        "font.size": 8,
        "axes.labelsize": 9,
        "axes.titlesize": 9,
        "axes.linewidth": 0.6,
        "axes.spines.top": False,
        "axes.spines.right": False,
        "axes.prop_cycle": mpl.cycler(color=OKABE_ITO_COLORS),
        "axes.grid": False,
        "xtick.labelsize": 7,
        "ytick.labelsize": 7,
        "xtick.major.size": 3,
        "ytick.major.size": 3,
        "xtick.major.width": 0.6,
        "ytick.major.width": 0.6,
        "xtick.direction": "out",
        "ytick.direction": "out",
        "lines.linewidth": 1.6,
        "lines.markersize": 4,
        "legend.fontsize": 7,
        "legend.frameon": False,
        "savefig.dpi": 300,
        "savefig.format": "pdf",
        "savefig.bbox": "tight",
        "savefig.pad_inches": 0.05,
        "image.cmap": "viridis",
    }


def apply_publication_style(style_name: str = "default") -> None:
    style = get_base_style()

    if style_name == "nature":
        style.update(
            {
                "font.size": 7,
                "axes.labelsize": 8,
                "xtick.labelsize": 6,
                "ytick.labelsize": 6,
                "legend.fontsize": 6,
                "savefig.dpi": 600,
            }
        )
    elif style_name == "presentation":
        style.update(
            {
                "font.size": 12,
                "axes.labelsize": 13,
                "axes.titlesize": 14,
                "xtick.labelsize": 11,
                "ytick.labelsize": 11,
                "legend.fontsize": 11,
                "lines.linewidth": 2.4,
                "lines.markersize": 7,
            }
        )
    elif style_name == "minimal":
        style.update({"axes.linewidth": 0.8, "lines.linewidth": 1.8})
    elif style_name not in {"default", "science", "cell", "plos"}:
        raise ValueError(f"Unknown style: {style_name}")

    plt.rcParams.update(style)


def set_color_palette(palette_name: str = "okabe_ito") -> list[str]:
    if palette_name not in PALETTES:
        available = ", ".join(sorted(PALETTES))
        raise ValueError(f"Unknown palette '{palette_name}'. Available: {available}")

    colors = PALETTES[palette_name]
    plt.rcParams["axes.prop_cycle"] = plt.cycler(color=colors)
    return colors


def get_figure_size(
    journal: str = "nature",
    figure_width: str = "single",
    aspect: float = 0.72,
) -> tuple[float, float]:
    journal_key = journal.lower()
    if journal_key not in JOURNAL_WIDTHS_MM:
        available = ", ".join(sorted(JOURNAL_WIDTHS_MM))
        raise ValueError(f"Unknown journal '{journal}'. Available: {available}")

    widths = JOURNAL_WIDTHS_MM[journal_key]
    if figure_width not in widths:
        available = ", ".join(sorted(widths))
        raise ValueError(
            f"Unknown figure width '{figure_width}'. Available: {available}"
        )

    width_in = mm_to_inches(widths[figure_width])
    height_in = width_in * aspect
    return (width_in, height_in)


def configure_for_journal(
    journal: str = "nature",
    figure_width: str = "single",
    aspect: float = 0.72,
) -> tuple[float, float]:
    apply_publication_style(journal.lower())
    return get_figure_size(journal=journal, figure_width=figure_width, aspect=aspect)
