import 'dart:math' as math;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('1RM (One Rep Max) Calculations', () {
    double calculate1RM(double weight, int reps) {
      if (weight <= 0) return 0;
      if (reps <= 1) return weight;
      return double.parse((weight * (1 + reps / 30)).toStringAsFixed(1));
    }

    test('1 rep returns exact weight lifted (Fix for naive Epley bug)', () {
      expect(calculate1RM(100.0, 1), 100.0);
      expect(calculate1RM(142.5, 1), 142.5);
      expect(calculate1RM(60.0, 1), 60.0);
    });

    test('Multiple reps follow Epley formula correctly', () {
      // 100 * (1 + 5/30) = 100 * 1.16666... = 116.7
      expect(calculate1RM(100.0, 5), 116.7);
      // 80 * (1 + 10/30) = 80 * 1.33333... = 106.7
      expect(calculate1RM(80.0, 10), 106.7);
    });

    test('Zero weight returns 0', () {
      expect(calculate1RM(0.0, 5), 0.0);
    });

    test('Percentage table produces descending weights', () {
      final rm = calculate1RM(100.0, 1); // 100
      const percentages = [100, 95, 90, 85, 80, 75, 70, 65, 60];
      final weights = percentages.map((p) => (rm * p / 100)).toList();
      for (int i = 0; i < weights.length - 1; i++) {
        expect(weights[i] >= weights[i + 1], isTrue);
      }
    });
  });

  group('BMR (Basal Metabolic Rate) Calculations', () {
    double mifflinStJeor({
      required double weightKg,
      required double heightCm,
      required int age,
      required bool isMale,
    }) {
      return isMale
          ? 10 * weightKg + 6.25 * heightCm - 5 * age + 5
          : 10 * weightKg + 6.25 * heightCm - 5 * age - 161;
    }

    double katchMcArdle({
      required double weightKg,
      required double bodyFatPct,
    }) {
      final lbm = weightKg * (1 - (bodyFatPct / 100));
      return 370 + (21.6 * lbm);
    }

    test('Mifflin-St Jeor matches scientific benchmark for male', () {
      // 75 kg, 175 cm, 28 years male:
      // 10*75 + 6.25*175 - 5*28 + 5 = 750 + 1093.75 - 140 + 5 = 1708.75 -> 1709 kcal
      final bmr = mifflinStJeor(weightKg: 75, heightCm: 175, age: 28, isMale: true);
      expect(bmr.round(), 1709);
    });

    test('Mifflin-St Jeor matches scientific benchmark for female', () {
      // 60 kg, 165 cm, 28 years female:
      // 10*60 + 6.25*165 - 5*28 - 161 = 600 + 1031.25 - 140 - 161 = 1330.25 -> 1330 kcal
      final bmr = mifflinStJeor(weightKg: 60, heightCm: 165, age: 28, isMale: false);
      expect(bmr.round(), 1330);
    });

    test('Katch-McArdle accurately calculates based on lean body mass', () {
      // 75 kg with 15% body fat: LBM = 63.75 kg
      // BMR = 370 + (21.6 * 63.75) = 370 + 1377 = 1747 kcal
      final bmr = katchMcArdle(weightKg: 75, bodyFatPct: 15);
      expect(bmr.round(), 1747);
    });

    test('Hourly burn and activity multipliers', () {
      const bmr = 1709;
      final hourly = (bmr / 24).round();
      expect(hourly, 71);

      // Standard 5 activity multipliers
      expect((bmr * 1.2).round(), 2051); // Sedentary
      expect((bmr * 1.375).round(), 2350); // Light
      expect((bmr * 1.55).round(), 2649); // Moderate
      expect((bmr * 1.725).round(), 2948); // Active
      expect((bmr * 1.9).round(), 3247); // Very Active
    });
  });

  group('BMI (Body Mass Index) & Healthy Range', () {
    double bmi(double weightKg, double heightCm) {
      return weightKg / math.pow(heightCm / 100, 2);
    }

    test('Calculates BMI accurately and categorizes correctly', () {
      final v = bmi(75, 175);
      expect(double.parse(v.toStringAsFixed(1)), 24.5);
      expect(v >= 18.5 && v < 25.0, isTrue); // Normal
    });

    test('Calculates healthy weight range for height based on WHO guidelines', () {
      // For 175 cm, normal BMI 18.5 - 24.9:
      // Min: 18.5 * 1.75^2 = 56.66 -> 56.7 kg
      // Max: 24.9 * 1.75^2 = 76.26 -> 76.3 kg
      final h = 1.75;
      final minW = double.parse((18.5 * h * h).toStringAsFixed(1));
      final maxW = double.parse((24.9 * h * h).toStringAsFixed(1));
      expect(minW, 56.7);
      expect(maxW, 76.3);
    });
  });

  group('Calories (TDEE & Goal Targets)', () {
    test('Calculates Deficit, Maintenance, and Surplus targets', () {
      const tdee = 2500;
      final cut = (tdee * 0.82).round(); // -18%
      final maintain = tdee;
      final bulk = (tdee * 1.10).round(); // +10%

      expect(cut, 2050);
      expect(maintain, 2500);
      expect(bulk, 2750);
    });

    test('Macro distribution respects energy balance', () {
      const cals = 2000;
      // Cut macros: 35% P, 35% C, 30% F
      final p = (cals * 0.35 / 4).round();
      final c = (cals * 0.35 / 4).round();
      final f = (cals * 0.30 / 9).round();

      expect(p, 175); // 175g * 4 = 700 kcal
      expect(c, 175); // 175g * 4 = 700 kcal
      expect(f, 67); // 67g * 9 = 603 kcal
      final totalKcal = p * 4 + c * 4 + f * 9;
      expect((totalKcal - cals).abs() <= 10, isTrue);
    });
  });

  group('Body Fat (US Navy Formula) & Body Composition', () {
    double log10(double x) => math.log(x) / math.ln10;

    double maleBodyFat({required double heightCm, required double neckCm, required double waistCm}) {
      final girth = math.max(1.0, waistCm - neckCm);
      final v = 495 / (1.0324 - 0.19077 * log10(girth) + 0.15456 * log10(heightCm)) - 450;
      return math.max(3.0, math.min(50.0, v));
    }

    double femaleBodyFat({
      required double heightCm,
      required double neckCm,
      required double waistCm,
      required double hipCm,
    }) {
      final girth = math.max(1.0, waistCm + hipCm - neckCm);
      final v = 495 / (1.29579 - 0.35004 * log10(girth) + 0.221 * log10(heightCm)) - 450;
      return math.max(3.0, math.min(50.0, v));
    }

    test('Male US Navy formula computes consistent body fat', () {
      // Height 175cm, Neck 38cm, Waist 84cm -> girth = 46cm
      final bf = maleBodyFat(heightCm: 175, neckCm: 38, waistCm: 84);
      expect(double.parse(bf.toStringAsFixed(1)), 16.2);
    });

    test('Female US Navy formula accounts for hips', () {
      // Height 165cm, Neck 32cm, Waist 70cm, Hip 95cm -> girth = 133cm
      final bf = femaleBodyFat(heightCm: 165, neckCm: 32, waistCm: 70, hipCm: 95);
      expect(bf > 10 && bf < 35, isTrue);
    });

    test('Fat Mass and Lean Mass sum to total weight', () {
      const totalWeight = 80.0;
      const bfPct = 15.0;
      final fatMass = totalWeight * (bfPct / 100);
      final leanMass = totalWeight * (1 - bfPct / 100);

      expect(fatMass, 12.0);
      expect(leanMass, 68.0);
      expect(fatMass + leanMass, totalWeight);
    });
  });

  group('Warm-up Sets Clamping', () {
    test('Warmup weights are never lighter than the barbell', () {
      const barWeight = 20.0;
      const targetWeight = 40.0; // 45% = 18 kg, which would be invalid on a 20kg bar!

      const spec = [45, 60, 75, 85, 90];
      final sets = spec.map((pct) {
        final raw = targetWeight * pct / 100;
        final rounded = (raw / 2.5).round() * 2.5;
        return math.max(barWeight, rounded);
      }).toList();

      for (final w in sets) {
        expect(w >= barWeight, isTrue, reason: 'Warmup weight $w must be >= bar $barWeight');
      }
    });

    test('When target is equal to or less than bar, warmup shows single bar set', () {
      const barWeight = 20.0;
      const targetWeight = 20.0;
      final isBarOnly = targetWeight <= barWeight;
      expect(isBarOnly, isTrue);
    });
  });
}
