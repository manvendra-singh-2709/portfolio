import 'package:flutter/material.dart';

import 'eye.dart';

class NeutralEye extends Eye {
  NeutralEye({required super.position, super.radius});

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final center = Offset(size.x / 2, size.y / 2);
    final halfLength = eyeRadius * 0.8 / 2;

    canvas.drawLine(
      Offset(center.dx - halfLength, center.dy),
      Offset(center.dx + halfLength, center.dy),
      outlinePaint,
    );
  }
}
