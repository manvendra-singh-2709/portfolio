import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:portfolio/game/pixel_adventure.dart';

abstract class GameEntity<T> extends SpriteAnimationGroupComponent<T>
    with HasGameReference<PixelAdventure>, CollisionCallbacks, KeyboardHandler {
  GameEntity({super.position, super.size, super.priority});
}
