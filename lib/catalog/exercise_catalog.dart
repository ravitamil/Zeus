import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import '../models/exercise.dart';

List<Exercise>? _cachedExercises;

List<Exercise> get kExercises {
  if (_cachedExercises != null && _cachedExercises!.isNotEmpty) {
    return _cachedExercises!;
  }
  _cachedExercises = _loadExercisesSyncFallback();
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
      final list = jsonDecode(jsonStr) as List;
      _cachedExercises = list.map((e) => Exercise.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      _cachedExercises = _loadExercisesSyncFallback();
    }
  }
}

const List<ToolMeta> kToolMeta = [
  ToolMeta('rm', '1RM', 'Estimated one-rep max'),
  ToolMeta('bmr', 'BMR', 'Basal metabolic rate'),
  ToolMeta('bmi', 'BMI', 'Body mass index'),
  ToolMeta('cal', 'Calories', 'Calories & macros'),
  ToolMeta('bf', 'Body Fat', 'Body fat percentage'),
  ToolMeta('plate', 'Plates', 'Barbell plate calculator'),
  ToolMeta('warmup', 'Warm-up', 'Ramp-up sets'),
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
  '9WTm7dq', 'lBDjFxJ', 'T2mxWqc', 'X6C6i5Y', '72BC5Za', 'GaSzzuh', 'mExgrF9', 'neutral-grip-pull-up',
  'active-hang', 'negative-pull-up', 'commando-pull-up', 'l-sit-pull-up', 'towel-pull-up', 'XgWyAiA',
  'LQFOrMn', 'uWpxD4v', 'PXTIwgu', 'l-sit-hold', '50BETrz', 'guT8YnS', '7xeukSt', 'uTBt1HV', 'dead-hang-hold',
  'TFqbd8t', 'XVDdcoj', '3xK09Sk', 'v2DfH14', 'tig3PXb', 'xbkPfaw', 'prone-t-raise', 'reverse-snow-angel',
  'decline-push-up', 'seal-jack', 'feet-elevated-pike-push-up', 'handstand-push-up', '2gPfomN', 'Hy9D21L',
  'NAkmgdx', 'dragon-flag', 'mweqJin', 'VO2qeJg', 'xdYPUtE', '9E25EOx', 'assisted-pistol-squat', 'shrimp-squat',
  'single-leg-box-squat', 'sJFIDIp', 'gscGLOU', 'RrLske5', '9RT8oQW', 'u27Kcdz', '6sYyrRX', 'clamshell',
  'hip-airplane', 'bJYHBIN', 'iPm26QU', 'u5ESqzH', '0jp9Rlz', 'LNE3wfo', 'GwYwElT', 'C5jncD2',
  'lying-hamstring-walkout', 'hamstring-stretch', 'outdoor-run', 'outdoor-walk', 'outdoor-hike',
};

const List<String> kWarmupIds = [
  'jumping-jack', 'high-knees', 'cat-cow-stretch', 'worlds-greatest-stretch', 'leg-swings-stretch', 'inchworm',
  'QChZi3x', 'scapular-push-up', 'hip-airplane', 'glute-bridge', 'bird-dog', 'dead-bug', 'fire-hydrant',
  'clamshell', 'kneeling-hip-flexor-stretch', 'RtyAsy1', '5BZHW9s', '6YUfHPL', 'jump-rope', 'band-pull-apart',
];

const Set<String> kCardioExtras = {
  'jump-rope', 'battle-ropes', 'burpee', 'half-burpee', 'mountain-climber', 'high-knees', 'jumping-jack',
  'skater-hop', 'squat-thrust', 'sprawl', 'lateral-shuffle', 'plank-jack',
};

bool isNoKit(Exercise ex) {
  if (ex.equipment != 'Bodyweight') return false;
  if (kNeedsKit.contains(ex.id)) return false;
  final n = ex.name.toLowerCase();
  if (n.contains('pull-up') ||
      n.contains('chin-up') ||
      n.contains('inverted row') ||
      n.contains('hang') ||
      n.contains('dip')) {
    return false;
  }
  return true;
}

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
  '5VXmnV5': 'time',
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
};
