part of 'fit_state.dart';

const double _cmPerInch = 2.54;

mixin MeasuresState on FitCore {
  bool get isInches => units == 'lb';

  String get lengthUnit => isInches ? 'in' : 'cm';

  bool isPercent(String key) => key == 'bodyfat';

  double toDisplayMeasure(String key, double raw) =>
      isPercent(key) || !isInches ? raw : raw / _cmPerInch;

  double fromDisplayMeasure(String key, double shown) =>
      isPercent(key) || !isInches ? shown : shown * _cmPerInch;

  double toDisplayCm(double cm) => isInches ? cm / _cmPerInch : cm;

  double fromDisplayCm(double shown) => isInches ? shown * _cmPerInch : shown;

  String cmLabel(double cm) => '${fmt(_round1(toDisplayCm(cm)))} $lengthUnit';

  String heightLabel(double cm) {
    if (!isInches) return '${fmt(cm.round())} cm';
    final inches = (cm / _cmPerInch).round();
    return '${inches ~/ 12}′ ${inches % 12}″';
  }

  double get heightStep => isInches ? _cmPerInch : 1;

  double get cmStep => isInches ? _cmPerInch / 2 : 1;

  double get girthStep => isInches ? _cmPerInch / 4 : 0.5;

  String measureUnit(String key) => isPercent(key) ? '%' : lengthUnit;

  String measureValue(String key, double raw) => fmt(_round1(toDisplayMeasure(key, raw)));

  String measureLabel(String key, double raw) => '${measureValue(key, raw)} ${measureUnit(key)}';

  List<BodyMeasure> measureHistory(String key) {
    final out = measures.where((m) => m.key == key).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    return out;
  }

  BodyMeasure? latestMeasure(String key) {
    final h = measureHistory(key);
    return h.isEmpty ? null : h.first;
  }

  String measurePeriod = '30d';

  void setMeasurePeriod(String period) {
    if (measurePeriod == period) return;
    measurePeriod = period;
    notifyListeners();
  }

  bool isMeasureDecreaseGood(String key) => key == 'waist' || key == 'bodyfat';

  BodyMeasure? baselineMeasure(String key) {
    final h = measureHistory(key);
    return h.isEmpty ? null : h.last;
  }

  BodyMeasure? _closestHistoryEntry(List<BodyMeasure> h, int targetDays) {
    if (h.length < 2) return null;
    final latestDate = h.first.date;
    BodyMeasure? best;
    int bestDiff = 999999;
    for (int i = 1; i < h.length; i++) {
      final m = h[i];
      final daysAgo = latestDate.difference(m.date).inDays;
      final diff = (daysAgo - targetDays).abs();
      if (diff < bestDiff) {
        bestDiff = diff;
        best = m;
      }
    }
    return best;
  }

  BodyMeasure? measureForPeriod(String key, String period) {
    final h = measureHistory(key);
    if (h.length < 2) return null;
    switch (period) {
      case 'last':
        return h[1];
      case 'all':
        return h.last;
      case '30d':
        return _closestHistoryEntry(h, 30);
      case '90d':
        return _closestHistoryEntry(h, 90);
      case '1y':
        return _closestHistoryEntry(h, 365);
      default:
        return h[1];
    }
  }

  double? measurePeriodicChange(String key, [String? period]) {
    final p = period ?? measurePeriod;
    final h = measureHistory(key);
    if (h.length < 2) return null;
    final prior = measureForPeriod(key, p);
    if (prior == null || identical(prior, h.first)) return null;
    return _round1(toDisplayMeasure(key, h.first.value) - toDisplayMeasure(key, prior.value));
  }

  int? measurePeriodDays(String key, [String? period]) {
    final p = period ?? measurePeriod;
    final h = measureHistory(key);
    if (h.length < 2) return null;
    final prior = measureForPeriod(key, p);
    if (prior == null) return null;
    return h.first.date.difference(prior.date).inDays.abs();
  }

  double? measureChange(String key) => measurePeriodicChange(key, 'last');

  List<double> measureSeries(String key) =>
      measureHistory(key).reversed.map((m) => toDisplayMeasure(key, m.value)).toList();

  List<String> get trackedMeasures =>
      kMeasureKeys.where((k) => latestMeasure(k) != null).toList();

  bool get hasMeasures => measures.isNotEmpty;

  void addMeasure(String key, double shown, {DateTime? date}) {
    if (!kMeasureKeys.contains(key) || shown <= 0) return;
    final when = date ?? DateTime.now();
    final raw = _round1(fromDisplayMeasure(key, shown));
    measures.removeWhere((m) => m.key == key && _dayKey(m.date) == _dayKey(when));
    measures.add(BodyMeasure(when, key, raw));
    _persist();
    notifyListeners();
  }

  void deleteMeasure(BodyMeasure m) {
    measures.remove(m);
    _persist();
    notifyListeners();
  }

  void goMeasures() => pushRoute('measures');

  void backFromMeasures() => popRoute(fallback: 'progress');
}
