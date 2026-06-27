import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:portfolio/game/pixel_adventure.dart';

abstract class SpriteEntity extends SpriteAnimationComponent
    with HasGameReference<PixelAdventure>, CollisionCallbacks {
  SpriteEntity({
    super.position,
    super.size,
    super.priority,
  });
}