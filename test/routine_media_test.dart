import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zeus/app/gymmane_app.dart';
import 'package:zeus/l10n/l10n.dart';
import 'package:zeus/models/exercise.dart';
import 'package:zeus/services/local_store.dart';
import 'package:zeus/state/fit_state.dart';
import 'package:zeus/widgets/exercise_media.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const exercise = Exercise(
    id: 'custom-preview-regression',
    name: 'Preview regression exercise',
    primary: 'chest',
    secondary: [],
    equipment: 'Bodyweight',
    difficulty: 'Beginner',
    art: '',
    steps: ['Preview instructions'],
  );

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await Store.instance.init();
    fit.resetAllData();
    setAppLanguage('en');
    fit.onboarded = true;
    fit.customExercises.add(exercise);
    final id = fit.createRoutine('Preview routine');
    fit.toggleRoutineExercise(id, exercise.id);
    fit.openRoutine(id);
  });

  tearDown(() => fit.persistNow());

  testWidgets('routine thumbnail opens exercise preview instead of set planner', (tester) async {
    await tester.pumpWidget(const GymManeApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byType(ExerciseMedia).first);
    await tester.pumpAndSettle();

    expect(find.text('Preview instructions'), findsOneWidget);
    expect(find.text(t.planSetsHint), findsNothing);
    await tester.tap(find.bySemanticsLabel('Close'));
    await tester.pumpAndSettle();
    expect(find.text('Preview instructions'), findsNothing);
  });

  testWidgets('routine exercise title still opens set planner', (tester) async {
    await tester.pumpWidget(const GymManeApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text(exercise.name));
    await tester.pumpAndSettle();

    expect(find.text(t.planSetsHint), findsOneWidget);
    expect(find.text('Preview instructions'), findsNothing);
    await tester.tap(find.text(t.done));
    await tester.pumpAndSettle();
  });
}
