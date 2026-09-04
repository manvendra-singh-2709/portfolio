import 'dart:math';

import 'package:flutter/material.dart';

import 'eye.dart';

class SlantedEye extends Eye {
  SlantedEye({required super.position, super.radius, this.eyeAngle = pi / 4});

  final double eyeAngle;

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final center = Offset(size.x / 2, size.y / 2);

    final halfLength = eyeRadius * 0.4;

    final dx = cos(eyeAngle) * halfLength;
    final dy = sin(eyeAngle) * halfLength;

    canvas.drawLine(
      Offset(center.dx - dx, center.dy - dy),
      Offset(center.dx + dx, center.dy + dy),
      outlinePaint,
    );
  }
}
