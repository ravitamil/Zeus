import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zeus/l10n/l10n.dart';
import 'package:zeus/state/fit_state.dart';
import 'package:zeus/theme/app_theme.dart';
import 'package:zeus/widgets/start_countdown.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('StartCountdown does not crash on curve assertions during animation', (tester) async {
    final until = DateTime.now().add(const Duration(seconds: 4));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkWith(fit.accentColor),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: StartCountdown(until: until),
        ),
      ),
    );

    // Let the animation run through multiple seconds / beats
    for (int i = 0; i < 40; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  });
}
