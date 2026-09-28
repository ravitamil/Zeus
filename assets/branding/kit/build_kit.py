#!/usr/bin/env python3
"""Build the complete production logo kit for Zeus."""

import json
import subprocess
import sys
from pathlib import Path

KIT_DIR = Path("f:/prj/Zeus/assets/branding/kit")
SVG_DIR = KIT_DIR / "svg"
PNG_DIR = KIT_DIR / "png"
WEB_DIR = KIT_DIR / "web"
PRES_DIR = KIT_DIR / "presentation"
ANDROID_DIR = KIT_DIR / "android"

for d in [SVG_DIR, PNG_DIR, WEB_DIR, PRES_DIR, ANDROID_DIR]:
    d.mkdir(parents=True, exist_ok=True)

SKILL_SCRIPTS = Path("C:/Users/ravik/.gemini/config/plugins/logo-design/skills/logo-design/scripts")

# -----------------------------------------------------------------------------
# 1. Master Geometric Vectors
# -----------------------------------------------------------------------------

# Kinetic Bolt Symbol (Master Black, 256x256)
SYMBOL_PATH = """
    M 60 44
    L 212 44
    L 212 84
    L 168 128
    L 192 128
    L 148 172
    L 212 172
    L 212 196
    L 196 212
    L 44 212
    L 44 172
    L 88 128
    L 64 128
    L 108 84
    L 44 84
    L 44 60
    Z
""".strip()

# Small-size cut (16-32px): slightly boosted waist for extreme micro-clarity
SYMBOL_SMALL_PATH = """
    M 56 44
    L 212 44
    L 212 86
    L 164 128
    L 194 128
    L 146 170
    L 212 170
    L 212 196
    L 196 212
    L 44 212
    L 44 170
    L 92 128
    L 62 128
    L 110 86
    L 44 86
    L 44 56
    Z
""".strip()

def create_symbol_svg(fill_color="#000000", title="Zeus Logo Symbol", path=SYMBOL_PATH):
    return f'''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 256" width="256" height="256">
  <title>{title}</title>
  <path fill="{fill_color}" fill-rule="evenodd" d="{path}"/>
</svg>'''.strip()

def create_horizontal_lockup(symbol_color="#F59E0B", text_color="#FFFFFF", bg_color=None):
    bg_rect = f'<rect width="680" height="256" fill="{bg_color}"/>' if bg_color else ''
    return f'''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 680 256" width="680" height="256">
  <title>Zeus Horizontal Lockup</title>
  {bg_rect}
  <!-- Symbol on Left -->
  <g transform="translate(16, 0)">
    <path fill="{symbol_color}" fill-rule="evenodd" d="{SYMBOL_PATH}"/>
  </g>
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
</svg>'''.strip()

def create_stacked_lockup(symbol_color="#F59E0B", text_color="#FFFFFF", bg_color=None):
    bg_rect = f'<rect width="384" height="384" fill="{bg_color}"/>' if bg_color else ''
    # Scale symbol down to 180x180, centered at x=102, y=28
    return f'''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 384 384" width="384" height="384">
  <title>Zeus Stacked Lockup</title>
  {bg_rect}
  <!-- Centered Symbol (scale 0.703) -->
  <g transform="translate(102, 28) scale(0.703125)">
    <path fill="{symbol_color}" fill-rule="evenodd" d="{SYMBOL_PATH}"/>
  </g>
  <!-- Wordmark ZEUS centered at bottom (width ~328, scaled to 0.78, offset x=64, y=254) -->
  <g transform="translate(-170, 154) scale(0.78)" fill="{text_color}">
    <!-- Z -->
    <polygon points="300,80 368,80 368,104 330,152 368,152 368,176 300,176 300,152 338,104 300,104" />
    <!-- E -->
    <polygon points="386,80 446,80 446,104 412,104 412,116 440,116 440,140 412,140 412,152 446,152 446,176 386,176" />
    <!-- U -->
    <path d="M 464 80 L 490 80 L 490 144 A 8 8 0 0 0 498 152 L 504 152 A 8 8 0 0 0 512 144 L 512 80 L 538 80 L 538 146 A 30 30 0 0 1 508 176 L 494 176 A 30 30 0 0 1 464 146 Z" />
    <!-- S -->
    <path d="M 556 94 A 14 14 0 0 1 570 80 L 614 80 A 14 14 0 0 1 628 94 L 628 106 L 602 106 L 602 102 A 2 2 0 0 0 600 100 L 584 100 A 2 2 0 0 0 582 102 L 582 114 A 2 2 0 0 0 584 116 L 614 122 A 16 16 0 0 1 628 138 L 628 162 A 14 14 0 0 1 614 176 L 570 176 A 14 14 0 0 1 556 162 L 556 150 L 582 150 L 582 154 A 2 2 0 0 0 584 156 L 600 156 A 2 2 0 0 0 602 154 L 602 142 A 2 2 0 0 0 600 140 L 570 134 A 16 16 0 0 1 556 118 Z" />
  </g>
</svg>'''.strip()

def create_app_icon_svg(tile_bg="#0C0B0A", symbol_color="#F59E0B"):
    return f'''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" width="512" height="512">
  <title>Zeus App Icon</title>
  <!-- Background Squircle -->
  <rect width="512" height="512" rx="114" fill="{tile_bg}"/>
  <!-- Centered Symbol (scale 1.34) -->
  <g transform="translate(85, 85) scale(1.336)">
    <path fill="{symbol_color}" fill-rule="evenodd" d="{SYMBOL_PATH}"/>
  </g>
</svg>'''.strip()

# Write SVGs
(SVG_DIR / "zeus-symbol-master.svg").write_text(create_symbol_svg("#000000", "Zeus Master Black Symbol"), encoding="utf-8")
(SVG_DIR / "zeus-symbol-gold.svg").write_text(create_symbol_svg("#F59E0B", "Zeus Gold Symbol"), encoding="utf-8")
(SVG_DIR / "zeus-symbol-white.svg").write_text(create_symbol_svg("#FFFFFF", "Zeus White Symbol"), encoding="utf-8")
(SVG_DIR / "zeus-symbol-small.svg").write_text(create_symbol_svg("#000000", "Zeus Micro Cut Symbol", SYMBOL_SMALL_PATH), encoding="utf-8")

(SVG_DIR / "zeus-lockup-horizontal-gold.svg").write_text(create_horizontal_lockup("#F59E0B", "#0C0B0A"), encoding="utf-8")
(SVG_DIR / "zeus-lockup-horizontal-gold-on-dark.svg").write_text(create_horizontal_lockup("#F59E0B", "#FFFFFF"), encoding="utf-8")
(SVG_DIR / "zeus-lockup-horizontal-white.svg").write_text(create_horizontal_lockup("#FFFFFF", "#FFFFFF"), encoding="utf-8")
(SVG_DIR / "zeus-lockup-horizontal-black.svg").write_text(create_horizontal_lockup("#000000", "#000000"), encoding="utf-8")

(SVG_DIR / "zeus-lockup-stacked-gold.svg").write_text(create_stacked_lockup("#F59E0B", "#FFFFFF"), encoding="utf-8")
(SVG_DIR / "zeus-lockup-stacked-white.svg").write_text(create_stacked_lockup("#FFFFFF", "#FFFFFF"), encoding="utf-8")
(SVG_DIR / "zeus-lockup-stacked-black.svg").write_text(create_stacked_lockup("#000000", "#000000"), encoding="utf-8")

(SVG_DIR / "zeus-app-icon.svg").write_text(create_app_icon_svg("#0C0B0A", "#F59E0B"), encoding="utf-8")

print("Created all vector masters in", SVG_DIR)
