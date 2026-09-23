import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart' as cp;
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../l10n/l10n.dart';
import '../state/fit_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import 'glass.dart';
import 'ui_kit.dart';

class AccentDot extends StatelessWidget {
  const AccentDot({super.key, required this.color, this.size = 22});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final gc = context.gc;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: gc.border, width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.45),
            blurRadius: 8,
          ),
        ],
      ),
    );
  }
}

class AccentColorPicker extends StatefulWidget {
  const AccentColorPicker({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final Color? selected;
  final ValueChanged<Color> onSelected;

  @override
  State<AccentColorPicker> createState() => _AccentColorPickerState();
}

class _AccentColorPickerState extends State<AccentColorPicker> {
  late bool _custom = _isCustom(widget.selected);

  bool _isCustom(Color? color) {
    if (color == null) return false;
    return !GymColors.kAccentPresets
        .any((c) => c.toARGB32() == color.toARGB32());
  }

  @override
  Widget build(BuildContext context) {
    final gc = context.gc;
    final activeColor = widget.selected ?? gc.accent;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SegmentPicker(
          left: t.colorsTab,
          right: t.customTab,
          rightActive: _custom,
          onChanged: (isCustom) => setState(() => _custom = isCustom),
        ),
        const SizedBox(height: 18),
        if (_custom)
          Center(
            child: cp.HueRingPicker(
              pickerColor: activeColor,
              onColorChanged: widget.onSelected,
              enableAlpha: false,
              displayThumbColor: true,
            ),
          )
        else
          LayoutBuilder(
            builder: (context, constraints) {
              const columns = 8;
              const spacing = 10.0;
              final swatchSize = ((constraints.maxWidth - spacing * (columns - 1)) / columns)
                  .clamp(28.0, 42.0);

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                alignment: WrapAlignment.center,
                children: [
                  for (final color in GymColors.kAccentPresets)
                    _ColorSwatch(
                      color: color,
                      size: swatchSize,
                      selected: widget.selected == null
                          ? color.toARGB32() == GymColors.kAccentPresets.first.toARGB32()
                          : color.toARGB32() == widget.selected!.toARGB32(),
                      onTap: () => widget.onSelected(color),
                    ),
                ],
              );
            },
          ),
      ],
    );
  }
}

class _SegmentPicker extends StatelessWidget {
  const _SegmentPicker({
    required this.left,
    required this.right,
    required this.rightActive,
    required this.onChanged,
  });

  final String left;
  final String right;
  final bool rightActive;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final gc = context.gc;

    Widget seg(String label, bool active, VoidCallback onTap) => Expanded(
          child: GestureDetector(
            onTap: onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              padding: const EdgeInsets.symmetric(vertical: 9),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: active ? gc.ember : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                label,
                style: AppTheme.f(
                  13,
                  weight: FontWeight.w700,
                  color: active ? gc.onEmber : gc.textSecondary,
                ),
              ),
            ),
          ),
        );

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: gc.bgRaised2,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          seg(left, !rightActive, () => onChanged(false)),
          seg(right, rightActive, () => onChanged(true)),
        ],
      ),
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({
    required this.color,
    required this.size,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final double size;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final luminance = color.computeLuminance();
    final checkColor = luminance > 0.6 ? const Color(0xFF1C1C1E) : Colors.white;
    final borderColor = luminance > 0.85 ? const Color(0xFF8E8E93) : Colors.white;

    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
            border: selected ? Border.all(color: borderColor, width: 2.5) : null,
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.5),
                      blurRadius: 10,
                      spreadRadius: 1,
                    )
                  ]
                : null,
          ),
          child: selected
              ? Icon(PhosphorIconsRegular.check, color: checkColor, size: 18)
              : null,
        ),
      ),
    );
  }
}

Future<void> showAccentColorSheet(BuildContext context) {
  return showAppSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (sheet) => AnimatedBuilder(
      animation: fit,
      builder: (sheet, _) {
        final gc = sheet.gc;
        return Container(
          padding: sheetPad(sheet, bottom: 24),
          decoration: BoxDecoration(
            color: gc.bgRaised,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SheetHandle(),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        t.accentColor,
                        style: AppTheme.d(18, weight: FontWeight.w800, color: gc.text),
                      ),
                    ),
                    if (fit.customAccentColor != null)
                      GestureDetector(
                        onTap: fit.resetAccentColor,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: gc.bgRaised2,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                PhosphorIconsRegular.arrowCounterClockwise,
                                size: 13,
                                color: gc.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                t.resetDefault,
                                style: AppTheme.f(
                                  12,
                                  weight: FontWeight.w600,
                                  color: gc.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                AccentColorPicker(
                  selected: fit.accentColor,
                  onSelected: (color) => fit.setAccentColor(color),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
