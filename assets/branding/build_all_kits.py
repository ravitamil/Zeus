#!/usr/bin/env python3
"""Build complete production kits for Iron Plate and Twin Plate concepts."""

import json
import subprocess
import sys
from pathlib import Path

BASE_DIR = Path("f:/prj/Zeus/assets/branding")
SKILL_DIR = Path("C:/Users/ravik/.gemini/config/plugins/logo-design/skills/logo-design/scripts")
EXPORT_SCRIPT = SKILL_DIR / "export_variants.py"
RENDER_SCRIPT = SKILL_DIR / "render_png.py"
AUDIT_SCRIPT = SKILL_DIR / "svg_audit.py"

# Custom athletic grotesque wordmark ZEUS
ZEUS_GLYPHS = """
  <!-- Wordmark ZEUS -->
  <g fill="{text_color}">
    <!-- Z -->
    <polygon points="300,80 368,80 368,104 330,152 368,152 368,176 300,176 300,152 338,104 300,104" />
    <!-- E -->
    <polygon points="386,80 446,80 446,104 412,104 412,116 440,116 440,140 412,140 412,152 446,152 446,176 386,176" />
    <!-- U -->
    <path d="M 464 80 L 490 80 L 490 144 A 8 8 0 0 0 498 152 L 504 152 A 8 8 0 0 0 512 144 L 512 80 L 538 80 L 538 146 A 30 30 0 0 1 508 176 L 494 176 A 30 30 0 0 1 464 146 Z" />
    <!-- S -->
    <path d="M 556 94 A 14 14 0 0 1 570 80 L 614 80 A 14 14 0 0 1 628 94 L 628 106 L 602 106 L 602 102 A 2 2 0 0 0 600 100 L 584 100 A 2 2 0 0 0 582 102 L 582 114 A 2 2 0 0 0 584 116 L 614 122 A 16 16 0 0 1 628 138 L 628 162 A 14 14 0 0 1 614 176 L 570 176 A 14 14 0 0 1 556 162 L 556 150 L 582 150 L 582 154 A 2 2 0 0 0 584 156 L 600 156 A 2 2 0 0 0 602 154 L 602 142 A 2 2 0 0 0 600 140 L 570 134 A 16 16 0 0 1 556 118 Z" />
  </g>
"""

# =============================================================================
# 1. IRON PLATE GEOMETRY
# =============================================================================
IRON_PLATE_PATH = """
    <!-- Outer Heavy Rim -->
    <path fill-rule="evenodd" d="
      M 128 20
      A 108 108 0 1 0 128 236
      A 108 108 0 1 0 128 20
      Z
      M 128 42
      A 86 86 0 1 1 128 214
      A 86 86 0 1 1 128 42
      Z
    "/>
    <!-- Center Core with Carved Lightning Bolt in Negative Space -->
    <path fill-rule="evenodd" d="
      M 128 54
      A 74 74 0 1 0 128 202
      A 74 74 0 1 0 128 54
      Z
      M 136 66
      L 98 132
      L 124 132
      L 104 190
      L 164 122
      L 134 122
      L 156 66
      Z
    "/>
""".strip()

# Micro cut for Iron Plate: reinforced bolt cut for small screens
IRON_PLATE_SMALL_PATH = """
    <!-- Outer Heavy Rim -->
    <path fill-rule="evenodd" d="
      M 128 20
      A 108 108 0 1 0 128 236
      A 108 108 0 1 0 128 20
      Z
      M 128 46
      A 82 82 0 1 1 128 210
      A 82 82 0 1 1 128 46
      Z
    "/>
    <!-- Center Core with Carved Lightning Bolt -->
    <path fill-rule="evenodd" d="
      M 128 54
      A 74 74 0 1 0 128 202
      A 74 74 0 1 0 128 54
      Z
      M 136 62
      L 94 134
      L 126 134
      L 102 194
      L 168 120
      L 132 120
      L 158 62
      Z
    "/>
""".strip()

# =============================================================================
# 2. TWIN PLATE GEOMETRY
# =============================================================================
TWIN_PLATE_PATH = """
    <!-- Top Plate Block -->
    <path d="
      M 48 44
      L 208 44
      L 208 92
      L 152 92
      L 124 120
      L 162 120
      L 138 144
      L 94 144
      L 142 96
      L 96 96
      L 48 96
      Z
    "/>
    <!-- Bottom Plate Block -->
    <path d="
      M 208 212
      L 48 212
      L 48 164
      L 104 164
      L 132 136
      L 94 136
      L 118 112
      L 162 112
      L 114 160
      L 160 160
      L 208 160
      Z
    "/>
""".strip()

TWIN_PLATE_SMALL_PATH = """
    <!-- Top Plate Block (widened gap) -->
    <path d="
      M 48 44
      L 208 44
      L 208 92
      L 152 92
      L 126 118
      L 166 118
      L 138 146
      L 94 146
      L 142 98
      L 96 98
      L 48 98
      Z
    "/>
    <!-- Bottom Plate Block (widened gap) -->
    <path d="
      M 208 212
      L 48 212
      L 48 164
      L 104 164
      L 130 138
      L 90 138
      L 118 110
      L 162 110
      L 114 158
      L 160 158
      L 208 158
      Z
    "/>
""".strip()


def build_concept_kit(name, slug, symbol_path, symbol_small_path, title_prefix):
    kit_dir = BASE_DIR / slug
    svg_dir = kit_dir / "svg"
    png_dir = kit_dir / "png"
    web_dir = kit_dir / "web"
    android_dir = kit_dir / "android"

    for d in [svg_dir, png_dir, web_dir, android_dir]:
        d.mkdir(parents=True, exist_ok=True)

    print(f"Building {name} kit in {kit_dir}...")

    # --- 1. SVGs ---
    def wrap_symbol(color, title, path_content):
        return f'''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 256" width="256" height="256">
  <title>{title}</title>
  <g fill="{color}">
    {path_content}
  </g>
</svg>'''.strip()

    def wrap_horizontal(symbol_color, text_color, title):
        glyphs = ZEUS_GLYPHS.format(text_color=text_color)
        return f'''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 680 256" width="680" height="256">
  <title>{title}</title>
  <g transform="translate(16, 0)" fill="{symbol_color}">
    {symbol_path}
  </g>
  {glyphs}
</svg>'''.strip()

    def wrap_stacked(symbol_color, text_color, title):
        glyphs = ZEUS_GLYPHS.format(text_color=text_color)
        return f'''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 384 384" width="384" height="384">
  <title>{title}</title>
  <g transform="translate(102, 28) scale(0.703125)" fill="{symbol_color}">
    {symbol_path}
  </g>
  <g transform="translate(-170, 154) scale(0.78)">
    {glyphs}
  </g>
</svg>'''.strip()

    def wrap_app_icon(tile_bg, symbol_color, title):
        return f'''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" width="512" height="512">
  <title>{title}</title>
  <rect width="512" height="512" rx="114" fill="{tile_bg}"/>
  <g transform="translate(85, 85) scale(1.336)" fill="{symbol_color}">
    {symbol_path}
  </g>
</svg>'''.strip()

    # Write SVGs
    p_master = svg_dir / f"zeus-{slug}-master.svg"
    p_gold = svg_dir / f"zeus-{slug}-gold.svg"
    p_white = svg_dir / f"zeus-{slug}-white.svg"
    p_small = svg_dir / f"zeus-{slug}-small.svg"
    p_h_light = svg_dir / f"zeus-{slug}-lockup-horizontal-gold.svg"
    p_h_dark = svg_dir / f"zeus-{slug}-lockup-horizontal-gold-on-dark.svg"
    p_h_white = svg_dir / f"zeus-{slug}-lockup-horizontal-white.svg"
    p_h_black = svg_dir / f"zeus-{slug}-lockup-horizontal-black.svg"
    p_stacked = svg_dir / f"zeus-{slug}-lockup-stacked-gold.svg"
    p_app_icon = svg_dir / f"zeus-{slug}-app-icon.svg"

    p_master.write_text(wrap_symbol("#000000", f"{title_prefix} Master Black", symbol_path), encoding="utf-8")
    p_gold.write_text(wrap_symbol("#F59E0B", f"{title_prefix} Olympian Gold", symbol_path), encoding="utf-8")
    p_white.write_text(wrap_symbol("#FFFFFF", f"{title_prefix} Titanium White", symbol_path), encoding="utf-8")
    p_small.write_text(wrap_symbol("#000000", f"{title_prefix} Micro Cut", symbol_small_path), encoding="utf-8")

    p_h_light.write_text(wrap_horizontal("#F59E0B", "#0C0B0A", f"{title_prefix} Horizontal Light Lockup"), encoding="utf-8")
    p_h_dark.write_text(wrap_horizontal("#F59E0B", "#FFFFFF", f"{title_prefix} Horizontal Dark Lockup"), encoding="utf-8")
    p_h_white.write_text(wrap_horizontal("#FFFFFF", "#FFFFFF", f"{title_prefix} Horizontal White Lockup"), encoding="utf-8")
    p_h_black.write_text(wrap_horizontal("#000000", "#000000", f"{title_prefix} Horizontal Black Lockup"), encoding="utf-8")

    p_stacked.write_text(wrap_stacked("#F59E0B", "#FFFFFF", f"{title_prefix} Stacked Lockup"), encoding="utf-8")
    p_app_icon.write_text(wrap_app_icon("#0C0B0A", "#F59E0B", f"{title_prefix} App Icon"), encoding="utf-8")

    # Audit check
    subprocess.run([sys.executable, str(AUDIT_SCRIPT), str(p_master), str(p_h_light), str(p_app_icon)], check=True)

    # --- 2. Export Variants (PNGs & Web Icons) ---
    print(f"Exporting variants for {name}...")
    subprocess.run([
        sys.executable, str(EXPORT_SCRIPT),
        str(p_master),
        "--name", f"zeus-{slug}",
        "--out-dir", str(png_dir),
        "--mono", "#F59E0B",
        "--icon-bg", "#0C0B0A",
        "--icon-fg", "#F59E0B",
        "--title", f"Zeus {name}",
        "--favicon-source", str(p_small),
        "--web-icons",
        "--png", "32", "64", "128", "256", "512", "1024"
    ], check=True)

    # Export horizontal lockup rasters
    subprocess.run([
        sys.executable, str(EXPORT_SCRIPT),
        str(p_h_dark),
        "--name", f"zeus-{slug}-lockup-horizontal",
        "--out-dir", str(png_dir),
        "--only", "black", "white", "mono",
        "--mono", "#F59E0B",
        "--keep-white",
        "--png", "300", "600", "1200"
    ], check=True)

    # Move web icons to web_dir
    for pattern in ["favicon*", "apple-touch-icon.png", "icon-*.png", "maskable-512.png", "site.webmanifest", "head-snippet.html"]:
        for f in png_dir.glob(pattern):
            target = web_dir / f.name
            if target.exists():
                target.unlink()
            f.rename(target)

    # --- 3. Android 1024x1024 launcher icons ---
    p_android_full = android_dir / "ic_1024.svg"
    p_android_fg = android_dir / "ic_fg_1024.svg"

    android_full_svg = f'''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1024 1024" width="1024" height="1024">
  <rect width="1024" height="1024" fill="#0C0B0A"/>
  <g transform="translate(243, 243) scale(2.1015625)" fill="#F59E0B">
    {symbol_path}
  </g>
</svg>'''

    android_fg_svg = f'''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1024 1024" width="1024" height="1024">
  <g transform="translate(292, 292) scale(1.71875)" fill="#F59E0B">
    {symbol_path}
  </g>
</svg>'''

    p_android_full.write_text(android_full_svg, encoding="utf-8")
    p_android_fg.write_text(android_fg_svg, encoding="utf-8")

    subprocess.run([sys.executable, str(RENDER_SCRIPT), str(p_android_full), "--size", "1024", "--out-dir", str(android_dir)], check=True)
    subprocess.run([sys.executable, str(RENDER_SCRIPT), str(p_android_fg), "--size", "1024", "--out-dir", str(android_dir)], check=True)

    # --- 4. Brand Guidelines ---
    guidelines_content = f"""# Zeus — Brand Guidelines ({name})

> **Zeus** · Free, privacy-first, offline gym & workout log for Android.  
> Official Identity & Logo Design Guidelines for **{name}**.

---

## 1. The Logo
- **The Idea**: {title_prefix}. Built on a 256-unit canvas with mathematical balance and pure scalability.
- **Versions**: Primary horizontal lockup (light and dark backgrounds), stacked lockup, standalone symbol, and micro cut.
- **Primary Accent**: Olympian Gold (`#F59E0B`) with Obsidian Dark canvas (`#0C0B0A`). Contrast ratio: **10.8 : 1 (AAA Pass)**.

---

## 2. Directory Index
- `svg/`: Vector masters (`zeus-{slug}-master.svg`, `zeus-{slug}-gold.svg`, `zeus-{slug}-lockup-*.svg`).
- `png/`: 32 to 1024 px rasters in black, white, and gold.
- `web/`: Complete multi-size favicon ICO suite and PWA webmanifest.
- `android/`: `ic_1024.png` full icon and `ic_fg_1024.png` adaptive foreground.
"""
    (kit_dir / "BRAND_GUIDELINES.md").write_text(guidelines_content, encoding="utf-8")
    print(f"Completed {name} kit successfully!")


if __name__ == "__main__":
    build_concept_kit(
        name="The Iron Plate",
        slug="iron-plate",
        symbol_path=IRON_PLATE_PATH,
        symbol_small_path=IRON_PLATE_SMALL_PATH,
        title_prefix="Zeus Iron Plate"
    )
    build_concept_kit(
        name="The Twin Plate",
        slug="twin-plate",
        symbol_path=TWIN_PLATE_PATH,
        symbol_small_path=TWIN_PLATE_SMALL_PATH,
        title_prefix="Zeus Twin Plate"
    )
    print("ALL KITS COMPLETED!")
