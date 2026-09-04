import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'body.dart';

class OvalBody extends Body {
  OvalBody({required super.position, required super.bodyColor}) : super(size: Vector2(55, 35));

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final Rect ovalRect = Rect.fromLTWH(0, 0, size.x, size.y);

    canvas.drawOval(ovalRect, bodyPaint);
    canvas.drawOval(ovalRect, outlinePaint);
  }
}
