import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../catalog/exercise_catalog.dart';
import 'app_localizations.dart';
import 'catalog_es.dart';
import 'catalog_it.dart';
import 'catalog_zh.dart';

export 'app_localizations.dart';

const Map<String, Map<String, String>> _catalogNames = {'es': kExerciseNameEs, 'it': kExerciseNameIt, 'zh': kExerciseNameZh};
const Map<String, Map<String, List<String>>> _catalogSteps = {'es': kExerciseStepsEs, 'it': kExerciseStepsIt, 'zh': kExerciseStepsZh};

String appLanguage = 'en';
AppLocalizations t = lookupAppLocalizations(const Locale('en'));

String _codeOf(Locale l) => l.scriptCode == null ? l.languageCode : '${l.languageCode}_${l.scriptCode}';

List<String> get appLanguages => AppLocalizations.supportedLocales.map(_codeOf).toList();

Locale localeOf(String code) {
  final parts = code.split('_');
  return parts.length > 1
      ? Locale.fromSubtags(languageCode: parts.first, scriptCode: parts[1])
      : Locale(code);
}

String languageNameOf(String code) => lookupAppLocalizations(localeOf(code)).languageName;

String get intlLocale => appLanguage == 'zh_Hant' ? 'zh_TW' : appLanguage;

String resolveLanguage(String code) {
  if (appLanguages.contains(code)) return code;
  final parts = code.toLowerCase().split(RegExp('[-_]'));
  final base = parts.first;
  if (base == 'zh' && parts.skip(1).any(const {'hant', 'tw', 'hk', 'mo'}.contains)) return 'zh_Hant';
  return appLanguages.contains(base) ? base : 'en';
}

void setAppLanguage(String code) {
  appLanguage = resolveLanguage(code);
  t = lookupAppLocalizations(localeOf(appLanguage));
  Intl.defaultLocale = intlLocale;
}

bool _dateSymbolsReady = false;

DateFormat _dates(DateFormat Function(String locale) build) {
  if (!_dateSymbolsReady) {
    initializeDateFormatting();
    _dateSymbolsReady = true;
  }
  return build(intlLocale);
}

extension GymL10n on AppLocalizations {
  String finishHeadline({required int prs, required int streak, required bool goalHit}) {
    if (prs > 0) return finishHeadlinePr;
    if (goalHit) return finishHeadlineGoal;
    if (streak >= 3) return finishHeadlineStreak;
    return finishHeadlineDefault;
  }

  String finishBody({required int prs, required int streak, required bool goalHit}) {
    if (prs > 0) return finishBodyPr(prs);
    if (goalHit) return finishBodyGoal;
    if (streak >= 3) return finishBodyStreak(streak);
    return finishBodyDefault;
  }

  String vsLastMonth(int pct) => vsLastMonthLabel('${pct >= 0 ? '+' : ''}$pct');

  String levelStreak(int level, int streak) => levelStreakLabel(level, streakDays(streak));

  String toolName(String id) => switch (id) {
        'rm' => toolNameRm,
        'bmr' => 'BMR',
        'bmi' => toolNameBmi,
        'cal' => toolNameCal,
        'bf' => toolNameBf,
        'plate' => toolNamePlate,
        _ => toolNameWarmup,
      };

  String toolTitle(String id) => switch (id) {
        'rm' => toolTitleRm,
        'bmr' => 'BMR Calculator',
        'bmi' => toolTitleBmi,
        'cal' => toolTitleCal,
        'bf' => toolTitleBf,
        'plate' => toolTitlePlate,
        _ => toolTitleWarmup,
      };

  String toolResultHint(String id) => switch (id) {
        'rm' => toolHintRm,
        'bmr' => 'Basal metabolic rate (at rest)',
        'cal' => toolHintCal,
        'bf' => toolHintBf,
        'plate' => toolHintPlate,
        _ => toolHintWarmup,
      };

  String templateBlurb(String id) => switch (id) {
        'fullbody' => tplFullbody,
        'ppl' => tplPpl,
        'upperlower' => tplUpperlower,
        'abcd' => tplAbcd,
        'abcde' => tplAbcde,
        'stronglifts' => tplStronglifts,
        'startingstrength' => tplStartingstrength,
        _ => tplHome,
      };

  String toolDesc(String id) => switch (id) {
        'rm' => toolDescRm,
        'bmr' => 'Basal metabolic rate',
        'bmi' => toolDescBmi,
        'cal' => toolDescCal,
        'bf' => toolDescBf,
        'plate' => toolDescPlate,
        _ => toolDescWarmup,
      };

  String bmiCategory(String key) => switch (key) {
        'Underweight' => bmiUnderweight,
        'Normal' => bmiNormal,
        'Overweight' => bmiOverweight,
        _ => bmiObese,
      };

  String activityName(String key) => switch (key) {
        'Sedentary' => actSedentary,
        'Light' => actLight,
        'Active' => actActive,
        'Very Active' => 'Very Active',
        _ => actModerate,
      };

  String muscle(String id) => switch (id) {
        'chest' => muscleChest,
        'back' => muscleBack,
        'shoulders' => muscleShoulders,
        'biceps' => muscleBiceps,
        'triceps' => muscleTriceps,
        'forearm' => muscleForearm,
        'trapezius' => muscleTrapezius,
        'abdomen' => muscleAbdomen,
        'obliques' => muscleObliques,
        'quads' => muscleQuads,
        'hamstrings' => muscleHamstrings,
        'glutes' => muscleGlutes,
        'calves' => muscleCalves,
        _ => id,
      };

  String poseName(String pose) => switch (pose) {
        'front' => poseFront,
        'side' => poseSide,
        _ => poseBack,
      };

  String placePresetName(String preset) => switch (preset) {
        'gym' => placeGym,
        'home' => placeHome,
        _ => placeOutdoors,
      };

  String photoInterval(int days) => days <= 0 ? photoEveryOff : photoEveryDays(days);

  String measureName(String key) => switch (key) {
        'neck' => measureNeck,
        'shoulders' => measureShoulders,
        'chest' => measureChest,
        'arm' => measureArm,
        'forearm' => measureForearm,
        'waist' => measureWaist,
        'hips' => measureHips,
        'thigh' => measureThigh,
        'calf' => measureCalf,
        _ => measureBodyfat,
      };

  String muscleGroupName(String key) => switch (key) {
        'Chest' => mgChest,
        'Back' => mgBack,
        'Legs' => mgLegs,
        'Shoulders' => mgShoulders,
        'Arms' => mgArms,
        'Core' => mgCore,
        _ => key,
      };

  String equipment(String id) => switch (id) {
        'Barbell' => equipBarbell,
        'Dumbbell' => equipDumbbell,
        'Cable' => equipCable,
        'Machine' => equipMachine,
        'Bodyweight' => equipBodyweight,
        'Weighted' => equipWeighted,
        'Band' => equipBand,
        'Kettlebell' => equipKettlebell,
        'Rings' => equipRings,
        _ => equipOther,
      };

  String difficulty(String id) => switch (id) {
        'Beginner' => diffBeginner,
        'Advanced' => diffAdvanced,
        _ => diffIntermediate,
      };

  String weekday(int w) =>
      _capitalize(_dates(DateFormat.EEEE).format(DateTime(2024, 1, w)));

  String weekdayShort(int w) =>
      _capitalize(_dates(DateFormat.E).format(DateTime(2024, 1, w)));

  String weekdayInitial(int w) =>
      _dates((l) => DateFormat('', l)).dateSymbols.NARROWWEEKDAYS[w % 7];

  int get firstWeekday =>
      _dates((l) => DateFormat('', l)).dateSymbols.FIRSTDAYOFWEEK + 1;

  String monthInitial(int m) =>
      _dates((l) => DateFormat('', l)).dateSymbols.NARROWMONTHS[m - 1];

  String monthName(int m) =>
      _capitalize(_dates(DateFormat.MMMM).format(DateTime(2024, m)));

  String monthYear(DateTime d) => _capitalize(_dates(DateFormat.yMMMM).format(d));

  String fullDate(DateTime d) => '${weekday(d.weekday)}, ${shortDateYear(d)}';

  String longDate(DateTime d) => '${weekday(d.weekday)}, ${shortDate(d)}';

  String shortDate(DateTime d) => _dates(DateFormat.MMMd).format(d);

  String shortDateYear(DateTime d) => _dates(DateFormat.yMMMd).format(d);

  String catalogName(String id, String fallback) => _catalogNames[appLanguage]?[id] ?? fallback;

  List<String> catalogSteps(String id, List<String> fallback) =>
      _catalogSteps[appLanguage]?[id] ?? fallback;

  String get calculatorsFolderDetail =>
      calculatorsInside.replaceFirst(RegExp(r'\d+'), '${kToolMeta.length}');

  String get accentColor => switch (appLanguage) {
        'es' => 'Color de acento',
        'fr' => "Couleur d'accent",
        'de' => 'Akzentfarbe',
        'it' => 'Colore accento',
        'pt' => 'Cor de destaque',
        'ru' => 'Цвет акцента',
        'ja' => 'アクセントカラー',
        'ko' => '강조 색상',
        'zh' || 'zh_Hant' => '强调色',
        'ar' => 'لون التمييز',
        _ => 'Accent color',
      };

  String get accentColorSub => switch (appLanguage) {
        'es' => 'Personaliza el color del tema',
        'fr' => 'Personnaliser la couleur du thème',
        'de' => 'Design-Farbe anpassen',
        'it' => 'Personalizza il colore del tema',
        'pt' => 'Personalizar a cor do tema',
        'ru' => 'Настроить цвет темы',
        'ja' => 'テーマカラーをカスタマイズ',
        'ko' => '테마 색상 맞춤설정',
        'zh' || 'zh_Hant' => '自定义主题颜色',
        'ar' => 'تخصيص لون السمة',
        _ => 'Customize application theme color',
      };

  String get colorsTab => switch (appLanguage) {
        'es' => 'Colores',
        'fr' => 'Couleurs',
        'de' => 'Farben',
        'it' => 'Colori',
        'pt' => 'Cores',
        'ru' => 'Цвета',
        'ja' => 'カラー',
        'ko' => '색상',
        'zh' || 'zh_Hant' => '预设颜色',
        'ar' => 'الألوان',
        _ => 'Colors',
      };

  String get customTab => switch (appLanguage) {
        'es' => 'Personalizado',
        'fr' => 'Personnalisé',
        'de' => 'Eigene',
        'it' => 'Personalizzato',
        'pt' => 'Personalizado',
        'ru' => 'Свой цвет',
        'ja' => 'カスタム',
        'ko' => '사용자 지정',
        'zh' || 'zh_Hant' => '自定义',
        'ar' => 'مخصص',
        _ => 'Custom',
      };

  String get resetDefault => switch (appLanguage) {
        'es' => 'Predeterminado',
        'fr' => 'Par défaut',
        'de' => 'Standard',
        'it' => 'Predefinito',
        'pt' => 'Padrão',
        'ru' => 'По умолчанию',
        'ja' => 'デフォルト',
        'ko' => '기본값',
        'zh' || 'zh_Hant' => '默认',
        'ar' => 'افتراضي',
        _ => 'Default',
      };
}

String _capitalize(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
