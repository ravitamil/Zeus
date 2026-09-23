import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zeus/state/fit_state.dart';
import 'package:zeus/theme/app_colors.dart';
import 'package:zeus/theme/app_theme.dart';
import 'package:zeus/widgets/accent_color_picker.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Accent Color Theme & Adaptation', () {
    test('Default accent color is signature terracotta', () {
      final darkDefault = GymColors.withAccent(null, isDark: true);
      expect(darkDefault.accent, const Color(0xFFD9A184));
      expect(darkDefault.accentSoft, const Color(0x29D9A184));

      final lightDefault = GymColors.withAccent(null, isDark: false);
      expect(lightDefault.accent, const Color(0xFF9E4E27));
      expect(lightDefault.accentSoft, const Color(0x1F9E4E27));
    });

    test('Custom accent color overrides GymColors accent and accentSoft', () {
      const customViolet = Color(0xFF7C3AED);

      final dark = GymColors.withAccent(customViolet, isDark: true);
      expect(dark.accent, customViolet);
      expect(dark.accentSoft, customViolet.withValues(alpha: 0.20));

      final light = GymColors.withAccent(customViolet, isDark: false);
      expect(light.accent, customViolet);
      expect(light.accentSoft, customViolet.withValues(alpha: 0.16));
    });

    test('Luminance adaptation handles extreme values', () {
      // Extremely dark color in dark mode should be lightened for contrast
      const nearBlack = Color(0xFF050505);
      final adaptedDark = GymColors.adaptAccent(nearBlack, true);
      expect(adaptedDark, const Color(0xFFF2F2F2));

      // Extremely light color in light mode should be darkened for contrast
      const nearWhite = Color(0xFFFAFAFA);
      final adaptedLight = GymColors.adaptAccent(nearWhite, false);
      expect(adaptedLight, const Color(0xFF1C1C1E));

      // Mid-range color passes through untouched
      const emerald = Color(0xFF10B981);
      expect(GymColors.adaptAccent(emerald, true), emerald);
      expect(GymColors.adaptAccent(emerald, false), emerald);
    });

    test('AppTheme generates ThemeData with customized GymColors extension', () {
      const customRed = Color(0xFFFF3B30);
      final theme = AppTheme.darkWith(customRed);
      final gc = theme.extension<GymColors>();

      expect(gc, isNotNull);
      expect(gc!.accent, customRed);
      expect(theme.colorScheme.primary, customRed);
    });
  });

  group('Accent Color State Persistence', () {
    test('setAccentColor updates state and serialization', () {
      final state = FitState();
      expect(state.customAccentColor, isNull);
      expect(state.accentColor, isNull);

      const picked = Color(0xFF3B82F6);
      state.setAccentColor(picked);

      expect(state.customAccentColor, picked.toARGB32());
      expect(state.accentColor, picked);

      final json = state.toJson();
      expect(json['accentColor'], picked.toARGB32());

      // Reset
      state.resetAccentColor();
      expect(state.customAccentColor, isNull);
      expect(state.accentColor, isNull);
      expect(state.toJson()['accentColor'], isNull);
    });
  });

  group('AccentDot Widget', () {
    testWidgets('renders dot with specified color and size', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.dark,
          home: const Scaffold(
            body: AccentDot(color: Color(0xFF00BCD4), size: 24),
          ),
        ),
      );

      final containerFinder = find.byType(Container);
      expect(containerFinder, findsOneWidget);

      final container = tester.widget<Container>(containerFinder);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, const Color(0xFF00BCD4));
      expect(container.constraints?.maxWidth ?? 24, 24);
    });
  });
}
