#!/usr/bin/env python3
"""Generate 1024x1024 Android launcher icon and adaptive foreground icon."""

import subprocess
import sys
from pathlib import Path

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

full_svg = f"""<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1024 1024" width="1024" height="1024">
  <rect width="1024" height="1024" fill="#0C0B0A"/>
  <!-- Centered symbol (scale 3.2, 538px) -->
  <g transform="translate(243, 243) scale(2.1015625)">
    <path fill="#F59E0B" fill-rule="evenodd" d="{SYMBOL_PATH}"/>
  </g>
</svg>"""

fg_svg = f"""<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1024 1024" width="1024" height="1024">
  <!-- Centered symbol in Android adaptive safe zone (scale 2.62, 440px) -->
  <g transform="translate(292, 292) scale(1.71875)">
    <path fill="#F59E0B" fill-rule="evenodd" d="{SYMBOL_PATH}"/>
  </g>
</svg>"""

p_full = Path("f:/prj/Zeus/assets/branding/kit/android/ic_1024.svg")
p_fg = Path("f:/prj/Zeus/assets/branding/kit/android/ic_fg_1024.svg")
p_full.write_text(full_svg, encoding="utf-8")
p_fg.write_text(fg_svg, encoding="utf-8")

render_script = Path("C:/Users/ravik/.gemini/config/plugins/logo-design/skills/logo-design/scripts/render_png.py")
subprocess.run([sys.executable, str(render_script), str(p_full), "--size", "1024", "--out-dir", "f:/prj/Zeus/assets/branding/kit/android"], check=True)
subprocess.run([sys.executable, str(render_script), str(p_fg), "--size", "1024", "--out-dir", "f:/prj/Zeus/assets/branding/kit/android"], check=True)

print("Successfully generated Android launcher icons in kit/android")
