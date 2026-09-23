import 'package:flutter_test/flutter_test.dart';
import 'package:zeus/catalog/exercise_catalog.dart';
import 'package:zeus/catalog/exercise_categories.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await ExerciseCatalog.init();
  });

  test('all 13 muscle categories have icons and match exercises', () {
    expect(kMuscleCategories.length, 13);
    for (final cat in kMuscleCategories) {
      expect(cat.isMuscle, true);
      expect(cat.iconAsset.isNotEmpty, true);
      final count = kExercises.where(cat.matches).length;
      expect(count, greaterThan(0), reason: '${cat.name} should match exercises');
    }
  });

  test('all 23 equipment categories have icons and match exercises', () {
    expect(kEquipmentCategories.length, 23);
    for (final cat in kEquipmentCategories) {
      expect(cat.isEquipment, true);
      expect(cat.iconAsset.isNotEmpty, true);
      final count = kExercises.where(cat.matches).length;
      expect(count, greaterThan(0), reason: '${cat.name} should match exercises');
    }
  });
}
