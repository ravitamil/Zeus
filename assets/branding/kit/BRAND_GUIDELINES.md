# Zeus — Brand & Logo Guidelines

> **Zeus** · Free, privacy-first, offline gym & workout log for Android.  
> Official Identity & Logo Design Guidelines.

---

## 1. The Logo

- **The Idea**: A heavy-gauge industrial "Z" letterform forged with an integrated lightning bolt kick. Combines the mythical power of Zeus with the raw, heavy-duty weight of an Olympic barbell plate. Built on a 256-unit canvas with exact $45^\circ$ snap angles and pure $180^\circ$ rotational symmetry.
- **Versions**:
  - **Primary Horizontal Lockup**: Symbol + custom athletic grotesque wordmark `ZEUS`.
  - **Stacked Lockup**: Centered symbol positioned over wordmark.
  - **Symbol Only**: Freestanding mark for Android app icons, favicons, home screen widgets, and apparel.
  - **Micro Cut**: Specialized geometry with boosted waist and widened gaps for micro resolutions (16–24 px).
- **Core Formats**:
  - `svg/`: Lossless vector masters for app source code, Android vector drawables, web, and high-resolution print.
  - `png/`: 32, 64, 128, 256, 512, 1024 px rasters in black, white, and Zeus Gold.
  - `android/`: 1024×1024 `ic_1024.png` full icon and `ic_fg_1024.png` adaptive foreground.
  - `web/`: Complete multi-size favicon suite and PWA webmanifest.

---

## 2. Clear Space

Always maintain a minimum protective clear space of **$1 \times H$** on all four sides of the mark, where **$H$** is the height of the symbol's horizontal bar (40 px on a 256 px grid, or $\approx 25\%$ of total symbol height).

```
   +---------------------------------------+
   |                  [H]                  |
   |      +-------------------------+      |
   |  [H] |    [ ZEUS SYMBOL ]      | [H]  |
   |      +-------------------------+      |
   |                  [H]                  |
   +---------------------------------------+
```

No typography, UI borders, status bar icons, or edges should intrude into this exclusion zone.

---

## 3. Minimum Sizes

| Context | Minimum Size | Rationale / Recommended Asset |
|---|---|---|
| **Android Launcher Icon** | `48 × 48 dp` | Use `android/ic_1024.png` or `ic_fg_1024.png` adaptive vector. |
| **Android Status Bar / Favicon** | `16 × 16 px` | Use `svg/zeus-symbol-small.svg` or `web/favicon-16.png`. |
| **Horizontal Lockup (Screen)** | `120 px wide` | Below 120 px, switch to the standalone Symbol. |
| **Stacked Lockup (Screen)** | `80 px wide` | Ensures the wordmark remains legible. |
| **Print (Merchandise / Apparel)** | `12 mm wide` | Preserves sharp edge definition in embroidery and screen print. |

---

## 4. Colour Palette

The palette is anchored by Olympian Gold and Obsidian Dark, reflecting high energy, PR adrenaline, and distraction-free dark gym environments.

| Swatch | Color Name | HEX | RGB | CMYK | Pantone | Contrast (White) | Contrast (Obsidian) |
|---|---|---|---|---|---|---|---|
| 🟡 | **Zeus Gold** *(Primary Accent)* | `#F59E0B` | `245, 158, 11` | `0, 42, 100, 4` | PMS 137 C | `1.9 : 1` (Use on dark) | **`10.8 : 1`** *(AAA Pass)* |
| 🪨 | **Obsidian Dark** *(App Canvas)* | `#0C0B0A` | `12, 11, 10` | `70, 65, 65, 88` | Black 6 C | **`19.8 : 1`** *(AAA Pass)* | `1.0 : 1` |
| ⚙️ | **Iron Slate** *(Secondary Surface)*| `#1F2937` | `31, 41, 55` | `75, 60, 45, 45` | PMS 432 C | **`12.4 : 1`** *(AAA Pass)* | `1.6 : 1` |
| ⚪ | **Titanium White** *(Text / Reverse)*| `#FFFFFF` | `255, 255, 255`| `0, 0, 0, 0` | White | `1.0 : 1` | **`19.8 : 1`** *(AAA Pass)* |

### Approved Color Pairings
- **Primary Screen UI**: Zeus Gold (`#F59E0B`) and Titanium White on Obsidian Dark (`#0C0B0A`).
- **One-Colour Monochrome**: Solid Black on light backgrounds; Solid White on dark surfaces.
- **Apparel / T-Shirts**: Zeus Gold on black combed cotton, or high-contrast White on dark charcoal.

---

## 5. Typography

- **Wordmark Letterforms**: Custom geometric athletic grotesque glyphs constructed as vectors (`Z`, `E`, `U`, `S`) with chamfered inner counters and bold stem weights.
- **In-App Display Type**: High-legibility modern sans-serif (e.g., Roboto / Inter / system sans) set in Medium or Bold for numerical weights, reps, and PR callouts.
- **Monospace Figures**: Tabular numbers for plate calculators, stopwatches, and set counters.

---

## 6. Incorrect Usage (Don'ts)

- **Do NOT** stretch, squish, or alter the $1:1$ square proportions of the symbol.
- **Do NOT** rotate the mark — the $45^\circ$ snap angles are mathematically calibrated for upright stability.
- **Do NOT** apply outer glow, diffuse dropshadows, or 3D bevel filters.
- **Do NOT** alter the spacing between the symbol and the wordmark in official lockups.
- **Do NOT** substitute generic system fonts for the vector wordmark letters.
- **Do NOT** place low-contrast gold on light gray or white surfaces without a dark container.

---

## 7. Master File Directory

```
assets/branding/kit/
├── BRAND_GUIDELINES.md                 # This document
├── android/                            # Android launcher assets
│   ├── ic_1024.png                     # Full launcher icon (1024x1024)
│   ├── ic_fg_1024.png                  # Adaptive foreground (1024x1024)
│   ├── ic_1024.svg                     # Source SVG
│   └── ic_fg_1024.svg                  # Source adaptive SVG
├── svg/                                # Production vector masters
│   ├── zeus-symbol-master.svg          # 100/100 Master black symbol
│   ├── zeus-symbol-gold.svg            # Olympian Gold symbol
│   ├── zeus-symbol-white.svg           # Titanium White symbol
│   ├── zeus-symbol-small.svg           # Micro 16-24px cut
│   ├── zeus-lockup-horizontal-gold.svg # Horizontal lockup (for light bg)
│   ├── zeus-lockup-horizontal-gold-on-dark.svg # Horizontal lockup (for dark bg)
│   ├── zeus-lockup-horizontal-white.svg# All-white horizontal lockup
│   ├── zeus-lockup-stacked-gold.svg    # Stacked lockup
│   ├── zeus-lockup-stacked-white.svg   # Stacked white lockup
│   └── zeus-app-icon.svg               # Squircle tile app icon
├── png/                                # Multi-resolution raster exports
│   ├── zeus-symbol-black-*.png         # Sizes: 32, 64, 128, 256, 512, 1024
│   ├── zeus-symbol-white-*.png         # Sizes: 32, 64, 128, 256, 512, 1024
│   ├── zeus-symbol-mono-f59e0b-*.png   # Sizes: 32, 64, 128, 256, 512, 1024
│   ├── zeus-symbol-app-icon-*.png      # Sizes: 32, 64, 128, 256, 512, 1024
│   └── zeus-lockup-horizontal-*.png    # Horizontal lockups: 300, 600, 1200
├── web/                                # Browser & PWA icons
│   ├── favicon.ico                     # Multi-layer ICO (16, 32, 48)
│   ├── favicon-16.png / -32.png / -48.png
│   ├── apple-touch-icon.png            # 180x180 iOS touch icon
│   ├── icon-192.png / icon-512.png     # Android web app icons
│   ├── maskable-512.png                # PWA maskable icon
│   ├── site.webmanifest                # Web manifest
│   └── head-snippet.html               # HTML <head> snippet
└── presentation/                       # Presentation & Mockup boards
    ├── presentation.html               # Interactive 10-slide deck
    ├── presentation-spec.json          # Presentation source spec
    └── slides/                         # Rendered PNG slides (1 to 10)
        ├── slide-01.png                # Title & brief
        ├── slide-03.png                # The Kinetic Bolt showcase
        ├── slide-04.png                # Industry Mockups (app, readme, t-shirt...)
        └── slide-09.png                # 3 Directions comparison
```
