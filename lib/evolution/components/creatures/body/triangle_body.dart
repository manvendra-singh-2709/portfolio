import 'package:flutter/material.dart';
import 'package:flame/components.dart';

import 'body.dart';

class TriangleBody extends Body {
  TriangleBody({required super.position, required super.bodyColor}) : super(size: Vector2(50, 45));

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final path = Path()
      ..moveTo(size.x / 2, 0)
      ..lineTo(size.x, size.y)
      ..lineTo(0, size.y)
      ..close();

    canvas.drawPath(path, bodyPaint);
    canvas.drawPath(path, outlinePaint);
  }
}
