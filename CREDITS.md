# Credits & Modifications Notice

## Upstream Project & Copyright Notice

Zeus is a derivative work based on **GymMane**, originally authored and maintained by **InlitX** ([https://github.com/InlitX/GymMane](https://github.com/InlitX/GymMane)).
- **Original Work Copyright**: Copyright (C) InlitX and GymMane Contributors.
- **License**: GNU General Public License v3.0 (GPLv3).

### Modifications Made in Zeus (2026)
In accordance with GNU GPLv3 Section 5(a), the following substantial modifications and additions were made:
1. **Custom Exercise Video Demonstrations & Thumbnails**: Integrated 2,300+ concise demonstration MP4 videos (`assets/videos/`) and WebP preview thumbnails (`assets/thumbnails/`) for visual form guidance on exercises.
2. **Curated Exercise Details & Categorization**: Added structured categorization (`lib/catalog/exercise_categories.dart`), streamlined How-To instructions and form tips, removing redundant overviews.
3. **Accent Color Customizer**: Implemented customizable accent color system ported from Flash (`lib/widgets/accent_color_picker.dart`), with dynamic luminance adaptation and real-time Android home widget synchronization.
4. **Comprehensive Fitness Calculators**: Expanded calculator suite to 7 tools, adding dual-formula BMR calculations (Mifflin-St Jeor & Katch-McArdle lean mass algorithms), TDEE targets, plate math, and safe barbell warm-up set clamping.
5. **Zeus Branding & Assets**: Rebranded package identifier to `com.zeus.app`, introduced Zeus logos and launcher icons.
6. **Google Drive Cloud Integration** (available on `feature/google-drive` branch): Added optional encrypted cloud backup and restore via Google Drive API v3 AppData folder.

---

## Exercise Illustrations

The exercise art in `assets/art/` comes from
[Workout Guide](https://github.com/bryllim/workout-guide) by
[Bryl Lim](https://bryllim.com), which builds on pose artwork from
[Everkinetic](https://github.com/everkinetic/data).

Both are licensed under
[CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/), and GymMane's
copy stays under that same license — the rest of the app is GPLv3.

**Changes made.** Each Workout Guide frame is a 512 × 512 SVG holding a single
`<path>`. That path data was lifted into one plain-text file per exercise —
three lines, one per frame — so the app draws it with `path_drawing` and tints
it with the current theme instead of shipping a fixed-colour image. The
geometry is untouched.

Every exercise in the catalogue names the illustration it uses in its `art:`
field, and the files under `assets/art/` are named after the Workout Guide
exercise they come from, so any frame can be traced back to its original.
Several exercises share one illustration when they are the same movement done
with different equipment.

---

## Fonts

Nunito, by the Nunito Project Authors, under the SIL Open Font License
(`assets/fonts/Nunito-OFL.txt`).
