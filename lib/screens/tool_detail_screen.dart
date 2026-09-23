import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../state/fit_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/dialogs.dart';
import '../widgets/glass.dart';
import '../widgets/ui_kit.dart';

class ToolDetailScreen extends StatelessWidget {
  const ToolDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gc = context.gc;
    final id = fit.activeToolId;
    final meta = _meta(id);

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        clipBehavior: Clip.none,
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScreenHeader(title: meta.$1, onBack: fit.closeTool, titleSize: 21),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
              decoration: BoxDecoration(
                color: gc.bgRaised,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(children: [
                Text(t.result.toUpperCase(),
                    style: AppTheme.f(10.5,
                        weight: FontWeight.w700, color: gc.textTertiary, letterSpacing: 1.6)),
                const SizedBox(height: 8),
                Text(meta.$2,
                    textAlign: TextAlign.center,
                    style: AppTheme.f(38, weight: FontWeight.w800, color: gc.text)),
                const SizedBox(height: 8),
                Text(meta.$3,
                    style: AppTheme.f(13, weight: FontWeight.w500, color: gc.textSecondary),
                    textAlign: TextAlign.center),
              ]),
            ),
            const SizedBox(height: 18),
            ..._grouped(_inputs(context, gc, id)),
          ],
        ),
      ),
    );
  }

  List<Widget> _grouped(List<Widget> items) {
    final out = <Widget>[];
    final run = <ToolRow>[];
    void add(Widget w) {
      if (out.isNotEmpty) out.add(const SizedBox(height: 10));
      out.add(w);
    }

    void flush() {
      if (run.isEmpty) return;
      add(ToolGroup([...run]));
      run.clear();
    }

    for (final w in items) {
      if (w is SizedBox) continue;
      if (w is ToolRow) {
        run.add(w);
        continue;
      }
      flush();
      add(w);
    }
    flush();
    return out;
  }

  (String, String, String) _meta(String? id) {
    switch (id) {
      case 'rm':
        return (
          t.toolTitle('rm'),
          '${fit.weightValue(fit.rmResult)} ${fit.units}',
          t.toolResultHint('rm'),
        );
      case 'bmr':
        return (
          t.toolTitle('bmr'),
          '${fit.bmrVal} kcal',
          '${fit.bmrHourly} kcal / hour at rest (${fit.bmrUseBodyFat ? "Katch-McArdle" : "Mifflin-St Jeor"})',
        );
      case 'bmi':
        return (t.toolTitle('bmi'), fmt(fit.bmiVal), t.bmiCategory(fit.bmiCat));
      case 'cal':
        final goalNote = switch (fit.calGoal) {
          'cut' => 'Fat Loss Target (-18% deficit)',
          'bulk' => 'Muscle Gain Target (+10% surplus)',
          _ => 'Maintenance Target (TDEE)',
        };
        return (t.toolTitle('cal'), '${fit.targetCalories} kcal', goalNote);
      case 'bf':
        return (
          t.toolTitle('bf'),
          '${fmt(fit.bfVal)}%',
          '${fit.bfCategory} (${fmt(fit.bfFatMass)} ${fit.units} fat · ${fmt(fit.bfLeanMass)} ${fit.units} lean)',
        );
      case 'plate':
        return (
          t.toolTitle('plate'),
          '${fit.weightValue(fit.plateTarget)} ${fit.units}',
          t.toolResultHint('plate'),
        );
      case 'warmup':
        return (
          t.toolTitle('warmup'),
          '${fit.weightValue(fit.warmupTarget)} ${fit.units}',
          t.toolResultHint('warmup'),
        );
      default:
        return ('', '', '');
    }
  }

  List<Widget> _inputs(BuildContext context, GymColors gc, String? id) {
    switch (id) {
      case 'rm':
        return [
          ToolRow(
            label: t.weightLifted,
            control: StepperControl(
              value: '${fit.weightValue(fit.rmWeight)} ${fit.units}',
              onDec: () => fit.bumpRmWeight(-fit.fromDisplayWeight(fit.weightStep)),
              onInc: () => fit.bumpRmWeight(fit.fromDisplayWeight(fit.weightStep)),
              onEdit: () => _editNumber(
                context,
                title: t.weightLifted,
                current: fit.toDisplayWeight(fit.rmWeight),
                decimal: true,
                apply: (v) => fit.bumpRmWeight(fit.fromDisplayWeight(v) - fit.rmWeight),
              ),
            ),
          ),
          const SizedBox(height: 10),
          ToolRow(
            label: t.repsPerformed,
            control: StepperControl(
              value: '${fit.rmReps}',
              minWidth: 40,
              onDec: () => fit.bumpRmReps(-1),
              onInc: () => fit.bumpRmReps(1),
              onEdit: () => _editNumber(
                context,
                title: t.repsPerformed,
                current: fit.rmReps.toDouble(),
                decimal: false,
                apply: (v) => fit.bumpRmReps(v.round() - fit.rmReps),
              ),
            ),
          ),
          const SizedBox(height: 10),
          _rmPercentagesCard(gc),
        ];

      case 'bmr':
        return [
          ToolRow(
            label: t.sexLabel,
            control: SegToggle([
              SegOption(t.male, fit.bmrSex == 'male', () => fit.setBmrSex('male')),
              SegOption(t.female, fit.bmrSex == 'female', () => fit.setBmrSex('female')),
            ]),
          ),
          const SizedBox(height: 10),
          ToolRow(
            label: t.ageLabel,
            control: StepperControl(
              value: '${fit.bmrAge}',
              minWidth: 40,
              onDec: () => fit.bumpBmrAge(-1),
              onInc: () => fit.bumpBmrAge(1),
              onEdit: () => _editNumber(
                context,
                title: t.ageLabel,
                current: fit.bmrAge.toDouble(),
                decimal: false,
                apply: (v) => fit.bumpBmrAge(v.round() - fit.bmrAge),
              ),
            ),
          ),
          const SizedBox(height: 10),
          ToolRow(
            label: t.heightLabel,
            control: StepperControl(
              value: fit.heightLabel(fit.bmrHeight),
              onDec: () => fit.bumpBmrHeight(-fit.heightStep),
              onInc: () => fit.bumpBmrHeight(fit.heightStep),
              onEdit: () => _editNumber(
                context,
                title: t.heightLabel,
                current: fit.toDisplayCm(fit.bmrHeight),
                decimal: true,
                apply: (v) => fit.bumpBmrHeight(fit.fromDisplayCm(v) - fit.bmrHeight),
              ),
            ),
          ),
          const SizedBox(height: 10),
          ToolRow(
            label: t.weightLabel,
            control: StepperControl(
              value: '${fit.weightValue(fit.bmrWeight)} ${fit.units}',
              onDec: () => fit.bumpBmrWeight(-fit.fromDisplayWeight(fit.isLb ? 1 : 0.5)),
              onInc: () => fit.bumpBmrWeight(fit.fromDisplayWeight(fit.isLb ? 1 : 0.5)),
              onEdit: () => _editNumber(
                context,
                title: t.weightLabel,
                current: fit.toDisplayWeight(fit.bmrWeight),
                decimal: true,
                apply: (v) => fit.bumpBmrWeight(fit.fromDisplayWeight(v) - fit.bmrWeight),
              ),
            ),
          ),
          const SizedBox(height: 10),
          _bmrFormulaCard(gc),
          if (fit.bmrUseBodyFat) ...[
            const SizedBox(height: 10),
            ToolRow(
              label: t.toolNameBf,
              control: StepperControl(
                value: '${fmt(fit.bmrBodyFat)}%',
                onDec: () => fit.bumpBmrBodyFat(-0.5),
                onInc: () => fit.bumpBmrBodyFat(0.5),
                onEdit: () => _editNumber(
                  context,
                  title: t.toolNameBf,
                  current: fit.bmrBodyFat,
                  decimal: true,
                  apply: (v) => fit.bumpBmrBodyFat(v - fit.bmrBodyFat),
                ),
              ),
            ),
          ],
          const SizedBox(height: 10),
          _bmrActivityCard(gc),
        ];

      case 'bmi':
        return [
          ToolRow(
            label: t.heightLabel,
            control: StepperControl(
              value: fit.heightLabel(fit.bmiHeight),
              onDec: () => fit.bumpBmiHeight(-fit.heightStep),
              onInc: () => fit.bumpBmiHeight(fit.heightStep),
              onEdit: () => _editNumber(
                context,
                title: t.heightLabel,
                current: fit.toDisplayCm(fit.bmiHeight),
                decimal: true,
                apply: (v) => fit.bumpBmiHeight(fit.fromDisplayCm(v) - fit.bmiHeight),
              ),
            ),
          ),
          const SizedBox(height: 10),
          ToolRow(
            label: t.weightLabel,
            control: StepperControl(
              value: '${fit.weightValue(fit.bmiWeight)} ${fit.units}',
              onDec: () => fit.bumpBmiWeight(-fit.fromDisplayWeight(fit.isLb ? 1 : 0.5)),
              onInc: () => fit.bumpBmiWeight(fit.fromDisplayWeight(fit.isLb ? 1 : 0.5)),
              onEdit: () => _editNumber(
                context,
                title: t.weightLabel,
                current: fit.toDisplayWeight(fit.bmiWeight),
                decimal: true,
                apply: (v) => fit.bumpBmiWeight(fit.fromDisplayWeight(v) - fit.bmiWeight),
              ),
            ),
          ),
          const SizedBox(height: 10),
          _bmiHealthyRangeCard(gc),
        ];

      case 'cal':
        return [
          _goalCard(gc),
          const SizedBox(height: 10),
          ToolRow(
            label: t.sexLabel,
            control: SegToggle([
              SegOption(t.male, fit.calSex == 'male', () => fit.setCalSex('male')),
              SegOption(t.female, fit.calSex == 'female', () => fit.setCalSex('female')),
            ]),
          ),
          const SizedBox(height: 10),
          ToolRow(
            label: t.ageLabel,
            control: StepperControl(
              value: '${fit.calAge}',
              minWidth: 40,
              onDec: () => fit.bumpCalAge(-1),
              onInc: () => fit.bumpCalAge(1),
              onEdit: () => _editNumber(
                context,
                title: t.ageLabel,
                current: fit.calAge.toDouble(),
                decimal: false,
                apply: (v) => fit.bumpCalAge(v.round() - fit.calAge),
              ),
            ),
          ),
          const SizedBox(height: 10),
          ToolRow(
            label: t.heightLabel,
            control: StepperControl(
              value: fit.heightLabel(fit.calHeight),
              onDec: () => fit.bumpCalHeight(-fit.heightStep),
              onInc: () => fit.bumpCalHeight(fit.heightStep),
              onEdit: () => _editNumber(
                context,
                title: t.heightLabel,
                current: fit.toDisplayCm(fit.calHeight),
                decimal: true,
                apply: (v) => fit.bumpCalHeight(fit.fromDisplayCm(v) - fit.calHeight),
              ),
            ),
          ),
          const SizedBox(height: 10),
          ToolRow(
            label: t.weightLabel,
            control: StepperControl(
              value: '${fit.weightValue(fit.calWeight)} ${fit.units}',
              onDec: () => fit.bumpCalWeight(-fit.fromDisplayWeight(fit.isLb ? 1 : 0.5)),
              onInc: () => fit.bumpCalWeight(fit.fromDisplayWeight(fit.isLb ? 1 : 0.5)),
              onEdit: () => _editNumber(
                context,
                title: t.weightLabel,
                current: fit.toDisplayWeight(fit.calWeight),
                decimal: true,
                apply: (v) => fit.bumpCalWeight(fit.fromDisplayWeight(v) - fit.calWeight),
              ),
            ),
          ),
          const SizedBox(height: 10),
          _activityCard(gc),
          const SizedBox(height: 10),
          _macros(gc),
        ];

      case 'bf':
        return [
          ToolRow(
            label: t.sexLabel,
            control: SegToggle([
              SegOption(t.male, fit.bfSex == 'male', () => fit.setBfSex('male')),
              SegOption(t.female, fit.bfSex == 'female', () => fit.setBfSex('female')),
            ]),
          ),
          const SizedBox(height: 10),
          ToolRow(
            label: t.heightLabel,
            control: StepperControl(
              value: fit.heightLabel(fit.bfHeight),
              onDec: () => fit.bumpBfHeight(-fit.heightStep),
              onInc: () => fit.bumpBfHeight(fit.heightStep),
              onEdit: () => _editNumber(
                context,
                title: t.heightLabel,
                current: fit.toDisplayCm(fit.bfHeight),
                decimal: true,
                apply: (v) => fit.bumpBfHeight(fit.fromDisplayCm(v) - fit.bfHeight),
              ),
            ),
          ),
          const SizedBox(height: 10),
          ToolRow(
            label: t.neck,
            control: StepperControl(
              value: fit.cmLabel(fit.bfNeck),
              onDec: () => fit.bumpBfNeck(-fit.girthStep),
              onInc: () => fit.bumpBfNeck(fit.girthStep),
              onEdit: () => _editNumber(
                context,
                title: t.neck,
                current: fit.toDisplayCm(fit.bfNeck),
                decimal: true,
                apply: (v) => fit.bumpBfNeck(fit.fromDisplayCm(v) - fit.bfNeck),
              ),
            ),
          ),
          const SizedBox(height: 10),
          ToolRow(
            label: t.waist,
            control: StepperControl(
              value: fit.cmLabel(fit.bfWaist),
              onDec: () => fit.bumpBfWaist(-fit.girthStep),
              onInc: () => fit.bumpBfWaist(fit.girthStep),
              onEdit: () => _editNumber(
                context,
                title: t.waist,
                current: fit.toDisplayCm(fit.bfWaist),
                decimal: true,
                apply: (v) => fit.bumpBfWaist(fit.fromDisplayCm(v) - fit.bfWaist),
              ),
            ),
          ),
          if (fit.bfSex == 'female') ...[
            const SizedBox(height: 10),
            ToolRow(
              label: t.hip,
              control: StepperControl(
                value: fit.cmLabel(fit.bfHip),
                onDec: () => fit.bumpBfHip(-fit.girthStep),
                onInc: () => fit.bumpBfHip(fit.girthStep),
                onEdit: () => _editNumber(
                  context,
                  title: t.hip,
                  current: fit.toDisplayCm(fit.bfHip),
                  decimal: true,
                  apply: (v) => fit.bumpBfHip(fit.fromDisplayCm(v) - fit.bfHip),
                ),
              ),
            ),
          ],
          const SizedBox(height: 10),
          _bfCompositionCard(gc),
        ];

      case 'plate':
        return [
          ToolRow(
            label: t.targetWeight,
            control: StepperControl(
              value: '${fit.weightValue(fit.plateTarget)} ${fit.units}',
              onDec: () => fit.bumpPlateTarget(-fit.fromDisplayWeight(fit.weightStep)),
              onInc: () => fit.bumpPlateTarget(fit.fromDisplayWeight(fit.weightStep)),
              onEdit: () => _editNumber(
                context,
                title: t.targetWeight,
                current: fit.toDisplayWeight(fit.plateTarget),
                decimal: true,
                apply: (v) => fit.bumpPlateTarget(fit.fromDisplayWeight(v) - fit.plateTarget),
              ),
            ),
          ),
          const SizedBox(height: 10),
          _barWeightCard(gc),
          const SizedBox(height: 10),
          _perSideCard(gc),
        ];

      case 'warmup':
        return [
          ToolRow(
            label: t.workingWeight,
            control: StepperControl(
              value: '${fit.weightValue(fit.warmupTarget)} ${fit.units}',
              onDec: () => fit.bumpWarmupTarget(-fit.fromDisplayWeight(fit.weightStep)),
              onInc: () => fit.bumpWarmupTarget(fit.fromDisplayWeight(fit.weightStep)),
              onEdit: () => _editNumber(
                context,
                title: t.workingWeight,
                current: fit.toDisplayWeight(fit.warmupTarget),
                decimal: true,
                apply: (v) => fit.bumpWarmupTarget(fit.fromDisplayWeight(v) - fit.warmupTarget),
              ),
            ),
          ),
          const SizedBox(height: 10),
          _warmupCard(gc),
        ];

      default:
        return const [];
    }
  }

  Future<void> _editNumber(
    BuildContext context, {
    required String title,
    required double current,
    required bool decimal,
    required void Function(double) apply,
  }) async {
    final parsed = await askNumber(context, title: title, initial: fmt(current), decimal: decimal);
    if (parsed != null) apply(parsed);
  }

  Widget _goalCard(GymColors gc) {
    Widget opt(String label, String key, String subtitle) {
      final active = fit.calGoal == key;
      return Expanded(
        child: GestureDetector(
          onTap: () => fit.setCalGoal(key),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            decoration: BoxDecoration(
              color: active ? gc.ember : gc.bgRaised2,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Text(
                  label,
                  style: AppTheme.f(13,
                      weight: FontWeight.w700,
                      color: active ? gc.onEmber : gc.text),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTheme.f(10,
                      weight: FontWeight.w500,
                      color: active ? gc.onEmber.withValues(alpha: 0.8) : gc.textTertiary),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SoftCard(
      radius: 20,
      borderColor: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Goal', style: AppTheme.f(13, weight: FontWeight.w600, color: gc.textSecondary)),
          const SizedBox(height: 10),
          Row(
            children: [
              opt('Cut', 'cut', '-18% deficit'),
              const SizedBox(width: 8),
              opt('Maintain', 'maintain', 'TDEE'),
              const SizedBox(width: 8),
              opt('Bulk', 'bulk', '+10% surplus'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _rmPercentagesCard(GymColors gc) {
    final items = fit.rmPercentages;
    return SoftCard(
      radius: 20,
      borderColor: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('1RM Percentages',
              style: AppTheme.f(13, weight: FontWeight.w600, color: gc.textSecondary)),
          const SizedBox(height: 10),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${item.pct}%',
                      style: AppTheme.f(13, weight: FontWeight.w700, color: gc.text)),
                  Text(
                    item.reps == 1 ? '1 rep' : '~${item.reps} reps',
                    style: AppTheme.f(12, weight: FontWeight.w500, color: gc.textSecondary),
                  ),
                  Text('${fmt(item.weight)} ${fit.units}',
                      style: AppTheme.f(14, weight: FontWeight.w700, color: gc.ember)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _bmrFormulaCard(GymColors gc) {
    return SoftCard(
      radius: 20,
      borderColor: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Formula', style: AppTheme.f(13, weight: FontWeight.w600, color: gc.textSecondary)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => fit.setBmrUseBodyFat(false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    decoration: BoxDecoration(
                      color: !fit.bmrUseBodyFat ? gc.ember : gc.bgRaised2,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Mifflin-St Jeor',
                      style: AppTheme.f(12,
                          weight: FontWeight.w600,
                          color: !fit.bmrUseBodyFat ? gc.onEmber : gc.textSecondary),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () => fit.setBmrUseBodyFat(true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    decoration: BoxDecoration(
                      color: fit.bmrUseBodyFat ? gc.ember : gc.bgRaised2,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Katch-McArdle (BF%)',
                      style: AppTheme.f(12,
                          weight: FontWeight.w600,
                          color: fit.bmrUseBodyFat ? gc.onEmber : gc.textSecondary),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bmrActivityCard(GymColors gc) {
    final tiers = fit.bmrActivityTiers;
    return SoftCard(
      radius: 20,
      borderColor: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Daily Expenditure Preview',
              style: AppTheme.f(13, weight: FontWeight.w600, color: gc.textSecondary)),
          const SizedBox(height: 10),
          for (final t in tiers)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(t.name,
                      style: AppTheme.f(12.5, weight: FontWeight.w600, color: gc.text)),
                  Text(
                    '${fmt(t.factor)}×',
                    style: AppTheme.f(11.5, weight: FontWeight.w500, color: gc.textSecondary),
                  ),
                  Text('${t.calories} kcal',
                      style: AppTheme.f(13.5, weight: FontWeight.w700, color: gc.ember)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _bmiHealthyRangeCard(GymColors gc) {
    return SoftCard(
      radius: 20,
      borderColor: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Healthy Weight Range',
              style: AppTheme.f(13, weight: FontWeight.w600, color: gc.textSecondary)),
          const SizedBox(height: 6),
          Text(
            '${fmt(fit.bmiHealthyMin)} – ${fmt(fit.bmiHealthyMax)} ${fit.units}',
            style: AppTheme.f(18, weight: FontWeight.w800, color: gc.ember),
          ),
          const SizedBox(height: 4),
          Text(
            'Based on WHO normal BMI range (18.5 – 24.9)',
            style: AppTheme.f(11.5, weight: FontWeight.w500, color: gc.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _bfCompositionCard(GymColors gc) {
    return SoftCard(
      radius: 20,
      borderColor: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Body Composition (ACE Standard)',
              style: AppTheme.f(13, weight: FontWeight.w600, color: gc.textSecondary)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: gc.bgRaised2,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Fat Mass',
                          style: AppTheme.f(10.5,
                              weight: FontWeight.w600, color: gc.textSecondary)),
                      const SizedBox(height: 4),
                      Text('${fmt(fit.bfFatMass)} ${fit.units}',
                          style: AppTheme.f(15, weight: FontWeight.w700, color: gc.text)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: gc.bgRaised2,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Lean Mass',
                          style: AppTheme.f(10.5,
                              weight: FontWeight.w600, color: gc.textSecondary)),
                      const SizedBox(height: 4),
                      Text('${fmt(fit.bfLeanMass)} ${fit.units}',
                          style: AppTheme.f(15, weight: FontWeight.w700, color: gc.text)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _activityCard(GymColors gc) {
    Widget pill(String label, double v) {
      final active = fit.calActivity == v;
      return Pill(
        label: label,
        bg: active ? gc.ember : gc.bgRaised2,
        fg: active ? gc.onEmber : gc.textSecondary,
        onTap: () => fit.setCalActivity(v),
        hPad: 12,
        vPad: 7,
        fontSize: 12,
      );
    }

    return SoftCard(
      radius: 20,
      borderColor: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.activityLevel, style: AppTheme.f(13, weight: FontWeight.w600, color: gc.textSecondary)),
          const SizedBox(height: 10),
          Wrap(spacing: 6, runSpacing: 6, children: [
            pill(t.activityName('Sedentary'), 1.2),
            pill(t.activityName('Light'), 1.375),
            pill(t.activityName('Moderate'), 1.55),
            pill(t.activityName('Active'), 1.725),
            pill(t.activityName('Very Active'), 1.9),
          ]),
        ],
      ),
    );
  }

  Widget _macros(GymColors gc) {
    Widget card(String label, String value, String sub) => Expanded(
          child: SoftCard(
            radius: 20,
            borderColor: Colors.transparent,
            padding: const EdgeInsets.all(12),
            child: Column(children: [
              Text(label, style: AppTheme.f(10, weight: FontWeight.w600, color: gc.textSecondary)),
              const SizedBox(height: 4),
              Text(value, style: AppTheme.f(16, weight: FontWeight.w700, color: gc.text)),
              const SizedBox(height: 2),
              Text(sub, style: AppTheme.f(9.5, weight: FontWeight.w500, color: gc.textTertiary)),
            ]),
          ),
        );

    final pKcal = fit.calProtein * 4;
    final cKcal = fit.calCarbs * 4;
    final fKcal = fit.calFat * 9;

    return Row(children: [
      card(t.macroProtein, '${fit.calProtein}g', '$pKcal kcal'),
      const SizedBox(width: 8),
      card(t.macroCarbs, '${fit.calCarbs}g', '$cKcal kcal'),
      const SizedBox(width: 8),
      card(t.macroFat, '${fit.calFat}g', '$fKcal kcal'),
    ]);
  }

  Widget _barWeightCard(GymColors gc) {
    Widget opt(double v) {
      final active = fit.plateBarDisplay == v;
      return Expanded(
        child: GestureDetector(
          onTap: () => fit.setPlateBar(v),
          child: Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.center,
            decoration: BoxDecoration(color: active ? gc.ember : gc.bgRaised2, borderRadius: BorderRadius.circular(10)),
            child: Text('${fmt(v)} ${fit.units}',
                style: AppTheme.f(13, weight: FontWeight.w600, color: active ? gc.onEmber : gc.textSecondary)),
          ),
        ),
      );
    }

    final bars = fit.barOptions;
    return SoftCard(
      radius: 20,
      borderColor: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.barWeight, style: AppTheme.f(13, weight: FontWeight.w600, color: gc.textSecondary)),
          const SizedBox(height: 10),
          Row(children: [
            for (int i = 0; i < bars.length; i++) ...[
              if (i > 0) const SizedBox(width: 8),
              opt(bars[i]),
            ],
          ]),
        ],
      ),
    );
  }

  Widget _perSideCard(GymColors gc) {
    final rows = fit.plateBreakdown;
    final target = fit.toDisplayWeight(fit.plateTarget);
    final loadable = fit.loadableTotal(target, fit.plateBarDisplay);
    return SoftCard(
      radius: 20,
      borderColor: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.perSide, style: AppTheme.f(13, weight: FontWeight.w600, color: gc.textSecondary)),
          const SizedBox(height: 10),
          if (rows.isEmpty)
            Text(t.justTheBar, style: AppTheme.f(13, weight: FontWeight.w500, color: gc.textSecondary))
          else
            for (final p in rows)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${fmt(p.weight)} ${fit.units}', style: AppTheme.f(14, weight: FontWeight.w600, color: gc.text)),
                    Text(t.perSideCount(p.count), style: AppTheme.f(13, weight: FontWeight.w500, color: gc.textSecondary)),
                  ],
                ),
              ),
          if (loadable < target - 0.01)
            Text(t.plateAchievable('${fmt(loadable)} ${fit.units}'),
                style: AppTheme.f(12, weight: FontWeight.w500, color: gc.brass)),
        ],
      ),
    );
  }

  Widget _warmupCard(GymColors gc) {
    final sets = fit.warmupSets;
    return SoftCard(
      radius: 20,
      borderColor: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          for (int i = 0; i < sets.length; i++)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                border: i < sets.length - 1 ? Border(bottom: BorderSide(color: gc.border)) : null,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        sets[i].isBarOnly
                            ? 'Bar only · ${sets[i].reps} reps'
                            : t.rampSet(sets[i].pct, sets[i].reps),
                        style: AppTheme.f(13, weight: FontWeight.w500, color: gc.textSecondary),
                      ),
                    ],
                  ),
                  Text('${fmt(sets[i].weight)} ${fit.units}',
                      style: AppTheme.f(15, weight: FontWeight.w700, color: gc.text)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

void showPlateSheet(BuildContext context, double displayTarget) {
  final gc = context.gc;
  var bar = fit.defaultBar;
  showAppSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (sheet) => StatefulBuilder(
      builder: (sheet, setSheet) {
        final rows = fit.platesPerSide(displayTarget, bar);
        final loadable = fit.loadableTotal(displayTarget, bar);
        return Container(
          padding: sheetPad(sheet),
          decoration: BoxDecoration(
            color: gc.bgRaised,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SheetHandle(),
              const SizedBox(height: 16),
              SheetTitle(t.toolTitle('plate')),
              const SizedBox(height: 4),
              Text('${fmt(displayTarget)} ${fit.units}',
                  textAlign: TextAlign.center,
                  style: AppTheme.f(30, weight: FontWeight.w700, color: gc.ember)),
              const SizedBox(height: 18),
              Text(t.barWeight,
                  style: AppTheme.f(10, weight: FontWeight.w700, color: gc.textTertiary, letterSpacing: 1.5)),
              const SizedBox(height: 8),
              Row(children: [
                for (final option in fit.barOptions) ...[
                  if (option != fit.barOptions.first) const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => setSheet(() => bar = option),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: bar == option ? gc.ember : gc.bgRaised2,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text('${fmt(option)} ${fit.units}',
                            style: AppTheme.f(13,
                                weight: FontWeight.w600,
                                color: bar == option ? gc.onEmber : gc.textSecondary)),
                      ),
                    ),
                  ),
                ],
              ]),
              const SizedBox(height: 18),
              Text(t.perSide,
                  style: AppTheme.f(10, weight: FontWeight.w700, color: gc.textTertiary, letterSpacing: 1.5)),
              const SizedBox(height: 10),
              if (rows.isEmpty)
                Text(t.justTheBar, style: AppTheme.f(13, weight: FontWeight.w500, color: gc.textSecondary))
              else
                for (final p in rows)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${fmt(p.weight)} ${fit.units}',
                            style: AppTheme.f(14, weight: FontWeight.w600, color: gc.text)),
                        Text(t.perSideCount(p.count), style: AppTheme.f(13, weight: FontWeight.w500, color: gc.textSecondary)),
                      ],
                    ),
                  ),
              if (loadable < displayTarget - 0.01) ...[
                const SizedBox(height: 2),
                Text(t.plateAchievable('${fmt(loadable)} ${fit.units}'),
                    style: AppTheme.f(12, weight: FontWeight.w500, color: gc.brass)),
              ],
              const SizedBox(height: 18),
              PrimaryButton(label: t.done, onTap: () => Navigator.of(sheet).pop()),
            ],
          ),
        );
      },
    ),
  );
}
