"""Colorblind-safe palettes for experiment figures."""

OKABE_ITO = {
    "orange": "#E69F00",
    "sky_blue": "#56B4E9",
    "bluish_green": "#009E73",
    "yellow": "#F0E442",
    "blue": "#0072B2",
    "vermillion": "#D55E00",
    "reddish_purple": "#CC79A7",
    "black": "#000000",
}

OKABE_ITO_LIST = [
    "#E69F00",
    "#56B4E9",
    "#009E73",
    "#F0E442",
    "#0072B2",
    "#D55E00",
    "#CC79A7",
    "#000000",
]

TOL_BRIGHT = [
    "#4477AA",
    "#EE6677",
    "#228833",
    "#CCBB44",
    "#66CCEE",
    "#AA3377",
    "#BBBBBB",
]

TOL_MUTED = [
    "#332288",
    "#88CCEE",
    "#44AA99",
    "#117733",
    "#999933",
    "#DDCC77",
    "#CC6677",
    "#882255",
    "#AA4499",
]

SEQUENTIAL_COLORMAPS = ["viridis", "plasma", "inferno", "magma", "cividis"]

DIVERGING_COLORMAPS_SAFE = ["RdBu", "RdYlBu", "PuOr", "BrBG"]


def get_palette(palette_name: str = "okabe_ito") -> list[str]:
    palettes = {
        "okabe_ito": OKABE_ITO_LIST,
        "tol_bright": TOL_BRIGHT,
        "tol_muted": TOL_MUTED,
    }
    if palette_name not in palettes:
        available = ", ".join(sorted(palettes))
        raise ValueError(f"Unknown palette '{palette_name}'. Available: {available}")
    return palettes[palette_name]
