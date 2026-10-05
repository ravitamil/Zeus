import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

final Map<String, Path> _svgPathCache = {};
Path svgPath(String d) => _svgPathCache.putIfAbsent(d, () => parseSvgPathData(d));

class IconPath {
  const IconPath(this.d, {this.fill = false, this.strokeWidth = 2});
  final String d;
  final bool fill;
  final double strokeWidth;
}

class SvgPathIcon extends StatelessWidget {
  const SvgPathIcon(
    this.paths, {
    super.key,
    required this.size,
    required this.color,
    this.viewBox = 24,
  });

  final List<IconPath> paths;
  final double size;
  final Color color;
  final double viewBox;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _IconPainter(paths, color, viewBox)),
    );
  }
}

class _IconPainter extends CustomPainter {
  _IconPainter(this.paths, this.color, this.viewBox);
  final List<IconPath> paths;
  final Color color;
  final double viewBox;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / viewBox;
    canvas.save();
    canvas.scale(scale);
    for (final p in paths) {
      final path = svgPath(p.d);
      final paint = Paint()..color = color;
      if (p.fill) {
        paint.style = PaintingStyle.fill;
      } else {
        paint
          ..style = PaintingStyle.stroke
          ..strokeWidth = p.strokeWidth
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;
      }
      canvas.drawPath(path, paint);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_IconPainter old) =>
      old.color != color || old.paths != paths || old.viewBox != viewBox;
}

class Ic {
  Ic._();
  static const flame = [IconPath('M12 2c1 4-3 5-3 9a3 3 0 0 0 6 0c0-1.5-.5-2-1-3 2 1 3 3 3 5a5 5 0 0 1-10 0c0-5 4-6 5-11z', fill: true)];
  static const play = [IconPath('M8.2 6.1v11.8a1.4 1.4 0 0 0 2.1 1.2l9.2-5.9a1.4 1.4 0 0 0 0-2.4l-9.2-5.9a1.4 1.4 0 0 0-2.1 1.2z', fill: true)];
  static const barbell = [IconPath('M6 4v16M18 4v16M2 9h4M18 9h4M2 15h4M18 15h4M6 12h12', strokeWidth: 2)];
  static const barbellThin = [IconPath('M6 7v10M18 7v10M2 12h4M18 12h4M9 9v6M15 9v6', strokeWidth: 1.8)];
  static const wrench = [IconPath('M14.7 6.3a1 1 0 000 1.4l1.6 1.6a1 1 0 001.4 0l3.77-3.77a6 6 0 01-7.94 7.94l-6.91 6.91a2.12 2.12 0 01-3-3l6.91-6.91a6 6 0 017.94-7.94l-3.76 3.77z', strokeWidth: 2)];
  static const checkBold = [IconPath('M4 12l5 5L20 6', strokeWidth: 3)];
  static const close = [IconPath('M6 6l12 12M18 6L6 18', strokeWidth: 2.5)];
  static const closeThin = [IconPath('M6 6l12 12M18 6L6 18', strokeWidth: 3)];
  static const chevronLeft = [IconPath('M15 18l-6-6 6-6', strokeWidth: 2.5)];
  static const chevronRight = [IconPath('M9 18l6-6-6-6', strokeWidth: 2)];
  static const chevronRightBold = [IconPath('M9 18l6-6-6-6', strokeWidth: 2.5)];
  static const search = [IconPath('M11 11m-7 0a7 7 0 1 0 14 0a7 7 0 1 0 -14 0', strokeWidth: 2), IconPath('M21 21l-4.35-4.35', strokeWidth: 2)];
  static const star = [IconPath('M12 2l3.09 6.26L22 9.27l-5 4.87L18.18 21 12 17.77 5.82 21 7 14.14l-5-4.87 6.91-1.01z', strokeWidth: 1.8)];
  static const trendUp = [IconPath('M4 16l6-6 4 4 6-8', strokeWidth: 3)];
  static const house = [IconPath('M3 11l9-8 9 8M5 10v10h14V10', strokeWidth: 2)];
  static const bars = [IconPath('M4 20V10M12 20V4M20 20v-7', strokeWidth: 2)];
  static const gear = [
    IconPath('M12 12m-3 0a3 3 0 1 0 6 0a3 3 0 1 0 -6 0', strokeWidth: 2),
    IconPath('M19.4 15a1.65 1.65 0 00.33 1.82l.06.06a2 2 0 11-2.83 2.83l-.06-.06a1.65 1.65 0 00-1.82-.33 1.65 1.65 0 00-1 1.51V21a2 2 0 01-4 0v-.09A1.65 1.65 0 009 19.4a1.65 1.65 0 00-1.82.33l-.06.06a2 2 0 11-2.83-2.83l.06-.06A1.65 1.65 0 004.68 15a1.65 1.65 0 00-1.51-1H3a2 2 0 010-4h.09A1.65 1.65 0 004.6 9a1.65 1.65 0 00-.33-1.82l-.06-.06a2 2 0 112.83-2.83l.06.06A1.65 1.65 0 009 4.6a1.65 1.65 0 001-1.51V3a2 2 0 014 0v.09A1.65 1.65 0 0015.4 4.6a1.65 1.65 0 001.82.33l.06-.06a2 2 0 112.83 2.83l-.06.06A1.65 1.65 0 0019.4 9a1.65 1.65 0 001.51 1H21a2 2 0 010 4h-.09a1.65 1.65 0 00-1.51 1z', strokeWidth: 2),
  ];
  static const toolCard = [IconPath('M4 4h16v16H4z'), IconPath('M8 9h8M8 13h5')];
  static const layers = [IconPath('M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5', strokeWidth: 2)];
  static const clock = [IconPath('M12 2a10 10 0 100 20 10 10 0 000-20zM12 6v6l4 2', strokeWidth: 2)];
  static const noAds = [IconPath('M4.9 4.9l14.2 14.2M12 2v2M12 20v2M2 12h2M20 12h2', strokeWidth: 2)];
  static const plus = [IconPath('M12 5v14M5 12h14', strokeWidth: 2.5)];

  // Measurements & Body parts
  static const tapeMeasure = [
    IconPath('M9 3h6a6 6 0 0 1 6 6v0a6 6 0 0 1-6 6H9a6 6 0 0 1-6-6v0a6 6 0 0 1 6-6z', strokeWidth: 1.8),
    IconPath('M12 7a2 2 0 1 0 0 4 2 2 0 0 0 0-4z', strokeWidth: 1.8),
    IconPath('M9 15v4a2 2 0 0 0 2 2h8', strokeWidth: 1.8),
    IconPath('M12 18v3M15 19v2M18 18v3', strokeWidth: 1.4),
  ];
  static const bodyNeck = [
    IconPath('M5 21c2-3.5 3.5-5 3.5-8V6a3.5 3.5 0 0 1 7 0v7c0 3 1.5 4.5 3.5 8', strokeWidth: 1.8),
    IconPath('M8 12c2 1.5 6 1.5 8 0', strokeWidth: 1.8),
    IconPath('M10 11.5v1.2M12 12v1.2M14 11.5v1.2', strokeWidth: 1.4),
  ];
  static const bodyShoulders = [
    IconPath('M3 18c.5-4.5 3.5-7 7.5-8l1.5-2 1.5 2c4 1 7 3.5 7.5 8', strokeWidth: 1.8),
    IconPath('M2 12h20', strokeWidth: 1.8),
    IconPath('M4 10l-2 2 2 2M20 10l2 2-2 2', strokeWidth: 1.6),
  ];
  static const bodyChest = [
    IconPath('M4 6v5c0 4.5 3.5 7 8 7s8-2.5 8-7V6', strokeWidth: 1.8),
    IconPath('M12 8v10', strokeWidth: 1.4),
    IconPath('M3 11c3 1.5 6 2 9 2s6-.5 9-2', strokeWidth: 1.8),
    IconPath('M7 11.5v1.5M12 12v1.5M17 11.5v1.5', strokeWidth: 1.4),
  ];
  static const bodyArm = [
    IconPath('M4 17c1-5 2.5-7 5-7 2 0 3 1.8 4 1.8 1.5 0 3.5-3 5-3 2 0 3 2 3 4.5 0 3.5-2.5 5.5-5 6.5l-4 .5c-3 0-6-1-8-3.3z', strokeWidth: 1.8),
    IconPath('M7 11c1.5 1.5 4 1.5 5.5 0', strokeWidth: 1.8),
    IconPath('M8.5 11.5v1M11 11.5v1', strokeWidth: 1.4),
  ];
  static const bodyForearm = [
    IconPath('M7 4c.8 4 1.5 8 1.5 13 0 2 1.2 3.5 3.5 3.5s3.5-1.5 3.5-3.5c0-5 .7-9 1.5-13', strokeWidth: 1.8),
    IconPath('M7.5 9c2.5 1.2 6.5 1.2 9 0', strokeWidth: 1.8),
    IconPath('M10 8.8v1.4M12 9.2v1.4M14 8.8v1.4', strokeWidth: 1.4),
  ];
  static const bodyWaist = [
    IconPath('M5 4c3 3 3 6.5 1 11.5-1 2-1 3.5 0 4.5M19 4c-3 3-3 6.5-1 11.5 1 2 1 3.5 0 4.5', strokeWidth: 1.8),
    IconPath('M4 12c3.5 2 12.5 2 16 0', strokeWidth: 1.8),
    IconPath('M12 13v5M10.5 18h3', strokeWidth: 1.5),
    IconPath('M8 12.5v1M16 12.5v1', strokeWidth: 1.4),
  ];
  static const bodyHips = [
    IconPath('M7 4c0 3.5-1.5 6-3.5 9.5-1 2-1 4 0 6.5M17 4c0 3.5 1.5 6 3.5 9.5 1 2 1 4 0 6.5', strokeWidth: 1.8),
    IconPath('M3 14c4 2 14 2 18 0', strokeWidth: 1.8),
    IconPath('M2 14h2M20 14h2', strokeWidth: 2),
  ];
  static const bodyThigh = [
    IconPath('M6 3c2 4 3 9.5 2 15 0 2 1 3 3 3M18 3c-1.5 3-1.5 7.5 0 12 0 3-1 4.5-3 6', strokeWidth: 1.8),
    IconPath('M7 9c3 1.5 7 1.5 10 0', strokeWidth: 1.8),
    IconPath('M10 9.5v1.2M12 9.8v1.2M14 9.5v1.2', strokeWidth: 1.4),
  ];
  static const bodyCalf = [
    IconPath('M8 3v4c-2.2 2-3 5-1 8 1 2 1 3.5 1 6M16 3v4c1.2 2 2 4 1 7-.8 2-1 3.5-1 6', strokeWidth: 1.8),
    IconPath('M6 11c3 1.5 7 1.5 10 0', strokeWidth: 1.8),
    IconPath('M9 11.5v1.2M11 11.8v1.2M13 11.5v1.2', strokeWidth: 1.4),
  ];
  static const bodyFat = [
    IconPath('M7 4c2 3 4 5 5 8-1 3-3 5-5 8M17 4c-2 3-4 5-5 8 1 3 3 5 5 8', strokeWidth: 1.8),
    IconPath('M8 12h8', strokeWidth: 1.8),
    IconPath('M12 9.5v5', strokeWidth: 1.4),
    IconPath('M12 11a1 1 0 1 0 0 2 1 1 0 0 0 0-2z', fill: true),
  ];
}

List<IconPath> bodyMeasureIcon(String key) => switch (key) {
      'neck' => Ic.bodyNeck,
      'shoulders' => Ic.bodyShoulders,
      'chest' => Ic.bodyChest,
      'arm' => Ic.bodyArm,
      'forearm' => Ic.bodyForearm,
      'waist' => Ic.bodyWaist,
      'hips' => Ic.bodyHips,
      'thigh' => Ic.bodyThigh,
      'calf' => Ic.bodyCalf,
      'bodyfat' => Ic.bodyFat,
      _ => Ic.tapeMeasure,
    };

Color bodyMeasureColor(String key) => switch (key) {
      'neck' => const Color(0xFF26C6DA),
      'shoulders' => const Color(0xFF3B82F6),
      'chest' => const Color(0xFFFF6B6B),
      'arm' => const Color(0xFF8B5CF6),
      'forearm' => const Color(0xFF6366F1),
      'waist' => const Color(0xFFF59E0B),
      'hips' => const Color(0xFFEC4899),
      'thigh' => const Color(0xFF10B981),
      'calf' => const Color(0xFF14B8A6),
      'bodyfat' => const Color(0xFFFF8C42),
      _ => const Color(0xFFD9A184),
    };
