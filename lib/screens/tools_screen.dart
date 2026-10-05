import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../catalog/exercise_categories.dart';
import '../catalog/exercise_catalog.dart';
import '../l10n/l10n.dart';
import '../models/exercise.dart';
import '../state/fit_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/ui_kit.dart';
import 'measures_screen.dart';

IconData _toolIcon(String id) => switch (id) {
      'rm' => PhosphorIconsRegular.barbell,
      'bmr' => PhosphorIconsRegular.heartbeat,
      'bmi' => PhosphorIconsRegular.scales,
      'cal' => PhosphorIconsRegular.fire,
      'bf' => PhosphorIconsRegular.percent,
      'plate' => PhosphorIconsRegular.circlesThree,
      _ => PhosphorIconsRegular.trendUp,
    };

Color _toolColor(String id) => switch (id) {
      'rm' => const Color(0xFF8B5CF6),    // Electric Violet
      'bmr' => const Color(0xFFFF3366),   // Vibrant Rose
      'bmi' => const Color(0xFF00B4D8),   // Cyan / Sky Blue
      'cal' => const Color(0xFFFF6D00),   // Sunset Orange
      'bf' => const Color(0xFF10B981),    // Emerald Green
      'plate' => const Color(0xFFF59E0B), // Warm Gold / Amber
      _ => const Color(0xFFFF6B6B),       // Coral Red (warmup)
    };

class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gc = context.gc;
    final scale = MediaQuery.textScalerOf(context).scale(1);

    return SafeArea(
      bottom: false,
      child: AnimatedBuilder(
        animation: fit,
        builder: (context, _) => SingleChildScrollView(
          clipBehavior: Clip.none,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ScreenHeader(
                title: t.tools,
                onBack: fit.backFromTools,
                titleSize: 22,
                subtitle: t.calculatorsCount(kToolMeta.length),
              ),
              const SizedBox(height: 20),
              _measuresHero(context, gc, scale),
              const SizedBox(height: 6),
              Row(
                children: [
                  Text(
                    t.tools.toUpperCase(),
                    style: AppTheme.d(11.5,
                        weight: FontWeight.w700, color: gc.textSecondary, letterSpacing: 1.4),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(height: 0.8, color: gc.border.withValues(alpha: 0.6)),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.12 / scale,
                children: [for (final tool in kToolMeta) _card(gc, tool, scale)],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _measuresHero(BuildContext context, GymColors gc, double scale) {
    final tracked = fit.trackedMeasures;
    final hasData = fit.measures.isNotEmpty;

    return SoftCard(
      radius: 22,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: gc.accent.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: gc.accent.withValues(alpha: 0.3), width: 1),
                ),
                child: Center(
                  child: Icon(PhosphorIconsRegular.ruler, size: 22, color: gc.accent),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Measurements',
                        maxLines: 1,
                        style: AppTheme.f(16, weight: FontWeight.w700, color: gc.text),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      hasData
                          ? t.measureCount(fit.measures.length)
                          : t.setupMeasures,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.f(12, weight: FontWeight.w500, color: gc.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: fit.goMeasures,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: gc.bgRaised2,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: gc.border, width: 0.8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Manage',
                        style: AppTheme.f(12.5, weight: FontWeight.w700, color: gc.text),
                      ),
                      const SizedBox(width: 4),
                      Icon(PhosphorIconsRegular.caretRight, size: 14, color: gc.textSecondary),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (tracked.isNotEmpty) ...[
            const SizedBox(height: 16),
            SizedBox(
              height: 60,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                clipBehavior: Clip.none,
                itemCount: tracked.length,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (context, i) {
                  final key = tracked[i];
                  final latest = fit.latestMeasure(key)!;
                  final change = fit.measurePeriodicChange(key, '30d') ?? fit.measureChange(key);
                  final isDecreaseGood = fit.isMeasureDecreaseGood(key);
                  final isGood = change != null && (isDecreaseGood ? change < 0 : change > 0);

                  return GestureDetector(
                    onTap: () => showMeasureSheet(context, key),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 8, 12, 8),
                      decoration: BoxDecoration(
                        color: gc.bgRaised2,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: gc.border.withValues(alpha: 0.7), width: 0.8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: gc.bgRaised,
                              borderRadius: BorderRadius.circular(9),
                              border: Border.all(color: gc.border.withValues(alpha: 0.5), width: 0.6),
                            ),
                            child: Image.asset(bodyMeasureAsset(key), fit: BoxFit.contain),
                          ),
                          const SizedBox(width: 9),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                t.measureName(key),
                                style: AppTheme.f(11, weight: FontWeight.w600, color: gc.textSecondary),
                              ),
                              const SizedBox(height: 1),
                              Row(
                                children: [
                                  Text(
                                    fit.measureLabel(key, latest.value),
                                    style: AppTheme.f(12, weight: FontWeight.w700, color: gc.text),
                                  ),
                                  if (change != null && change != 0) ...[
                                    const SizedBox(width: 5),
                                    Text(
                                      '${change > 0 ? '+' : ''}${fmt(change)}',
                                      style: AppTheme.f(11,
                                          weight: FontWeight.w700,
                                          color: isGood ? gc.sage : gc.accent),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ] else ...[
            const SizedBox(height: 12),
            GestureDetector(
              onTap: fit.goMeasures,
              child: Text(
                t.measuresHint,
                style: AppTheme.s(12, color: gc.textTertiary, height: 1.4),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _card(GymColors gc, ToolMeta tool, double scale) {
    final color = _toolColor(tool.id);
    return GestureDetector(
      onTap: () => fit.openTool(tool.id),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: gc.bgRaised,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: gc.border.withValues(alpha: 0.5), width: 0.8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withValues(alpha: 0.25), width: 1),
              ),
              child: Center(child: Icon(_toolIcon(tool.id), size: 19, color: color)),
            ),
            const Spacer(),
            Text(t.toolName(tool.id),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTheme.f(14.5, weight: FontWeight.w700, color: gc.text)),
            const SizedBox(height: 2),
            SizedBox(
              height: 31 * scale,
              child: Text(t.toolDesc(tool.id),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.f(11.5,
                      weight: FontWeight.w500, color: gc.textSecondary, height: 1.3)),
            ),
          ],
        ),
      ),
    );
  }
}
