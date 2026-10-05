import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:zeus/app/gymmane_app.dart';
import 'package:zeus/catalog/exercise_catalog.dart';
import 'package:zeus/l10n/l10n.dart';
import 'package:zeus/models/exercise.dart';
import 'package:zeus/screens/exercises_screen.dart';
import 'package:zeus/services/local_store.dart';
import 'package:zeus/state/fit_state.dart';
import 'package:zeus/theme/app_theme.dart';
import 'package:zeus/widgets/video_playback.dart';

class _Controller extends VideoPlayerController {
  _Controller() : super.asset('test.mp4');
  int plays = 0;
  int pauses = 0;

  void ready() => value = value.copyWith(isInitialized: true, duration: const Duration(seconds: 10));

  @override
  Future<void> play() async {
    plays++;
  }

  @override
  Future<void> pause() async {
    pauses++;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    setAppLanguage('en');
  });

  test('background catalog initialization preserves base IDs and media', () async {
    await ExerciseCatalog.init();
    final exercises = kExercises;
    expect(exercises.length, greaterThan(kBaseExercises.length));
    expect(exercises.any((ex) => ex.videoPath.startsWith('assets/videos/')), isTrue);
    for (final ex in kBaseExercises) {
      expect(exercises.any((entry) => entry.id == ex.id), isTrue);
    }
  });

  test('catalog, lookup and filters reuse work across unrelated updates', () {
    final state = FitState();
    final all = state.allExercises;
    final results = state.exercisesMatching('press');
    state.setExSearch('press');
    expect(identical(state.allExercises, all), isTrue);
    expect(identical(state.exercisesFiltered, results), isTrue);
    expect(state.exerciseById(all.first.id), same(all.first));
    expect(results, isNotEmpty);
  });

  test('filter cache reflects favorite and archive mutations', () {
    final state = FitState();
    final ex = state.allExercises.first;
    state.exFavouritesOnly = true;
    expect(state.exercisesFiltered, isEmpty);
    state.favorites[ex.id] = true;
    expect(state.exercisesFiltered, contains(ex));
    state.archived.add(ex.id);
    expect(state.exercisesFiltered, isEmpty);
    state.exArchivedOnly = true;
    expect(state.exercisesFiltered, contains(ex));
  });

  test('replacing a custom exercise invalidates lookup and search', () {
    final state = FitState();
    final ex = Exercise.fromJson({
      ...kBaseExercises.first.toJson(),
      'id': 'custom-test',
      'n': 'Unique old exercise',
    });
    state.customExercises.add(ex);
    expect(state.exercisesMatching('Unique old'), contains(ex));
    final changed = ex.copyWith(name: 'Unique new exercise');
    state.customExercises[0] = changed;
    expect(state.exerciseById(ex.id), same(changed));
    expect(state.exercisesMatching('Unique old'), isEmpty);
    expect(state.exercisesMatching('Unique new'), contains(changed));
  });

  test('localized search and filter changes invalidate cached results', () {
    final state = FitState();
    final first = state.exercisesMatching('squat');
    state.exMuscleFilter = 'chest';
    expect(identical(state.exercisesMatching('squat'), first), isFalse);
    state.exMuscleFilter = null;
    state.setLanguage('es');
    expect(identical(state.exercisesMatching('squat'), first), isFalse);
    expect(state.exercisesMatching('sentadilla'), isNotEmpty);
    state.persistNow();
  });

  test('changing place equipment invalidates cached place results', () {
    final state = FitState();
    final id = state.addPlace('Home', equipment: {'Dumbbell'});
    state.activePlaceId = id;
    final first = state.exercisesFiltered;
    expect(state.exercisesFiltered, same(first));
    expect(first.any((ex) => ex.equipment == 'Barbell'), isFalse);
    state.togglePlaceGear(id, 'Barbell');
    expect(state.exercisesFiltered.any((ex) => ex.equipment == 'Barbell'), isTrue);
    state.persistNow();
  });

  testWidgets('typing is debounced without notifying the whole app', (tester) async {
    fit.exSearch = '';
    fit.clearExFilters();
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: const Scaffold(body: ExercisesScreen()),
      ),
    );
    var notifications = 0;
    void listener() {
      notifications++;
    }

    fit.addListener(listener);
    try {
      await tester.enterText(find.byType(TextField).first, 'squa');
      await tester.pump(const Duration(milliseconds: 100));
      expect(fit.exSearch, isEmpty);
      await tester.enterText(find.byType(TextField).first, 'squat');
      await tester.pump(const Duration(milliseconds: 180));
      expect(fit.exSearch, 'squat');
      expect(notifications, 0);
      await tester.enterText(find.byType(TextField).first, '');
      expect(fit.exSearch, isEmpty);
      await tester.pumpWidget(const SizedBox());
    } finally {
      fit.removeListener(listener);
    }
  });

  testWidgets('unrelated state updates preserve the theme instance', (tester) async {
    await Store.instance.init();
    fit.onboarded = true;
    fit.route = 'exercises';
    await tester.pumpWidget(const GymManeApp());
    final before = tester.widget<MaterialApp>(find.byType(MaterialApp)).theme;
    fit.setExSearch('press');
    await tester.pump();
    expect(tester.widget<MaterialApp>(find.byType(MaterialApp)).theme, same(before));
    fit.setAccentColor(const Color(0xFF00AA00));
    await tester.pump();
    expect(tester.widget<MaterialApp>(find.byType(MaterialApp)).theme, isNot(same(before)));
    await tester.pumpWidget(const SizedBox());
    fit.persistNow();
  });

  testWidgets('offscreen and covered demos pause and resume', (tester) async {
    final controller = _Controller()..ready();
    final scroll = ScrollController();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            controller: scroll,
            child: Column(
              children: [
                VideoPlayback(controller: controller, child: const SizedBox(height: 200, width: 200)),
                const SizedBox(height: 1800),
              ],
            ),
          ),
        ),
      ),
    );
    expect(controller.plays, 1);
    final resume = suspendExerciseVideos();
    expect(controller.pauses, 1);
    resume();
    expect(controller.plays, 2);
    scroll.jumpTo(900);
    await tester.pump();
    expect(controller.pauses, 2);
    scroll.jumpTo(0);
    await tester.pump();
    expect(controller.plays, 3);
    await tester.pumpWidget(const SizedBox());
    scroll.dispose();
  });

  testWidgets('covered demos do not start when initialization finishes late', (tester) async {
    final controller = _Controller();
    await tester.pumpWidget(
      MaterialApp(
        home: VideoPlayback(controller: controller, child: const SizedBox(height: 200, width: 200)),
      ),
    );
    final resume = suspendExerciseVideos();
    controller.ready();
    expect(controller.plays, 0);
    resume();
    expect(controller.plays, 1);
    await tester.pumpWidget(const SizedBox());
  });
}
