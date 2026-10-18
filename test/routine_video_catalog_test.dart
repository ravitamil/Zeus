import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:zeus/catalog/exercise_catalog.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('routine video mappings resolve to the demonstrated exercise and bundled files', () async {
    await ExerciseCatalog.init();
    const expected = {
      '0184': '1677_Dumbbell_Seated_Lateral_Raise',
      '0493': '0043_Dumbbell_One_Arm_Bent-over_Row',
      '1133': '0228_Cable_Curl',
      '6YUfHPL': '0162_Squat',
      'NNoHCEA': '0704_Smith_Low_Bar_Squat',
      'reverse-grip-lat-pulldown': '0458_Cable_Reverse_Grip_Pulldown',
      'rope-tricep-pushdown': '0002_Triceps_Pushdown',
    };

    for (final entry in expected.entries) {
      final exercise = kExercises.singleWhere((exercise) => exercise.id == entry.key);
      final video = exercise.videoPath;
      expect(video, 'assets/videos/${entry.value}.mp4', reason: exercise.name);
      expect(File(video).existsSync(), isTrue, reason: exercise.name);
      expect(File('assets/thumbnails/${entry.value}.webp').existsSync(), isTrue, reason: exercise.name);
    }
  });
}
