part of 'fit_state.dart';

mixin ToolsState on FitCore {
  String? activeToolId;
  double rmWeight = 100;
  int rmReps = 5;

  // BMR State
  int bmrAge = 28;
  double bmrHeight = 175;
  double bmrWeight = 75;
  String bmrSex = 'male';
  bool bmrUseBodyFat = false;
  double bmrBodyFat = 15;

  double bmiHeight = 175;
  double bmiWeight = 75;
  int calAge = 28;
  double calHeight = 175;
  double calWeight = 75;
  String calSex = 'male';
  double calActivity = 1.55;
  String calGoal = 'maintain'; // 'cut', 'maintain', 'bulk'
  String bfSex = 'male';
  double bfHeight = 175;
  double bfNeck = 38;
  double bfWaist = 84;
  double bfHip = 95;
  double plateTarget = 100;
  double plateBar = 20;
  double warmupTarget = 100;

  void _seedCalculatorsFromProfile() {
    calAge = profile.age;
    calHeight = profile.heightCm;
    calWeight = profile.weightKg;
    calSex = profile.sex;
    calActivity = profile.activity;

    bmrAge = profile.age;
    bmrHeight = profile.heightCm;
    bmrWeight = profile.weightKg;
    bmrSex = profile.sex;
    bmrBodyFat = 15;

    bmiHeight = profile.heightCm;
    bmiWeight = profile.weightKg;
    bfHeight = profile.heightCm;
    bfSex = profile.sex;
  }

  void goTools() => pushRoute('tools');

  void openTool(String id) {
    activeToolId = id;
    pushRoute('tools-detail');
  }

  void closeTool() => popRoute(fallback: 'tools');

  void backFromTools() => popRoute();

  // 1RM: When reps == 1, 1RM is exactly the weight lifted
  double get rmResult {
    if (rmWeight <= 0) return 0;
    if (rmReps <= 1) return _round1(rmWeight);
    return _round1(rmWeight * (1 + rmReps / 30));
  }

  List<({int pct, int reps, double weight})> get rmPercentages {
    final maxWeight = toDisplayWeight(rmResult);
    const spec = [
      (100, 1),
      (95, 2),
      (90, 4),
      (85, 6),
      (80, 8),
      (75, 10),
      (70, 12),
      (65, 15),
      (60, 20),
    ];
    final step = isLb ? 5.0 : 2.5;
    return spec
        .map((s) => (
              pct: s.$1,
              reps: s.$2,
              weight: _roundTo(maxWeight * s.$1 / 100, step),
            ))
        .toList();
  }

  // BMR: Mifflin-St Jeor Equation (Gold standard)
  double get bmrMifflin => bmrSex == 'male'
      ? 10 * bmrWeight + 6.25 * bmrHeight - 5 * bmrAge + 5
      : 10 * bmrWeight + 6.25 * bmrHeight - 5 * bmrAge - 161;

  // BMR: Katch-McArdle Equation (Lean Body Mass based)
  double get bmrKatch {
    final lbm = bmrWeight * (1 - (bmrBodyFat / 100));
    return 370 + (21.6 * lbm);
  }

  int get bmrVal => (bmrUseBodyFat ? bmrKatch : bmrMifflin).round();

  int get bmrHourly => (bmrVal / 24).round();

  List<({String name, double factor, int calories})> get bmrActivityTiers {
    final b = bmrVal;
    return [
      (name: 'Sedentary', factor: 1.2, calories: (b * 1.2).round()),
      (name: 'Light', factor: 1.375, calories: (b * 1.375).round()),
      (name: 'Moderate', factor: 1.55, calories: (b * 1.55).round()),
      (name: 'Active', factor: 1.725, calories: (b * 1.725).round()),
      (name: 'Very Active', factor: 1.9, calories: (b * 1.9).round()),
    ];
  }

  double get bmiVal => _round1(bmiWeight / math.pow(bmiHeight / 100, 2));

  String get bmiCat {
    final v = bmiVal;
    if (v < 18.5) return 'Underweight';
    if (v < 25) return 'Normal';
    if (v < 30) return 'Overweight';
    return 'Obese';
  }

  double get bmiHealthyMin => _round1(toDisplayWeight(18.5 * math.pow(bmiHeight / 100, 2)));
  double get bmiHealthyMax => _round1(toDisplayWeight(24.9 * math.pow(bmiHeight / 100, 2)));

  double get _bmr => calSex == 'male'
      ? 10 * calWeight + 6.25 * calHeight - 5 * calAge + 5
      : 10 * calWeight + 6.25 * calHeight - 5 * calAge - 161;

  int get tdee => (_bmr * calActivity).round();

  int get targetCalories => switch (calGoal) {
        'cut' => (tdee * 0.82).round(),
        'bulk' => (tdee * 1.10).round(),
        _ => tdee,
      };

  int get calProtein => switch (calGoal) {
        'cut' => (targetCalories * 0.35 / 4).round(),
        'bulk' => (targetCalories * 0.25 / 4).round(),
        _ => (targetCalories * 0.30 / 4).round(),
      };

  int get calCarbs => switch (calGoal) {
        'cut' => (targetCalories * 0.35 / 4).round(),
        'bulk' => (targetCalories * 0.50 / 4).round(),
        _ => (targetCalories * 0.40 / 4).round(),
      };

  int get calFat => switch (calGoal) {
        'cut' => (targetCalories * 0.30 / 9).round(),
        'bulk' => (targetCalories * 0.25 / 9).round(),
        _ => (targetCalories * 0.30 / 9).round(),
      };

  String get activityLabel {
    if (calActivity == 1.2) return 'Sedentary';
    if (calActivity == 1.375) return 'Light';
    if (calActivity == 1.725) return 'Active';
    if (calActivity == 1.9) return 'Very Active';
    return 'Moderate';
  }

  double _log10(double x) => math.log(x) / math.ln10;

  double get bfVal {
    double v;

    if (bfSex == 'male') {
      final girth = math.max(1.0, bfWaist - bfNeck);
      v = 495 / (1.0324 - 0.19077 * _log10(girth) + 0.15456 * _log10(bfHeight)) - 450;
    } else {
      final girth = math.max(1.0, bfWaist + bfHip - bfNeck);
      v = 495 / (1.29579 - 0.35004 * _log10(girth) + 0.221 * _log10(bfHeight)) - 450;
    }
    return _round1(math.max(3, math.min(50, v)));
  }

  double get bfFatMass => _round1(toDisplayWeight(calWeight * (bfVal / 100)));
  double get bfLeanMass => _round1(toDisplayWeight(calWeight * (1 - bfVal / 100)));

  String get bfCategory {
    final v = bfVal;
    if (bfSex == 'male') {
      if (v < 6) return 'Essential';
      if (v < 14) return 'Athletic';
      if (v < 18) return 'Fitness';
      if (v < 25) return 'Average';
      return 'Obese';
    } else {
      if (v < 14) return 'Essential';
      if (v < 21) return 'Athletic';
      if (v < 25) return 'Fitness';
      if (v < 32) return 'Average';
      return 'Obese';
    }
  }

  List<double> get barOptions => isLb ? const [45, 35, 15] : const [20, 15, 10];

  List<double> get plateSizes => _plateSteps;

  List<double> get _plateSteps =>
      isLb ? const [45, 35, 25, 10, 5, 2.5] : const [25, 20, 15, 10, 5, 2.5, 1.25];

  List<({double weight, int count})> get plateBreakdown =>
      platesPerSide(toDisplayWeight(plateTarget), toDisplayWeight(plateBar));

  double get defaultBar {
    final placeBar = placeBarKg;
    if (placeBar != null) return _round1(toDisplayWeight(placeBar));
    return isLb ? 45 : 20;
  }

  Map<double, int>? get plateStockDisplay {
    final stock = plateStockKg;
    if (stock == null) return null;
    return {for (final e in stock.entries) _round1(toDisplayWeight(e.key)): e.value};
  }

  List<({double weight, int count})> platesPerSide(double displayTarget, double displayBar) {
    final stock = plateStockDisplay;
    final steps = stock == null
        ? _plateSteps
        : (stock.keys.toList()..sort((a, b) => b.compareTo(a)));
    double perSide = math.max(0, (displayTarget - displayBar) / 2);
    final out = <({double weight, int count})>[];
    for (final p in steps) {
      var count = (perSide / p + 1e-6).floor();
      if (stock != null) count = math.min(count, stock[p] ?? 0);
      if (count > 0) {
        out.add((weight: p, count: count));
        perSide = _round1(perSide - count * p);
      }
    }
    return out;
  }

  double loadableTotal(double displayTarget, double displayBar) {
    final parts = platesPerSide(displayTarget, displayBar);
    return _round1(displayBar + parts.fold<double>(0, (a, p) => a + p.weight * p.count) * 2);
  }

  String? plateHint(String equipment, double weightKg) {
    if (equipment != 'Barbell') return null;
    final target = _round1(toDisplayWeight(weightKg));
    if (target <= defaultBar) return null;
    final parts = platesPerSide(target, defaultBar);
    if (parts.isEmpty) return null;
    return parts
        .map((p) => p.count == 1 ? fmt(p.weight) : '${fmt(p.weight)}×${p.count}')
        .join(' · ');
  }

  List<({String pct, int reps, double weight, bool isBarOnly})> get warmupSets {
    final bar = defaultBar;
    final target = toDisplayWeight(warmupTarget);
    final step = isLb ? 5.0 : 2.5;

    if (target <= bar) {
      return [
        (pct: '100%', reps: 10, weight: bar, isBarOnly: true),
      ];
    }

    const spec = [(45, 10), (60, 5), (75, 3), (85, 2), (90, 1)];
    final out = <({String pct, int reps, double weight, bool isBarOnly})>[];
    for (final s in spec) {
      final rawWeight = target * s.$1 / 100;
      final roundedWeight = _roundTo(rawWeight, step);
      final clampedWeight = math.max(bar, roundedWeight);
      final isBar = clampedWeight == bar;

      if (out.isNotEmpty && out.last.weight == clampedWeight && isBar) {
        continue;
      }
      out.add((
        pct: '${s.$1}%',
        reps: s.$2,
        weight: clampedWeight,
        isBarOnly: isBar,
      ));
    }
    return out;
  }

  void bumpTool(void Function() apply) {
    apply();
    notifyListeners();
  }

  double _clamp(double v, double? min, double? max) {
    if (min != null) v = math.max(min, v);
    if (max != null) v = math.min(max, v);
    return (v * 100).round() / 100;
  }

  void bumpRmWeight(double d) { rmWeight = _clamp(rmWeight + d, 0, null); notifyListeners(); }

  void bumpRmReps(int d) { rmReps = _clamp(rmReps + d.toDouble(), 1, 20).round(); notifyListeners(); }

  // BMR controls
  void bumpBmrAge(int d) { bmrAge = _clamp(bmrAge + d.toDouble(), 10, 90).round(); notifyListeners(); }

  void bumpBmrHeight(double d) { bmrHeight = _clamp(bmrHeight + d, 100, 250); notifyListeners(); }

  void bumpBmrWeight(double d) { bmrWeight = _clamp(bmrWeight + d, 30, 250); notifyListeners(); }

  void bumpBmrBodyFat(double d) { bmrBodyFat = _clamp(bmrBodyFat + d, 4, 50); notifyListeners(); }

  void setBmrSex(String s) { bmrSex = s; notifyListeners(); }

  void setBmrUseBodyFat(bool v) { bmrUseBodyFat = v; notifyListeners(); }

  void bumpBmiHeight(double d) { bmiHeight = _clamp(bmiHeight + d, 100, 250); notifyListeners(); }

  void bumpBmiWeight(double d) { bmiWeight = _clamp(bmiWeight + d, 30, 250); notifyListeners(); }

  void bumpCalAge(int d) { calAge = _clamp(calAge + d.toDouble(), 10, 90).round(); notifyListeners(); }

  void bumpCalHeight(double d) { calHeight = _clamp(calHeight + d, 100, 250); notifyListeners(); }

  void bumpCalWeight(double d) { calWeight = _clamp(calWeight + d, 30, 250); notifyListeners(); }

  void setCalSex(String s) { calSex = s; notifyListeners(); }

  void setCalActivity(double a) { calActivity = a; notifyListeners(); }

  void setCalGoal(String g) { calGoal = g; notifyListeners(); }

  void bumpBfHeight(double d) { bfHeight = _clamp(bfHeight + d, 100, 250); notifyListeners(); }

  void bumpBfNeck(double d) { bfNeck = _clamp(bfNeck + d, 20, 60); notifyListeners(); }

  void bumpBfWaist(double d) { bfWaist = _clamp(bfWaist + d, 40, 200); notifyListeners(); }

  void bumpBfHip(double d) { bfHip = _clamp(bfHip + d, 40, 200); notifyListeners(); }

  void setBfSex(String s) { bfSex = s; notifyListeners(); }

  void bumpPlateTarget(double d) { plateTarget = _clamp(plateTarget + d, 0, null); notifyListeners(); }

  void setPlateBar(double b) { plateBar = fromDisplayWeight(b); notifyListeners(); }

  double get plateBarDisplay => _round1(toDisplayWeight(plateBar));

  void bumpWarmupTarget(double d) { warmupTarget = _clamp(warmupTarget + d, 0, null); notifyListeners(); }
}
