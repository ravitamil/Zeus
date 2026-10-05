import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/foundation.dart' show compute;
import '../models/exercise.dart';
import 'base_exercises.dart';

export 'base_exercises.dart';

List<Exercise>? _cachedExercises;

List<Exercise> get kExercises {
  if (_cachedExercises != null && _cachedExercises!.isNotEmpty) {
    return _cachedExercises!;
  }
  final videoExs = _loadExercisesSyncFallback();
  _cachedExercises = [...kBaseExercises, ...videoExs];
  return _cachedExercises!;
}

List<Exercise> _loadExercisesSyncFallback() {
  try {
    final file = File('assets/catalog/exercises.json');
    if (file.existsSync()) {
      final jsonStr = file.readAsStringSync();
      final list = jsonDecode(jsonStr) as List;
      return list.map((e) => Exercise.fromJson(e as Map<String, dynamic>)).toList();
    }
  } catch (_) {}
  return const [];
}

class ExerciseCatalog {
  ExerciseCatalog._();

  static Future<void> init() async {
    if (_cachedExercises != null && _cachedExercises!.isNotEmpty) return;
    try {
      final jsonStr = await rootBundle.loadString('assets/catalog/exercises.json');
      _cachedExercises = await compute(_decodeCatalog, jsonStr);
    } catch (_) {
      final videoExs = _loadExercisesSyncFallback();
      _cachedExercises = [...kBaseExercises, ...videoExs];
    }
  }
}

List<Exercise> _decodeCatalog(String jsonStr) {
  final list = jsonDecode(jsonStr) as List;
  return [...kBaseExercises,
    ...list.map((entry) => Exercise.fromJson(entry as Map<String, dynamic>)),
  ];
}

const List<ToolMeta> kToolMeta = [
  ToolMeta('rm', '1RM', 'Estimated one-rep max'),
  ToolMeta('bmr', 'BMR', 'Basal metabolic rate'),
  ToolMeta('bmi', 'BMI', 'Body mass index'),
  ToolMeta('cal', 'Calories', 'Calories & macros'),
  ToolMeta('bf', 'Body Fat', 'Body fat percentage'),
  ToolMeta('plate', 'Plates', 'Barbell plate calculator'),
  ToolMeta('warmup', 'Warm-up', 'Ramp-up sets'),
  ToolMeta('rpe', 'RPE load', 'Weight for a target effort'),
  ToolMeta('dots', 'Strength level', 'DOTS score'),
];

const List<String> kFilterMuscles = [
  'chest', 'back', 'shoulders', 'biceps', 'triceps', 'abdomen', 'quads', 'glutes', 'hamstrings', 'calves'
];

const List<String> kDifficulties = ['Beginner', 'Intermediate', 'Advanced'];

const List<String> kEquipment = [
  'Barbell', 'Dumbbell', 'Cable', 'Machine', 'Bodyweight', 'Weighted', 'Band', 'Kettlebell', 'Rings', 'Other'
];

const List<String> kFilterEquipment = [
  'Bodyweight', 'Dumbbell', 'Barbell', 'Machine', 'Cable', 'Band', 'Kettlebell', 'Rings', 'Weighted'
];

const Set<String> kNeedsKit = {
  '9WTm7dq', 'lBDjFxJ', 'T2mxWqc', 'X6C6i5Y', '72BC5Za', 'dead-hang-hold', 'mExgrF9', 'neutral-grip-pull-up',
  'active-hang', 'negative-pull-up', 'commando-pull-up', 'l-sit-pull-up', 'towel-pull-up', 'uWpxD4v',
  'l-sit-hold', '7xeukSt', 'uTBt1HV', 'TFqbd8t', 'XVDdcoj', 'vertical-row', 'prone-t-raise',
  'reverse-snow-angel', 'decline-push-up', 'seal-jack', 'feet-elevated-pike-push-up', 'handstand-push-up',
  'dragon-flag', 'mweqJin', 'VO2qeJg', 'xdYPUtE', '9E25EOx', 'assisted-pistol-squat', 'single-leg-box-squat',
  'RrLske5', 'u27Kcdz', 'clamshell', 'hip-airplane', 'bJYHBIN', 'iPm26QU', 'u5ESqzH', '0jp9Rlz', 'LNE3wfo',
  'nordic-curl', 'C5jncD2', 'lying-hamstring-walkout', 'hamstring-stretch', 'outdoor-run', 'outdoor-walk',
  'outdoor-hike', 'arch-hang', 'parallel-bar-support-hold', 'negative-dip', 'assisted-squat',
  'bulgarian-split-squat', 'bench-leg-raise', 'incline-row', 'wide-row',
};

const List<String> kWarmupIds = [
  'jumping-jack', 'high-knees', 'cat-cow-stretch', 'worlds-greatest-stretch', 'leg-swings-stretch', 'inchworm',
  'QChZi3x', 'scapular-push-up', 'hip-airplane', 'glute-bridge', 'bird-dog', 'dead-bug', 'fire-hydrant',
  'clamshell', 'kneeling-hip-flexor-stretch', 'BbfB8Gb', '6YUfHPL', 'jump-rope', 'band-pull-apart',
  'yuris-shoulder-band-warmup', 'wrist-prep',
];

const Set<String> kStretchIds = {
  'cat-cow-stretch', 'worlds-greatest-stretch', 'leg-swings-stretch', 'childs-pose', 'doorway-chest-stretch',
  'cross-body-shoulder-stretch', 'standing-quad-stretch', 'kneeling-hip-flexor-stretch', 'butterfly-stretch',
  'wall-calf-stretch', 'LNE3wfo', 'hamstring-stretch', 'seated-forward-fold-stretch',
  'yuris-shoulder-band-warmup', 'wrist-prep',
};

const Set<String> kCalisthenicsEquipment = {'Bodyweight', 'Rings', 'Weighted'};

const Set<String> kCardioExtras = {
  'jump-rope', 'battle-ropes', 'burpee', 'half-burpee', 'mountain-climber', 'high-knees', 'jumping-jack',
  'skater-hop', 'squat-thrust', 'sprawl', 'lateral-shuffle', 'plank-jack',
};

const List<List<String>> kProgressions = [
  ['wall-push-up', 'incline-push-up', 'knee-push-up', 'I4hDWkc', 'x6KpKpq', 'decline-push-up', 'A9qxk2F',
    'pseudo-planche-push-up'],
  ['vertical-row', 'incline-row', 'mExgrF9', 'wide-row', 'weighted-inverted-row'],
  ['assisted-squat', '6YUfHPL', '9E25EOx', 'bulgarian-split-squat', 'beginner-shrimp-squat',
    'intermediate-shrimp-squat', 'shrimp-squat', 'weighted-shrimp-squat'],
  ['bodyweight-romanian-deadlift', 'bodyweight-single-leg-deadlift', 'banded-nordic-curl-negative',
    'banded-nordic-curl', 'nordic-curl'],
  ['negative-dip', '9WTm7dq', 'bZq4bwK'],
  ['uTBt1HV', 'negative-pull-up', 'lBDjFxJ', 'HMzLjXx'],
];

const Set<String> kSlowReps = {
  'negative-dip', 'negative-pull-up', 'banded-nordic-curl-negative', 'banded-nordic-curl', 'nordic-curl',
};

String? nextStepOf(String id) {
  for (final chain in kProgressions) {
    final at = chain.indexOf(id);
    if (at >= 0 && at + 1 < chain.length) return chain[at + 1];
  }
  return null;
}

bool isNoKit(Exercise ex) => ex.equipment == 'Bodyweight' && !kNeedsKit.contains(ex.id);

const Map<String, String> kExerciseModes = {
  'running': 'cardio',
  'walking': 'cardio',
  'treadmill-incline-walk': 'cardio',
  'cycling': 'cardio',
  'assault-bike': 'cardio',
  'elliptical': 'cardio',
  'rowing': 'cardio',
  'stair-climber': 'cardio',
  'skierg': 'cardio',
  'jump-rope': 'time',
  'battle-ropes': 'time',
  'VBAWRPG': 'time',
  'active-hang': 'time',
  'superman-hold': 'time',
  'cable-pallof-hold': 'time',
  'hollow-body-hold': 'time',
  'bear-plank': 'time',
  'l-sit-hold': 'time',
  'wall-sit': 'time',
  'kettlebell-farmer-carry': 'time',
  'rNGclsi': 'time',
  'rNGdsup': 'time',
  'cat-cow-stretch': 'time',
  'doorway-chest-stretch': 'time',
  'cross-body-shoulder-stretch': 'time',
  'childs-pose': 'time',
  'standing-quad-stretch': 'time',
  'kneeling-hip-flexor-stretch': 'time',
  'butterfly-stretch': 'time',
  'wall-calf-stretch': 'time',
  'hamstring-stretch': 'time',
  'hiking': 'cardio',
  'plank-hold': 'time',
  'side-plank-hold': 'time',
  'dead-hang-hold': 'time',
  'outdoor-run': 'cardio',
  'outdoor-cycling': 'cardio',
  'outdoor-walk': 'cardio',
  'outdoor-hike': 'cardio',
  'swim': 'cardio',
  'arch-hang': 'time',
  'parallel-bar-support-hold': 'time',
};
