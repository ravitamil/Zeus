<div align="center">

<img src="docs/screenshots/banner-en.png" alt="Zeus — Lift. Log it. Grow." width="860" />

<br/>

<img src="assets/icon/ic_1024.png" width="94" alt="Zeus" />

# Zeus

A free, privacy-first, offline gym log for Android.<br/>
Tap the muscles you want to train, log your sets, and track your strength gains.

<br/>

<p>
  <img alt="Android 7.0+" src="https://img.shields.io/badge/Android-7.0%2B-3DDC84?style=flat&logo=android&logoColor=white" />
  <img alt="License GPLv3" src="https://img.shields.io/badge/Code-GPLv3-C2410C?style=flat&logo=gnu&logoColor=white" />
  <img alt="Art CC BY-SA 4.0" src="https://img.shields.io/badge/Art-CC%20BY--SA%204.0-8A6B41?style=flat&logo=creativecommons&logoColor=white" />
  <a href="https://github.com/InlitX/GymMane"><img alt="Upstream GymMane" src="https://img.shields.io/badge/Upstream-InlitX%2FGymMane-blue?style=flat&logo=github" /></a>
</p>

</div>

---

> [!NOTE]
> ### Upstream Attribution & Thanks
> **Zeus** is an enhanced fork of the open-source [GymMane](https://github.com/InlitX/GymMane) project created and maintained by [InlitX](https://github.com/InlitX), released under the [GNU General Public License v3.0 (GPLv3)](LICENSE).
> 
> We extend our deepest gratitude to InlitX and the GymMane contributors for their fantastic architecture, clean design, and commitment to privacy. All original copyrights and author notices are preserved in accordance with Section 5 and Section 7 of the GPLv3 license.

---

## What Zeus Adds

In addition to all the features of GymMane, Zeus introduces:

- 🎬 **Custom Exercise Video Library & Thumbnails**: Over 2,300 concise demonstration videos (`assets/videos/`) and instant preview thumbnails (`assets/thumbnails/`) for visual form guidance on every lift.
- 📋 **Curated Exercise Details & Categorization**: Streamlined exercise instructions focusing on what matters — Step-by-Step How-To guides, essential Form Tips, and categorized equipment & muscle breakdowns (`exercise_categories.dart`).
- 🎨 **Accent Color Customizer**: Ported from Flash — choose from a vibrant palette of accent colors or pick any custom hex value. Your selected accent dynamically themes the entire UI and synchronizes in real time with Android home screen widgets.
- 🧮 **7 Comprehensive Fitness Calculators**:
  1. **1RM (One Rep Max)**: Accurate single-rep and multiple-rep Epley calculation with percentage tables.
  2. **Plates Per Side**: Quick barbell plate math based on your gym kit.
  3. **BMI & Healthy Weight**: Body Mass Index and healthy WHO weight ranges.
  4. **Calories & Macros**: TDEE calculation with Deficit, Maintenance, and Surplus targets.
  5. **Body Fat Calculator**: Accurate US Navy circumference formula with Fat vs Lean Mass breakdown.
  6. **Warm-up Calculator**: Automatic ramping warm-up sets clamped safely to barbell weight.
  7. **BMR (Basal Metabolic Rate)**: Dual-formula selector supporting both **Mifflin-St Jeor** and **Katch-McArdle** (lean mass based) algorithms.
- ⚡ **Zeus Branding & Identity**: Custom launcher icons, vector drawables, and refreshed visual theme.

---

## Branches

This repository maintains two distinct release tracks:

| Branch | Description | Network / Permissions |
|---|---|---|
| **`main`** *(Default)* | The primary, 100% offline, privacy-first release. Zero internet permission, zero external network calls. All exercise videos, calculators, and accent customization bundled locally. | `INTERNET` permission disabled. |
| **`feature/google-drive`** | Cloud backup & restore track. Adds seamless Google Drive AppData backup, restore, and automated post-workout backup sync for users who prefer cloud backups. | Requires `INTERNET` permission for Google Drive API. |

---

## Core Features (from GymMane)

<table>
<tr>
<td width="50%" valign="top">

### Training

- **Interactive Body Map**: Tap muscles front and back to start a workout
- **Rest Timer**: Background timer with sound and vibration alarms
- **Set Types**: Warm-up, working, drop set, failure sets, and RPE/RIR tracking
- **Supersets & Chains**: Chain movements with seamless transitions
- **Routines & AI Plans**: Create, duplicate, and schedule workout routines
- **Live Notification**: Always-visible rest timer notification surviving device reboots

</td>
<td width="50%" valign="top">

### Progress & Tracking

- **Volume & PR Tracking**: Automatic personal record detection
- **Activity Heatmap**: GitHub-style workout consistency calendar
- **Strength Curves**: Estimated 1RM trends and muscle split charts
- **Body Measurements & Photos**: Photo timeline and 10 metric measurement curves
- **Gamification**: Levels, streaks, and 20 achievement medals
- **Workout Stickers**: Generate and share workout stat cards

</td>
</tr>
<tr>
<td width="50%" valign="top">

### Exercises & Tools

- **500+ Exercises**: Animated paths + 2,300+ demonstration videos
- **Equipment & Muscle Filters**: Filter by what equipment your gym has
- **Places**: Set equipment profiles for different gyms
- **Training Journal**: Daily workout notes and calendar

</td>
<td width="50%" valign="top">

### Privacy & Data Portability

- **No Accounts, No Ads, No Tracking**: Your data stays on your device
- **Data Export & Import**: Full ZIP backup (including media) and CSV export
- **Third-Party Importers**: Import history from Hevy, Strong, Lyfta, FitNotes, openGym
- **16 Languages**: Full internationalization support

</td>
</tr>
</table>

---

## Upstream Synchronization

Zeus keeps in close lockstep with [InlitX/GymMane](https://github.com/InlitX/GymMane) releases:

### Automated Upstream Sync (GitHub Actions)
The repository includes [`.github/workflows/upstream-sync.yml`](.github/workflows/upstream-sync.yml) which runs weekly and can be triggered on demand via `workflow_dispatch`. It monitors `InlitX/GymMane` for new releases and tags.

### Local Sync Workflow
To pull upstream updates locally and merge them into Zeus:

```powershell
# Run the included PowerShell sync script:
.\scripts\sync-upstream.ps1
```

Or manually:
```bash
git fetch upstream
git checkout main
git merge upstream/main
git push origin main
```

---

## Building from Source

```bash
git clone https://github.com/ravitamil/Zeus.git
cd Zeus
flutter pub get
flutter build apk --release
```

---

## Credits & License

- **Code**: Licensed under [GNU General Public License v3.0 (GPLv3)](LICENSE).
- **Upstream Author**: [InlitX](https://github.com/InlitX) ([GymMane](https://github.com/InlitX/GymMane)).
- **Exercise Illustrations**: [Workout Guide](https://github.com/bryllim/workout-guide) by [Bryl Lim](https://bryllim.com), based on [Everkinetic](https://github.com/everkinetic/data), under [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/).
- **Fonts**: Nunito under SIL Open Font License.
- Detailed credits in [CREDITS.md](CREDITS.md).
