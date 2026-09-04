import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/evolution/world/hex_grid.dart';

import 'hex_tile.dart';

class HexComponent extends PositionComponent {
  HexComponent({required this.tile, required this.radius, this.showBorder = false, required this.grid})
    : super(position: tile.center, anchor: Anchor.center);

  final HexTile tile;
  final double radius;
  final HexGrid grid;

  final bool showBorder;

  late final Paint fillPaint = Paint()..style = PaintingStyle.fill;

  late final Paint borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0
    ..color = Colors.black.withValues(alpha: 0.18);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    size = Vector2.all(radius * 2);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    fillPaint.color = tile.color;
    const double overlap = 0.6;

    final Path path = Path();

    final List<Offset> points = <Offset>[];

    // Pointy-top hexagon
    for (int i = 0; i < 6; i++) {
      final double angle = pi / 180 * (60 * i - 30);

      final double x = (radius + overlap) * cos(angle);
      final double y = (radius + overlap) * sin(angle);

      points.add(Offset(x, y));

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();

    canvas.drawPath(path, fillPaint);

    if (showBorder) {
      canvas.drawPath(path, borderPaint);
    }
  }
}
