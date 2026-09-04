import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Sense extends PositionComponent {
  Sense({required this.radius, this.show = true, required this.color}) : super(anchor: Anchor.center);

  final double radius;
  final bool show;
  final Color color;

  late final Paint paint = Paint()
    ..color = color.withValues(alpha: 0.15)
    ..style = PaintingStyle.fill;

  late final Paint outline = Paint()
    ..color = color.withValues(alpha: 0.25)
    ..strokeWidth = 1
    ..style = PaintingStyle.stroke;

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (!show) return;

    canvas.drawCircle(Offset.zero, radius, paint);
    canvas.drawCircle(Offset.zero, radius, outline);
  }
}
