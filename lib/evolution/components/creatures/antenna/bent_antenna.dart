import 'package:flame/extensions.dart';
import 'package:portfolio/evolution/components/creatures/antenna/antenna.dart';

class BentAntenna extends Antenna {
  BentAntenna({
    required super.position,
    required super.tipSize,
    required super.tipShape,
    required super.color,
    required this.outward,
    required super.angle,
  });

  final bool outward;

  @override
  void drawStem(Canvas canvas) {
    const double stemLength = 18;
    const double tipHeight = 30;

    final double dx = outward ? 8 : -8;

    final Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(0, -stemLength)
      ..lineTo(dx, -tipHeight);

    canvas.drawPath(path, paint);
  }

  @override
  void drawTip(Canvas canvas) {
    canvas.save();

    const double tipHeight = 30;

    canvas.translate(outward ? 8 : -8, -(tipHeight - 24));

    super.drawTip(canvas);
    canvas.restore();
  }
}
