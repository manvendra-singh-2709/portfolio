import 'package:flutter/material.dart';

import 'eye.dart';

class HappyEye1 extends Eye {
  HappyEye1({required super.position, super.radius});

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final center = Offset(size.x / 2, size.y / 2);

    final w = eyeRadius * 0.45;
    final h = eyeRadius * 0.35;

    canvas.drawLine(Offset(center.dx - w, center.dy + h), Offset(center.dx, center.dy - h), outlinePaint);

    canvas.drawLine(Offset(center.dx, center.dy - h), Offset(center.dx + w, center.dy + h), outlinePaint);
  }
}
