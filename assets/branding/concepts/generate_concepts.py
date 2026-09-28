#!/usr/bin/env python3
"""Generate the 3 concept SVG symbols and horizontal lockups for Zeus."""

from pathlib import Path

CONCEPTS_DIR = Path("f:/prj/Zeus/assets/branding/concepts")
CONCEPTS_DIR.mkdir(parents=True, exist_ok=True)

WORDMARK_PATH = """
  <!-- Letter Z -->
  <path d="M 300 80 L 364 80 L 364 104 L 326 152 L 364 152 L 364 176 L 300 176 L 300 152 L 338 104 L 300 104 Z" />
  <!-- Letter E -->
  <path d="M 382 80 L 438 80 L 438 104 L 406 104 L 406 116 L 432 116 L 432 140 L 406 140 L 406 152 L 438 152 L 438 176 L 382 176 Z" />
  <!-- Letter U -->
  <path d="M 456 80 L 480 80 L 480 146 L 492 146 L 492 80 L 516 80 L 516 154 L 502 176 L 470 176 L 456 154 Z" />
  <!-- Letter S -->
  <path d="M 470 80 L 470 80 Z" />
"""

# Chiseled custom athletic grotesque wordmark for "ZEUS"
ZEUS_GLYPHS = """
  <!-- Wordmark ZEUS -->
  <g fill="#000000">
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

# -----------------------------------------------------------------------------
# Concept A: The Kinetic Bolt "Z"
# -----------------------------------------------------------------------------
# Geometry snapped to strict 45.0-degree angles and pure 180-deg rotational symmetry
concept_a_symbol_svg = '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 256" width="256" height="256">
  <title>Zeus Logo — Kinetic Bolt</title>
  <path fill="#000000" fill-rule="evenodd" d="
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
  "/>
</svg>'''

concept_a_lockup_svg = f'''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 680 256" width="680" height="256">
  <title>Zeus Logo — Kinetic Bolt Lockup</title>
  <!-- Scaled Symbol on Left (height 168 at y=44) -->
  <g transform="translate(16, 0)">
    <path fill="#000000" fill-rule="evenodd" d="
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
    "/>
  </g>
  {ZEUS_GLYPHS}
</svg>'''

# -----------------------------------------------------------------------------
# Concept B: The Iron Plate & Lightning
# -----------------------------------------------------------------------------
concept_b_symbol_svg = '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 256" width="256" height="256">
  <title>Zeus Logo — Iron Plate &amp; Bolt</title>
  <g fill="#000000">
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
  </g>
</svg>'''

concept_b_lockup_svg = f'''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 680 256" width="680" height="256">
  <title>Zeus Logo — Iron Plate Lockup</title>
  <g transform="translate(16, 0)">
    <g fill="#000000">
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
    </g>
  </g>
  {ZEUS_GLYPHS}
</svg>'''

# -----------------------------------------------------------------------------
# Concept C: The Twin Plate "Z"
# -----------------------------------------------------------------------------
concept_c_symbol_svg = '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 256" width="256" height="256">
  <title>Zeus Logo — Twin Plate Z</title>
  <g fill="#000000">
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
  </g>
</svg>'''

concept_c_lockup_svg = f'''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 680 256" width="680" height="256">
  <title>Zeus Logo — Twin Plate Z Lockup</title>
  <g transform="translate(16, 0)">
    <g fill="#000000">
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
    </g>
  </g>
  {ZEUS_GLYPHS}
</svg>'''

(CONCEPTS_DIR / "concept-a-symbol.svg").write_text(concept_a_symbol_svg.strip(), encoding="utf-8")
(CONCEPTS_DIR / "concept-a-lockup.svg").write_text(concept_a_lockup_svg.strip(), encoding="utf-8")
(CONCEPTS_DIR / "concept-b-symbol.svg").write_text(concept_b_symbol_svg.strip(), encoding="utf-8")
(CONCEPTS_DIR / "concept-b-lockup.svg").write_text(concept_b_lockup_svg.strip(), encoding="utf-8")
(CONCEPTS_DIR / "concept-c-symbol.svg").write_text(concept_c_symbol_svg.strip(), encoding="utf-8")
(CONCEPTS_DIR / "concept-c-lockup.svg").write_text(concept_c_lockup_svg.strip(), encoding="utf-8")

print("Generated all 6 SVG concept files successfully.")
