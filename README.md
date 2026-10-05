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
  <a href="https://crowdin.com/project/gymmane"><img alt="Crowdin" src="https://badges.crowdin.net/gymmane/localized.svg" /></a>
</p>

</div>

---

> [!NOTE]
> ### Upstream Attribution & Thanks
> **Zeus** is an enhanced fork of the open-source [GymMane](https://github.com/InlitX/GymMane) project created and maintained by [InlitX](https://github.com/InlitX), released under the [GNU General Public License v3.0 (GPLv3)](LICENSE) with attribution term [ADDITIONAL_TERMS.md](ADDITIONAL_TERMS.md) under section 7(b).
> 
> *Based on GymMane by InlitX.* We extend our deepest gratitude to InlitX and the GymMane contributors for their fantastic architecture, clean design, and commitment to privacy. All original copyrights and author notices are preserved in accordance with Section 5 and Section 7 of the GPLv3 license.

---

## What Zeus Adds

In addition to all the features of GymMane, Zeus introduces:

- 🎬 **Custom Exercise Video Library & Thumbnails**: Over 2,300 concise demonstration videos (`assets/videos/`) and instant preview thumbnails (`assets/thumbnails/`) for visual form guidance on every lift.
- 📋 **Curated Exercise Details & Categorization**: Streamlined exercise instructions focusing on what matters — Step-by-Step How-To guides, essential Form Tips, and categorized equipment & muscle breakdowns (`exercise_categories.dart`).
- 🎨 **Accent Color Customizer**: Ported from Flash — choose from a vibrant palette of accent colors or pick any custom hex value. Your selected accent dynamically themes the entire UI and synchronizes in real time with Android home screen widgets.
- 🧮 **9 Comprehensive Fitness Calculators**:
  1. **1RM (One Rep Max)**: Accurate single-rep and multiple-rep Epley calculation with percentage tables and plate loading breakdown.
  2. **BMR (Basal Metabolic Rate)**: Dual-formula calculator supporting Mifflin-St Jeor & Katch-McArdle equations with body fat input.
  3. **BMI & Healthy Weight**: Body Mass Index and healthy WHO weight ranges.
  4. **TDEE & Caloric Goal Calculator**: Daily energy expenditure with deficit/surplus macros (cut, maintain, bulk).
  5. **Body Fat % (US Navy Method)**: Accurate circumference-based estimates for men and women.
  6. **Plates Per Side**: Quick barbell plate math based on your gym kit and custom bar weights.
  7. **Warm-Up Sets**: Progressive ramp-up sets to prepare for heavy working weights.
  8. **RPE Load Calculator**: Calculate target weight based on RPE and reps.
  9. **DOTS Calculator**: Powerlifting coefficient score comparing relative strength.
- 🛡️ **GPLv3 Attribution & Dual-Author Credits**: Clean dual-attribution in the About screen preserving original GymMane creator links while highlighting Zeus customizations.

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
- **Routines & AI Plans**: Create, duplicate, and schedule workout routines (several a day, routine groups), plus ready-made plans
- **Next Step**: When an exercise gets easy, it offers progressive overload recommendations
- **Mid-Workout Swap**: Swap an exercise mid-session without losing progress
- **Live Notification**: Always-visible rest timer notification surviving device reboots

</td>
<td width="50%" valign="top">

### Progress & Tracking

- **Volume & PR Tracking**: Automatic personal record detection
- **Activity Heatmap**: GitHub-style workout consistency calendar
- **Strength Curves**: Estimated 1RM trends and muscle split charts
- **Body Measurements & Photos**: Photo timeline and periodic metric measurement curves
- **Gamification**: Levels, streaks, and achievement medals
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

- **No Accounts, No Ads, No Tracking**: Your data stays on your device (no internet permission required)
- **Data Export & Import**: Full ZIP backup (including media) and CSV export
- **Third-Party Importers**: Import history from Hevy, Strong, Lyfta, FitNotes, openGym
- **Strava Export**: Export workouts to Strava as `.fit` binary files
- **Multilingual**: Translated across 17+ languages via Crowdin

</td>
</tr>
</table>

---

## Upstream Synchronization

Zeus tracks the upstream `InlitX/GymMane` repository as a remote.

### Remote Configuration
```bash
origin   -> https://github.com/ravitamil/Zeus.git
upstream -> https://github.com/InlitX/GymMane.git
```

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

- **Code**: Licensed under [GNU General Public License v3.0 (GPLv3)](LICENSE), with additional term [ADDITIONAL_TERMS.md](ADDITIONAL_TERMS.md) under section 7(b): works based on GymMane must credit it as "Based on GymMane by InlitX".
- **Upstream Author**: [InlitX](https://github.com/InlitX) ([GymMane](https://github.com/InlitX/GymMane)).
- **Exercise Illustrations**: [Workout Guide](https://github.com/bryllim/workout-guide) by [Bryl Lim](https://bryllim.com) and from [Everkinetic](https://github.com/everkinetic/data), under [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/).
- **Fonts**: Nunito under SIL Open Font License.
- Detailed credits in [CREDITS.md](CREDITS.md).
