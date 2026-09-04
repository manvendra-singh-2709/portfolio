import 'package:flame/extensions.dart';
import 'package:portfolio/evolution/components/creatures/antenna/antenna.dart';

class StraightAntenna extends Antenna {
  StraightAntenna({
    required super.position,
    required super.tipSize,
    required super.tipShape,
    required super.color,
    required super.angle,
  });

  static const double stemLength = 30;

  @override
  void drawStem(Canvas canvas) {
    canvas.drawLine(const Offset(0, 0), const Offset(0, -stemLength), paint);
  }

  @override
  void drawTip(Canvas canvas) {
    canvas.save();
    canvas.translate(0, -(stemLength - 24)); // because base draws tip at y = -24
    super.drawTip(canvas);
    canvas.restore();
  }
}
