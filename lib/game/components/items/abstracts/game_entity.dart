import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:portfolio/game/pixel_adventure.dart';

abstract class GameEntity<T extends Enum> extends SpriteAnimationGroupComponent<T>
    with HasGameReference<PixelAdventure>, CollisionCallbacks, KeyboardHandler {
  double _moveSpeed = 100;

  int _lives = 5;

  int get lives => _lives;

  double get stepTime => 0.05;
  double get gravity => 9.8;
  double get jumpForce => 250;
  double get terminalVelocity => 300;
  double get moveSpeed => _moveSpeed;
  double get tileSize => 16;
  double get directionLockDuration => 0.25;

  double directionLockTimer = 0;
  double horizontalMovement = 0;
  double keyboardHorizontalMovement = 0;
  double joystickHorizontalMovement = 0;

  set lives(int value) {
    if (value >= 0) {
      _lives = value;
    }
  }

  set moveSpeed(double value) {
    if (value >= 0) {
      _moveSpeed = value;
    }
  }

  late TiledObject spawnPoint;

  GameEntity({super.position, super.size, super.priority, required this.spawnPoint}) {
    position = Vector2(spawnPoint.x, spawnPoint.y);
    size = Vector2(spawnPoint.width, spawnPoint.height);
  }

  void setSpawnPoint(TiledObject tiledObject) {
    spawnPoint = tiledObject;
    position = Vector2(spawnPoint.x, spawnPoint.y);
    size = Vector2(spawnPoint.width, spawnPoint.height);
  }
}
