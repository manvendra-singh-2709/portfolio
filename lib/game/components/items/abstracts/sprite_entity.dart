import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:portfolio/game/pixel_adventure.dart';

abstract class SpriteEntity extends SpriteAnimationComponent
    with HasGameReference<PixelAdventure>, CollisionCallbacks {
  late TiledObject spawnPoint;

  SpriteEntity({super.position, super.size, super.priority, required this.spawnPoint}) {
    position = Vector2(spawnPoint.x, spawnPoint.y);
    size = Vector2(spawnPoint.width, spawnPoint.height);
  }
}
