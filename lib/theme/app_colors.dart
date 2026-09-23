import 'package:flutter/material.dart';

@immutable
class GymColors extends ThemeExtension<GymColors> {
  const GymColors({
    required this.pageBg,
    required this.bg,
    required this.bgRaised,
    required this.bgRaised2,
    required this.border,
    required this.navBg,
    required this.text,
    required this.textSecondary,
    required this.textTertiary,
    required this.ember,
    required this.emberDeep,
    required this.onEmber,
    required this.emberSoft,
    required this.emberShadow,
    required this.accent,
    required this.accentSoft,
    required this.brass,
    required this.sage,
    required this.sageSoft,
    required this.mutedFill,
    required this.heatEmpty,
    required this.info,
    required this.warn,
    required this.danger,
  });

  final Color pageBg;
  final Color bg;
  final Color bgRaised;
  final Color bgRaised2;
  final Color border;
  final Color navBg;
  final Color text;
  final Color textSecondary;
  final Color textTertiary;
  final Color ember;
  final Color emberDeep;
  final Color onEmber;
  final Color emberSoft;
  final Color emberShadow;
  final Color accent;
  final Color accentSoft;
  final Color brass;
  final Color sage;
  final Color sageSoft;
  final Color mutedFill;
  final Color heatEmpty;
  final Color info;
  final Color warn;
  final Color danger;

  static const dark = GymColors(
    pageBg: Color(0xFF0A0908),
    bg: Color(0xFF0A0A0A),
    bgRaised: Color(0xFF1C1C1C),
    bgRaised2: Color(0xFF2B2B2B),
    border: Color(0xFF3E3E3E),
    navBg: Color(0xD90A0A0A),
    text: Color(0xFFFFFFFF),
    textSecondary: Color(0xFF9A9A9A),
    textTertiary: Color(0xFF666666),
    ember: Color(0xFFFFFFFF),
    emberDeep: Color(0xFFD0D0D0),
    onEmber: Color(0xFF0A0A0A),
    emberSoft: Color(0x1AFFFFFF),
    emberShadow: Color(0x80000000),
    accent: Color(0xFFD9A184),
    accentSoft: Color(0x29D9A184),
    brass: Color(0xFFB98F72),
    sage: Color(0xFF8FA377),
    sageSoft: Color(0x298FA377),
    mutedFill: Color(0xFF2A2A2A),
    heatEmpty: Color(0xFF242424),
    info: Color(0xFF7FA8C9),
    warn: Color(0xFFE0B15A),
    danger: Color(0xFFE5674C),
  );

  static const light = GymColors(
    pageBg: Color(0xFFFFFEFD),
    bg: Color(0xFFF7F4F0),
    bgRaised: Color(0xFFFFFFFF),
    bgRaised2: Color(0xFFECE8E3),
    border: Color(0xFFE0DBD5),
    navBg: Color(0xF2FFFEFD),
    text: Color(0xFF1A1713),
    textSecondary: Color(0xFF5F574F),
    textTertiary: Color(0xFF8A8179),
    ember: Color(0xFF1A1713),
    emberDeep: Color(0xFF000000),
    onEmber: Color(0xFFFFFFFF),
    emberSoft: Color(0x121A1713),
    emberShadow: Color(0x1F1A1713),
    accent: Color(0xFF9E4E27),
    accentSoft: Color(0x1F9E4E27),
    brass: Color(0xFF8A6B41),
    sage: Color(0xFF3D7A52),
    sageSoft: Color(0x1F3D7A52),
    mutedFill: Color(0xFFE9E4DE),
    heatEmpty: Color(0xFFE7E2DC),
    info: Color(0xFF3268A0),
    warn: Color(0xFF9A6A12),
    danger: Color(0xFFC0392B),
  );

  static const List<Color> kAccentPresets = [
    Color(0xFFD9A184), // Signature Terracotta (Zeus Default)
    Color(0xFFFF3B30), // Crimson Red
    Color(0xFFEF4444), // Scarlet
    Color(0xFFFF6B6B), // Coral
    Color(0xFFFF375F), // Hot Rose
    Color(0xFFFF2D92), // Neon Pink
    Color(0xFFFF9500), // Tangerine
    Color(0xFFFF6D00), // Sunset Orange
    Color(0xFFFF8C42), // Papaya
    Color(0xFFE67E22), // Ochre
    Color(0xFFFFCC00), // Gold
    Color(0xFFFFD60A), // Amber Sun
    Color(0xFFF59E0B), // Warm Amber
    Color(0xFFA8E063), // Lime
    Color(0xFF7ED321), // Volt Green
    Color(0xFF30D158), // Electric Mint
    Color(0xFF22C55E), // Vivid Green
    Color(0xFF10B981), // Emerald
    Color(0xFF1ABC9C), // Jade
    Color(0xFF4ECDC4), // Aqua Marine
    Color(0xFF26C6DA), // Cyan
    Color(0xFF00BCD4), // Deep Cyan
    Color(0xFF5AC8FA), // Sky Blue
    Color(0xFF0A84FF), // Cobalt
    Color(0xFF007AFF), // Pure Blue
    Color(0xFF3B82F6), // Royal Blue
    Color(0xFF5856D6), // Indigo
    Color(0xFF7C3AED), // Electric Violet
    Color(0xFF8B5CF6), // Purple
    Color(0xFFBF5AF2), // Magenta Orchid
    Color(0xFFB98F72), // Warm Brass
    Color(0xFF8E8E93), // Slate Steel
  ];

  static Color adaptAccent(Color accent, bool isDark) {
    final luminance = accent.computeLuminance();
    if (isDark && luminance < 0.08) return const Color(0xFFF2F2F2);
    if (!isDark && luminance > 0.75) return const Color(0xFF1C1C1E);
    return accent;
  }

  static GymColors withAccent(Color? customAccent, {required bool isDark}) {
    final base = isDark ? dark : light;
    if (customAccent == null) return base;
    final adapted = adaptAccent(customAccent, isDark);
    final softAlpha = isDark ? 0.20 : 0.16;
    return base.copyWith(
      accent: adapted,
      accentSoft: adapted.withValues(alpha: softAlpha),
    );
  }

  @override
  GymColors copyWith({
    Color? pageBg,
    Color? bg,
    Color? bgRaised,
    Color? bgRaised2,
    Color? border,
    Color? navBg,
    Color? text,
    Color? textSecondary,
    Color? textTertiary,
    Color? ember,
    Color? emberDeep,
    Color? onEmber,
    Color? emberSoft,
    Color? emberShadow,
    Color? accent,
    Color? accentSoft,
    Color? brass,
    Color? sage,
    Color? sageSoft,
    Color? mutedFill,
    Color? heatEmpty,
    Color? info,
    Color? warn,
    Color? danger,
  }) {
    return GymColors(
      pageBg: pageBg ?? this.pageBg,
      bg: bg ?? this.bg,
      bgRaised: bgRaised ?? this.bgRaised,
      bgRaised2: bgRaised2 ?? this.bgRaised2,
      border: border ?? this.border,
      navBg: navBg ?? this.navBg,
      text: text ?? this.text,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      ember: ember ?? this.ember,
      emberDeep: emberDeep ?? this.emberDeep,
      onEmber: onEmber ?? this.onEmber,
      emberSoft: emberSoft ?? this.emberSoft,
      emberShadow: emberShadow ?? this.emberShadow,
      accent: accent ?? this.accent,
      accentSoft: accentSoft ?? this.accentSoft,
      brass: brass ?? this.brass,
      sage: sage ?? this.sage,
      sageSoft: sageSoft ?? this.sageSoft,
      mutedFill: mutedFill ?? this.mutedFill,
      heatEmpty: heatEmpty ?? this.heatEmpty,
      info: info ?? this.info,
      warn: warn ?? this.warn,
      danger: danger ?? this.danger,
    );
  }

  @override
  GymColors lerp(GymColors? other, double t) {
    if (other == null) return this;
    Color c(Color a, Color b) => Color.lerp(a, b, t)!;
    return GymColors(
      pageBg: c(pageBg, other.pageBg),
      bg: c(bg, other.bg),
      bgRaised: c(bgRaised, other.bgRaised),
      bgRaised2: c(bgRaised2, other.bgRaised2),
      border: c(border, other.border),
      navBg: c(navBg, other.navBg),
      text: c(text, other.text),
      textSecondary: c(textSecondary, other.textSecondary),
      textTertiary: c(textTertiary, other.textTertiary),
      ember: c(ember, other.ember),
      emberDeep: c(emberDeep, other.emberDeep),
      onEmber: c(onEmber, other.onEmber),
      emberSoft: c(emberSoft, other.emberSoft),
      emberShadow: c(emberShadow, other.emberShadow),
      accent: c(accent, other.accent),
      accentSoft: c(accentSoft, other.accentSoft),
      brass: c(brass, other.brass),
      sage: c(sage, other.sage),
      sageSoft: c(sageSoft, other.sageSoft),
      mutedFill: c(mutedFill, other.mutedFill),
      heatEmpty: c(heatEmpty, other.heatEmpty),
      info: c(info, other.info),
      warn: c(warn, other.warn),
      danger: c(danger, other.danger),
    );
  }
}

extension GymColorsX on BuildContext {
  GymColors get gc => Theme.of(this).extension<GymColors>()!;
}
