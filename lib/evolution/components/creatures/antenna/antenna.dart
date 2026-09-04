import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/evolution/utils/enums.dart';
import 'package:portfolio/evolution/utils/sizes.dart';

abstract class Antenna extends PositionComponent {
  Antenna({
    required super.position,
    required this.tipShape,
    required this.tipSize,
    required this.color,
    required super.angle,
  }) : super(anchor: Anchor.bottomCenter, priority: RenderPriority.antenna);

  final ANTENNA_SHAPE tipShape;
  final double tipSize;
  final Color color;

  late final Paint outlinePaint = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1;

  late final Paint paint = Paint()
    ..color = Colors.black
    ..strokeWidth = 2
    ..style = PaintingStyle.stroke;

  late final Paint fillPaint = Paint()
    ..color = color
    ..style = PaintingStyle.fill;

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    drawStem(canvas);
    drawTip(canvas);
  }

  void drawStem(Canvas canvas);

  void drawTip(Canvas canvas) {
    const Offset center = Offset(0, -24);

    switch (tipShape) {
      case ANTENNA_SHAPE.oval:
        canvas.drawCircle(center, tipSize, fillPaint);
        canvas.drawCircle(center, tipSize, outlinePaint);
        break;

      case ANTENNA_SHAPE.square:
        final rect = Rect.fromCenter(center: center, width: tipSize * 2, height: tipSize * 2);

        canvas.drawRect(rect, fillPaint);
        canvas.drawRect(rect, outlinePaint);
        break;

      case ANTENNA_SHAPE.triangle:
        final Path path = Path()
          ..moveTo(center.dx, center.dy - tipSize)
          ..lineTo(center.dx + tipSize, center.dy + tipSize)
          ..lineTo(center.dx - tipSize, center.dy + tipSize)
          ..close();

        canvas.drawPath(path, fillPaint);
        canvas.drawPath(path, outlinePaint);
        break;
    }
  }
}
