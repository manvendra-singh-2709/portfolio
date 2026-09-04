import 'package:flutter/material.dart';

import 'eye.dart';

class DotEye extends Eye {
  DotEye({required super.position, super.radius});

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final center = Offset(size.x / 2, size.y / 2);

    canvas.drawCircle(center, eyeRadius * 0.30, blackPaint);
  }
}
