import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/evolution/utils/sizes.dart';

abstract class Eye extends PositionComponent {
  Eye({required Vector2 position, double radius = 8, double angle = 0})
    : eyeRadius = radius,
      super(
        position: position,
        size: Vector2.all(radius * 2),
        angle: angle,
        anchor: Anchor.center,
        priority: RenderPriority.eye,
      );

  final double eyeRadius;

  late final Paint whitePaint;
  late final Paint outlinePaint;
  late final Paint blackPaint;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    outlinePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    blackPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final center = Offset(size.x / 2, size.y / 2);

    canvas.drawCircle(center, eyeRadius, whitePaint);
    canvas.drawCircle(center, eyeRadius, outlinePaint);
  }
}
