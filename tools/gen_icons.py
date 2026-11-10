"""Regenerate every app-icon asset from a single square master image.

Usage:
    python tools/gen_icons.py [source_image]

The script:
  1. Normalises the source into a square, opaque 1024x1024 master.
  2. Writes apps/mobile/assets/images/logo.png (+ logo_master.png).
  3. Writes Android legacy mipmaps (ic_launcher.png / ic_launcher_round.png)
     and the adaptive-icon background bitmaps (108dp, 5 densities).
  4. Writes the transparent adaptive-icon foreground vector.
  5. Writes the whole iOS AppIcon.appiconset.
  6. Writes store_assets/icon_512.png.
"""

from __future__ import annotations

import os
import sys

from PIL import Image, ImageDraw

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MOBILE = os.path.join(ROOT, "apps", "mobile")
RES = os.path.join(MOBILE, "android", "app", "src", "main", "res")
IOS_SET = os.path.join(
    MOBILE, "ios", "Runner", "Assets.xcassets", "AppIcon.appiconset"
)
STORE = os.path.join(ROOT, "store_assets")

DEFAULT_SOURCE = os.path.join(
    os.path.expanduser("~"),
    ".gemini",
    "antigravity",
    "brain",
    "54684a80-deec-4751-9a49-cae98d0b6b39",
    ".user_uploaded",
    "media_1793982480542_0cbbf20e.jpg",
)

# Android legacy launcher icon sizes (px) per density bucket.
LEGACY = {
    "mdpi": 48,
    "hdpi": 72,
    "xhdpi": 96,
    "xxhdpi": 144,
    "xxxhdpi": 192,
}

# Adaptive-icon layer sizes: 108dp * density scale.
ADAPTIVE = {
    "mdpi": 108,
    "hdpi": 162,
    "xhdpi": 216,
    "xxhdpi": 324,
    "xxxhdpi": 432,
}

IOS_ICONS = [
    ("Icon-App-20x20@1x.png", 20),
    ("Icon-App-20x20@2x.png", 40),
    ("Icon-App-20x20@3x.png", 60),
    ("Icon-App-29x29@1x.png", 29),
    ("Icon-App-29x29@2x.png", 58),
    ("Icon-App-29x29@3x.png", 87),
    ("Icon-App-40x40@1x.png", 40),
    ("Icon-App-40x40@2x.png", 80),
    ("Icon-App-40x40@3x.png", 120),
    ("Icon-App-60x60@2x.png", 120),
    ("Icon-App-60x60@3x.png", 180),
    ("Icon-App-76x76@1x.png", 76),
    ("Icon-App-76x76@2x.png", 152),
    ("Icon-App-83.5x83.5@2x.png", 167),
    ("Icon-App-1024x1024@1x.png", 1024),
]

ADAPTIVE_XML = """<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@drawable/ic_launcher_background" />
    <foreground android:drawable="@drawable/ic_launcher_foreground" />
</adaptive-icon>
"""

# The brand artwork lives entirely in the background layer
# (@drawable/ic_launcher_background), so the foreground layer is a fully
# transparent bitmap. A transparent *bitmap* is used instead of an empty
# <vector> because AAPT2 drops an all-transparent vector path and then fails
# resource linking with "drawable/ic_launcher_foreground not found".
FOREGROUND_ALPHA = 0


def load_master(source: str) -> Image.Image:
    im = Image.open(source).convert("RGB")
    w, h = im.size
    side = min(w, h)
    left = (w - side) // 2
    top = (h - side) // 2
    im = im.crop((left, top, left + side, top + side))
    if side != 1024:
        im = im.resize((1024, 1024), Image.LANCZOS)
    return im


def circle_mask(size: int) -> Image.Image:
    mask = Image.new("L", (size, size), 0)
    ImageDraw.Draw(mask).ellipse((0, 0, size - 1, size - 1), fill=255)
    return mask


def save(im: Image.Image, path: str) -> None:
    os.makedirs(os.path.dirname(path), exist_ok=True)
    im.save(path, format="PNG", optimize=True)
    print(f"  wrote {os.path.relpath(path, ROOT)} ({os.path.getsize(path):,} B)")


def write_text(path: str, text: str) -> None:
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w", encoding="utf-8", newline="\n") as fh:
        fh.write(text)
    print(f"  wrote {os.path.relpath(path, ROOT)}")


def main() -> int:
    source = DEFAULT_SOURCE
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    if args:
        source = args[0]
    if not os.path.isfile(source):
        print(f"source image not found: {source}")
        return 1

    print(f"master <- {source}")
    master = load_master(source)

    # ---- in-app Flutter asset -------------------------------------------
    print("Flutter assets:")
    save(master, os.path.join(MOBILE, "assets", "images", "logo_master.png"))
    save(
        master.resize((512, 512), Image.LANCZOS),
        os.path.join(MOBILE, "assets", "images", "logo.png"),
    )

    # ---- store icon ------------------------------------------------------
    # Google Play requires exactly 512x512 px, 32-bit PNG, <= 1024 KB.
    print("Store assets:")
    save(
        master.resize((512, 512), Image.LANCZOS).convert("RGBA"),
        os.path.join(STORE, "icon_512.png"),
    )

    # ---- Android legacy mipmaps -----------------------------------------
    print("Android legacy mipmaps:")
    for bucket, size in LEGACY.items():
        square = master.resize((size, size), Image.LANCZOS)
        save(square, os.path.join(RES, f"mipmap-{bucket}", "ic_launcher.png"))
        rounded = square.copy()
        rounded.putalpha(circle_mask(size))
        save(
            rounded,
            os.path.join(RES, f"mipmap-{bucket}", "ic_launcher_round.png"),
        )

    # ---- Android adaptive icon ------------------------------------------
    print("Android adaptive icon:")
    # Adaptive icons: background = full-bleed artwork, foreground = transparent
    # bitmap layer (launcher applies its own mask / parallax).
    for bucket, size in ADAPTIVE.items():
        save(
            master.resize((size, size), Image.LANCZOS),
            os.path.join(RES, f"drawable-{bucket}", "ic_launcher_background.png"),
        )
        save(
            Image.new("RGBA", (size, size), (0, 0, 0, FOREGROUND_ALPHA)),
            os.path.join(RES, f"drawable-{bucket}", "ic_launcher_foreground.png"),
        )
    # Drop any legacy vector foreground left over from earlier icon designs.
    for stale in (
        os.path.join(RES, "drawable", "ic_launcher_foreground.xml"),
        os.path.join(RES, "drawable-v24", "ic_launcher_foreground.xml"),
    ):
        if os.path.isfile(stale):
            os.remove(stale)
            print(f"  removed {os.path.relpath(stale, ROOT)}")
    for name in ("ic_launcher.xml", "ic_launcher_round.xml"):
        write_text(
            os.path.join(RES, "mipmap-anydpi-v26", name),
            ADAPTIVE_XML,
        )

    # ---- iOS AppIcon set -------------------------------------------------
    print("iOS AppIcon set:")
    for name, size in IOS_ICONS:
        save(master.resize((size, size), Image.LANCZOS),
             os.path.join(IOS_SET, name))

    print("done")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())