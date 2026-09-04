import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/evolution/utils/sizes.dart';

class Leg extends PositionComponent {
  Leg({required super.position, this.length = 20, this.left = true, this.color = Colors.black})
    : super(anchor: Anchor.topCenter, priority: RenderPriority.leg) {
    angle = left ? -pi / 6 : pi / 6;
  }

  final double length;
  final bool left;
  final Color color;

  late final Paint paint = Paint()
    ..color = color
    ..strokeWidth = 2
    ..strokeCap = StrokeCap.round;

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    canvas.drawLine(Offset.zero, Offset(0, length), paint);
  }
}
