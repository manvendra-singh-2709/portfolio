import 'package:flame/input.dart';

class BodySize {
  static Vector2 xs = Vector2.all(24);
  static Vector2 s = Vector2.all(36);
  static Vector2 m = Vector2.all(48);
  static Vector2 l = Vector2.all(60);
  static Vector2 xl = Vector2.all(72);
}

class EyeSize {
  static const double xs = 2;
  static const double s = 4;
  static const double m = 6;
  static const double l = 8;
  static const double xl = 10;
}

class AntennaSize {
  static const double xs = 2;
  static const double s = 3;
  static const double m = 4;
  static const double l = 5;
  static const double xl = 6;
}

class RenderPriority {
  static const int leg = 0;
  static const int antenna = 10;
  static const int body = 20;
  static const int eye = 30;
  static const int berry = 40;
  static const int regionElement = 50;
}
