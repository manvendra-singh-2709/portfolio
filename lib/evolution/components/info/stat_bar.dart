import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class StatBar extends PositionComponent {
  StatBar({
    required super.position,
    required this.width,
    required this.height,
    required this.value,
    required this.maxValue,
    required this.fillColor,
    this.backgroundColor = const Color(0xFF444444),
    this.outlineColor = Colors.black,
  });

  @override
  final double width;
  @override
  final double height;

  double value;
  double maxValue;

  final Color fillColor;
  final Color backgroundColor;
  final Color outlineColor;

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final bg = Paint()..color = backgroundColor;

    final fill = Paint()..color = fillColor;

    final outline = Paint()
      ..color = outlineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawRect(Rect.fromLTWH(-width / 2, -height / 2, width, height), bg);

    final fillWidth = width * (value / maxValue).clamp(0.0, 1.0);

    canvas.drawRect(Rect.fromLTWH(-width / 2, -height / 2, fillWidth, height), fill);

    canvas.drawRect(Rect.fromLTWH(-width / 2, -height / 2, width, height), outline);
  }
}
