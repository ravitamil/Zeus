import '../models/exercise.dart';

enum CategoryKind { muscle, equipment }

class CategoryItem {
  const CategoryItem({
    required this.id,
    required this.name,
    required this.iconAsset,
    required this.kind,
  });

  final String id;
  final String name;
  final String iconAsset;
  final CategoryKind kind;

  bool get isMuscle => kind == CategoryKind.muscle;
  bool get isEquipment => kind == CategoryKind.equipment;

  bool matches(Exercise ex) {
    if (isMuscle) {
      return _matchesMuscle(ex, id);
    } else {
      return _matchesEquipment(ex, id);
    }
  }

  static bool _matchesMuscle(Exercise ex, String muscleId) {
    final p = ex.primary.toLowerCase();
    final s = ex.secondary.map((e) => e.toLowerCase()).toList();
    final name = ex.name.toLowerCase();

    switch (muscleId) {
      case 'chest':
        return p == 'chest' || s.contains('chest');
      case 'biceps':
        return p == 'biceps' || s.contains('biceps');
      case 'triceps':
        return p == 'triceps' || s.contains('triceps');
      case 'back':
        return p == 'back' ||
            p == 'trapezius' ||
            s.contains('back') ||
            s.contains('trapezius') ||
            s.contains('lats');
      case 'shoulders':
        return p == 'shoulders' || s.contains('shoulders') || name.contains('deltoid');
      case 'abs':
        return p == 'abdomen' ||
            p == 'obliques' ||
            s.contains('abdomen') ||
            s.contains('obliques') ||
            s.contains('abs') ||
            name.contains('crunch') ||
            name.contains('plank');
      case 'quadriceps_femoris':
        return p == 'quads' || s.contains('quads') || name.contains('quad');
      case 'hamstrings':
        return p == 'hamstrings' || s.contains('hamstrings');
      case 'hips':
        return p == 'glutes' ||
            s.contains('glutes') ||
            name.contains('hip') ||
            name.contains('glute');
      case 'calves':
        return p == 'calves' || s.contains('calves');
      case 'forearms':
        return p == 'forearm' || s.contains('forearm') || s.contains('forearms');
      case 'neck':
        return name.contains('neck') || p == 'neck' || s.contains('neck');
      case 'cardio':
        return ex.mode == 'cardio' ||
            name.contains('run') ||
            name.contains('treadmill') ||
            name.contains('bike') ||
            name.contains('cycle') ||
            name.contains('rowing') ||
            name.contains('cardio') ||
            name.contains('walk') ||
            name.contains('jumping jack') ||
            name.contains('elliptical');
      default:
        return p == muscleId || s.contains(muscleId);
    }
  }

  static bool _matchesEquipment(Exercise ex, String eqId) {
    final eq = ex.equipment.toLowerCase();
    final name = ex.name.toLowerCase();
    final v = ex.videoPath.toLowerCase();

    switch (eqId) {
      case 'barbell':
        return (eq == 'barbell' || name.contains('barbell')) &&
            !name.contains('ez') &&
            !v.contains('ez') &&
            !name.contains('trap bar') &&
            !v.contains('trap_bar') &&
            !name.contains('smith');
      case 'dumbbell':
        return eq == 'dumbbell' || name.contains('dumbbell');
      case 'bodyweight':
        return eq == 'bodyweight' &&
            !name.contains('suspension') &&
            !name.contains('suspended') &&
            !name.contains('band') &&
            !name.contains('ball') &&
            !name.contains('roller') &&
            !name.contains('rope');
      case 'kettlebell':
        return eq == 'kettlebell' || name.contains('kettlebell');
      case 'ez_bar':
        return name.contains('ez') || v.contains('ez');
      case 'trap_bar':
        return name.contains('trap bar') || v.contains('trap_bar');
      case 'cable':
        return eq == 'cable' || name.contains('cable');
      case 'leverage_machine':
        return name.contains('lever') || v.contains('lever') || name.contains('leverage');
      case 'sled_machine':
        return (name.contains('sled') || v.contains('sled')) &&
            !name.contains('power sled') &&
            !v.contains('power_sled');
      case 'smith_machine':
        return name.contains('smith') || v.contains('smith');
      case 'power_sled':
        return name.contains('power sled') || v.contains('power_sled');
      case 'weighted':
        return eq == 'weighted' || name.contains('weighted') || v.contains('weighted');
      case 'resistance_band':
        return name.contains('resistance band') || v.contains('resistance_band');
      case 'band':
        return (eq == 'band' || name.contains('band') || v.contains('band')) &&
            !name.contains('resistance band') &&
            !v.contains('resistance_band');
      case 'suspension':
        return name.contains('suspension') ||
            name.contains('suspended') ||
            v.contains('suspension') ||
            v.contains('suspended') ||
            v.contains('straps');
      case 'medicine_ball':
        return name.contains('medicine ball') || v.contains('medicine_ball');
      case 'battle_rope':
        return name.contains('battle rope') ||
            name.contains('battling rope') ||
            v.contains('battle_rope') ||
            ex.art == 'battle-ropes';
      case 'ab_roller':
        return name.contains('roller') ||
            name.contains('rollout') ||
            v.contains('wheel_rollout') ||
            ex.art == 'ab-wheel';
      case 'jump_rope':
        return name.contains('jump rope') || v.contains('jump_rope') || ex.id == 'jump-rope';
      case 'stability_ball':
        return name.contains('stability ball') ||
            name.contains('exercise ball') ||
            v.contains('stability_ball') ||
            v.contains('exercise_ball');
      case 'roll':
        return (name.contains('foam roll') || v.contains('roll_') || name.startsWith('roll ')) &&
            !v.contains('roll_ball') &&
            !name.contains('roller');
      case 'roller_ball':
        return v.contains('roll_ball') ||
            name.contains('roller ball') ||
            name.contains('massage ball');
      case 'bosu_ball':
        return name.contains('bosu') || v.contains('bosu');
      default:
        return eq == eqId || name.contains(eqId);
    }
  }
}

const List<CategoryItem> kMuscleCategories = [
  CategoryItem(
    id: 'chest',
    name: 'Chest',
    iconAsset: 'assets/icons/categories/muscles/chest.png',
    kind: CategoryKind.muscle,
  ),
  CategoryItem(
    id: 'biceps',
    name: 'Biceps',
    iconAsset: 'assets/icons/categories/muscles/biceps.png',
    kind: CategoryKind.muscle,
  ),
  CategoryItem(
    id: 'triceps',
    name: 'Triceps',
    iconAsset: 'assets/icons/categories/muscles/triceps.png',
    kind: CategoryKind.muscle,
  ),
  CategoryItem(
    id: 'back',
    name: 'Back',
    iconAsset: 'assets/icons/categories/muscles/back.png',
    kind: CategoryKind.muscle,
  ),
  CategoryItem(
    id: 'shoulders',
    name: 'Shoulders',
    iconAsset: 'assets/icons/categories/muscles/shoulders.png',
    kind: CategoryKind.muscle,
  ),
  CategoryItem(
    id: 'abs',
    name: 'Abs',
    iconAsset: 'assets/icons/categories/muscles/abs.png',
    kind: CategoryKind.muscle,
  ),
  CategoryItem(
    id: 'quadriceps_femoris',
    name: 'Quadriceps femoris',
    iconAsset: 'assets/icons/categories/muscles/quadriceps_femoris.png',
    kind: CategoryKind.muscle,
  ),
  CategoryItem(
    id: 'hamstrings',
    name: 'Hamstrings',
    iconAsset: 'assets/icons/categories/muscles/hamstrings.png',
    kind: CategoryKind.muscle,
  ),
  CategoryItem(
    id: 'hips',
    name: 'Hips',
    iconAsset: 'assets/icons/categories/muscles/hips.png',
    kind: CategoryKind.muscle,
  ),
  CategoryItem(
    id: 'calves',
    name: 'Calves',
    iconAsset: 'assets/icons/categories/muscles/calves.png',
    kind: CategoryKind.muscle,
  ),
  CategoryItem(
    id: 'forearms',
    name: 'Forearms',
    iconAsset: 'assets/icons/categories/muscles/forearms.png',
    kind: CategoryKind.muscle,
  ),
  CategoryItem(
    id: 'neck',
    name: 'Neck',
    iconAsset: 'assets/icons/categories/muscles/neck.png',
    kind: CategoryKind.muscle,
  ),
  CategoryItem(
    id: 'cardio',
    name: 'Cardio',
    iconAsset: 'assets/icons/categories/muscles/cardio.png',
    kind: CategoryKind.muscle,
  ),
];

const List<CategoryItem> kEquipmentCategories = [
  CategoryItem(
    id: 'barbell',
    name: 'Barbell',
    iconAsset: 'assets/icons/categories/equipment/barbell.png',
    kind: CategoryKind.equipment,
  ),
  CategoryItem(
    id: 'dumbbell',
    name: 'Dumbbell',
    iconAsset: 'assets/icons/categories/equipment/dumbbell.png',
    kind: CategoryKind.equipment,
  ),
  CategoryItem(
    id: 'bodyweight',
    name: 'Bodyweight',
    iconAsset: 'assets/icons/categories/equipment/bodyweight.png',
    kind: CategoryKind.equipment,
  ),
  CategoryItem(
    id: 'kettlebell',
    name: 'Kettlebell',
    iconAsset: 'assets/icons/categories/equipment/kettlebell.png',
    kind: CategoryKind.equipment,
  ),
  CategoryItem(
    id: 'ez_bar',
    name: 'EZ bar',
    iconAsset: 'assets/icons/categories/equipment/ez_bar.png',
    kind: CategoryKind.equipment,
  ),
  CategoryItem(
    id: 'trap_bar',
    name: 'Trap bar',
    iconAsset: 'assets/icons/categories/equipment/trap_bar.png',
    kind: CategoryKind.equipment,
  ),
  CategoryItem(
    id: 'cable',
    name: 'Cable',
    iconAsset: 'assets/icons/categories/equipment/cable.png',
    kind: CategoryKind.equipment,
  ),
  CategoryItem(
    id: 'leverage_machine',
    name: 'Leverage machine',
    iconAsset: 'assets/icons/categories/equipment/leverage_machine.png',
    kind: CategoryKind.equipment,
  ),
  CategoryItem(
    id: 'sled_machine',
    name: 'Sled machine',
    iconAsset: 'assets/icons/categories/equipment/sled_machine.png',
    kind: CategoryKind.equipment,
  ),
  CategoryItem(
    id: 'smith_machine',
    name: 'Smith machine',
    iconAsset: 'assets/icons/categories/equipment/smith_machine.png',
    kind: CategoryKind.equipment,
  ),
  CategoryItem(
    id: 'power_sled',
    name: 'Power sled',
    iconAsset: 'assets/icons/categories/equipment/power_sled.png',
    kind: CategoryKind.equipment,
  ),
  CategoryItem(
    id: 'weighted',
    name: 'Weighted',
    iconAsset: 'assets/icons/categories/equipment/weighted.png',
    kind: CategoryKind.equipment,
  ),
  CategoryItem(
    id: 'resistance_band',
    name: 'Resistance band',
    iconAsset: 'assets/icons/categories/equipment/resistance_band.png',
    kind: CategoryKind.equipment,
  ),
  CategoryItem(
    id: 'band',
    name: 'Band',
    iconAsset: 'assets/icons/categories/equipment/band.png',
    kind: CategoryKind.equipment,
  ),
  CategoryItem(
    id: 'suspension',
    name: 'Suspension',
    iconAsset: 'assets/icons/categories/equipment/suspension.png',
    kind: CategoryKind.equipment,
  ),
  CategoryItem(
    id: 'medicine_ball',
    name: 'Medicine ball',
    iconAsset: 'assets/icons/categories/equipment/medicine_ball.png',
    kind: CategoryKind.equipment,
  ),
  CategoryItem(
    id: 'battle_rope',
    name: 'Battle rope',
    iconAsset: 'assets/icons/categories/equipment/battle_rope.png',
    kind: CategoryKind.equipment,
  ),
  CategoryItem(
    id: 'ab_roller',
    name: 'Ab roller',
    iconAsset: 'assets/icons/categories/equipment/ab_roller.png',
    kind: CategoryKind.equipment,
  ),
  CategoryItem(
    id: 'jump_rope',
    name: 'Jump rope',
    iconAsset: 'assets/icons/categories/equipment/jump_rope.png',
    kind: CategoryKind.equipment,
  ),
  CategoryItem(
    id: 'stability_ball',
    name: 'Stability ball',
    iconAsset: 'assets/icons/categories/equipment/stability_ball.png',
    kind: CategoryKind.equipment,
  ),
  CategoryItem(
    id: 'roll',
    name: 'Roll',
    iconAsset: 'assets/icons/categories/equipment/roll.png',
    kind: CategoryKind.equipment,
  ),
  CategoryItem(
    id: 'roller_ball',
    name: 'Roller ball',
    iconAsset: 'assets/icons/categories/equipment/roller_ball.png',
    kind: CategoryKind.equipment,
  ),
  CategoryItem(
    id: 'bosu_ball',
    name: 'BOSU ball',
    iconAsset: 'assets/icons/categories/equipment/bosu_ball.png',
    kind: CategoryKind.equipment,
  ),
];

CategoryItem? categoryById(String id) {
  for (final c in kMuscleCategories) {
    if (c.id == id) return c;
  }
  for (final c in kEquipmentCategories) {
    if (c.id == id) return c;
  }
  return null;
}
