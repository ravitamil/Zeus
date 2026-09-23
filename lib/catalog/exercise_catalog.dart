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

const Map<String, String> kExerciseModes = {
  'running': 'cardio',
  'walking': 'cardio',
  'treadmill-incline-walk': 'cardio',
  'cycling': 'cardio',
  'assault-bike': 'cardio',
  'elliptical': 'cardio',
  'rowing': 'cardio',
  'stair-climber': 'cardio',
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
