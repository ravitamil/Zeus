import 'package:flutter_test/flutter_test.dart';
import 'package:zeus/app/gymmane_app.dart';
import 'package:zeus/l10n/l10n.dart';
import 'package:zeus/models/exercise.dart';
import 'package:zeus/state/fit_state.dart';
import 'package:zeus/widgets/ui_kit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    fit.onboarded = true;
    fit.routines.clear();
  });

  tearDown(() {
    fit.persistNow();
  });

  testWidgets('Routine with exercises shows Add Exercise button alone and not all exercises inline', (tester) async {
    final benchId = fit.allExercises.firstWhere((e) => e.name.contains('Bench Press')).id;
    final rId = fit.createRoutine('Chest Day');
    final routine = fit.routines.firstWhere((r) => r.id == rId);
    routine.exerciseIds.add(benchId);

    // Pick an exercise that is visible at the top of the catalog but not yet in the routine
    final candidate = fit.exercisesMatching('').firstWhere((e) => e.id != benchId);
    final candidateName = exerciseName(candidate);

    fit.openRoutine(rId);

    await tester.pumpWidget(const GymManeApp());
    await tester.pumpAndSettle();

    // The routine exercise should be displayed
    expect(find.text(exerciseName(fit.exerciseById(benchId)!)), findsOneWidget);

    // The Add Exercise GhostButton should be present alone
    expect(find.widgetWithText(GhostButton, titleCase(t.addExercise)), findsOneWidget);

    // Other catalog exercises (like candidate) should NOT be displayed on the routine screen
    expect(find.text(candidateName), findsNothing);

    // Tapping the Add Exercise button opens the exercise picker sheet
    await tester.tap(find.widgetWithText(GhostButton, titleCase(t.addExercise)));
    await tester.pumpAndSettle();

    // The picker sheet is now open and shows search exercises hint
    expect(find.text(t.searchExercises), findsOneWidget);

    // In the picker sheet, candidate is visible
    expect(find.text(candidateName), findsOneWidget);

    // Tap candidate to add it to the routine
    await tester.tap(find.text(candidateName));
    await tester.pumpAndSettle();

    expect(routine.exerciseIds.contains(candidate.id), isTrue);

    // Tap Done to close the picker sheet
    await tester.tap(find.text(t.done).last);
    await tester.pumpAndSettle();

    // Now back on Routine screen, both Bench Press and candidate are displayed!
    expect(find.text(exerciseName(fit.exerciseById(benchId)!)), findsOneWidget);
    expect(find.text(candidateName), findsOneWidget);
    // And the Add Exercise button is still alone below them
    expect(find.widgetWithText(GhostButton, titleCase(t.addExercise)), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 500));
  });

  testWidgets('Empty routine displays clean empty state with Add Exercise button', (tester) async {
    final rId = fit.createRoutine('New Empty Routine');
    fit.openRoutine(rId);

    await tester.pumpWidget(const GymManeApp());
    await tester.pumpAndSettle();

    // Shows Add Exercise button
    expect(find.widgetWithText(GhostButton, titleCase(t.addExercise)), findsOneWidget);

    // Shows Save button at the bottom
    expect(find.widgetWithText(PrimaryButton, t.save), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 500));
  });
}
