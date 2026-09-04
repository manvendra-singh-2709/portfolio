import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/evolution/utils/sizes.dart';

abstract class Body extends PositionComponent {
  Body({required Vector2 position, required Vector2 size, double angle = 0, required this.bodyColor})
    : super(
        position: position,
        size: size,
        angle: angle,
        anchor: Anchor.center,
        priority: RenderPriority.body,
      );

  final Color bodyColor;

  late final Paint bodyPaint;
  late final Paint outlinePaint;

  @override
  Future<void> onLoad() async {
    bodyPaint = Paint()
      ..color = bodyColor
      ..style = PaintingStyle.fill;

    outlinePaint = Paint()
      ..color = outlineColor(Colors.black)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
  }

  static Color outlineColor(Color color) {
    final hsl = HSLColor.fromColor(color);

    return hsl.withLightness((hsl.lightness - 0.20).clamp(0.0, 1.0)).toColor();
  }
}
