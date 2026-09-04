import 'package:flutter/material.dart';
import 'package:flame/components.dart';

import 'body.dart';

class SquareBody extends Body {
  SquareBody({required super.position, required super.bodyColor}) : super(size: Vector2(42, 42));

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final rect = Rect.fromLTWH(0, 0, size.x, size.y);

    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(4));

    canvas.drawRRect(rrect, bodyPaint);
    canvas.drawRRect(rrect, outlinePaint);
  }
}
