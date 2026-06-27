import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:portfolio/game/components/items/hitbox.dart';
import 'package:portfolio/game/components/items/sprite_entity.dart';
import 'package:portfolio/game/components/levels/level.dart';

class Fruit extends SpriteEntity {
  final String fruit;
  final double stepTime = 0.05;
  bool _collected = false;

  late Level level;

  final CustomHitbox hitbox = CustomHitbox(offsetX: 10, offsetY: 10, width: 12, height: 12);

  Fruit({super.position, super.size, required this.fruit});

  @override
  FutureOr<void> onLoad() {
    priority = -1;
    add(
      RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height),
        collisionType: CollisionType.passive,
      ),
    );
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/Fruits/$fruit.png'),
      SpriteAnimationData.sequenced(amount: 17, stepTime: stepTime, textureSize: Vector2.all(32)),
    );
    return super.onLoad();
  }

  void collisionWithPlayer() {
    if (!_collected) {
      animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Items/Fruits/Collected.png'),
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: stepTime,
          textureSize: Vector2.all(32),
          loop: false,
        ),
      );
      _collected = true;
      level.fruitCollected();
    }
    Future.delayed(const Duration(microseconds: 400), () => removeFromParent());
  }
}
