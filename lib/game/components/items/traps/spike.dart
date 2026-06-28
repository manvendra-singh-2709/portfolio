import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:portfolio/game/components/items/hitbox.dart';
import 'package:portfolio/game/components/items/abstracts/sprite_entity.dart';

class Spike extends SpriteEntity {
  static const double moveDistance = 16;
  static const double moveSpeed = 20;
  static const int waitMs = 500;

  late final Vector2 startPosition;
  late final Vector2 downPosition;

  bool movingDown = true;
  bool waiting = false;

  final CustomHitbox hitbox = CustomHitbox(offsetX: 0, offsetY: 8, width: 16, height: 8);

  Spike({super.position, super.size});

  @override
  FutureOr<void> onLoad() {
    priority = -1;

    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Traps/Spikes/Idle.png'),
      SpriteAnimationData.sequenced(amount: 1, stepTime: 1, textureSize: Vector2.all(16)),
    );

    startPosition = position.clone();
    downPosition = startPosition + Vector2(0, moveDistance);

    add(
      RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height),
        collisionType: CollisionType.passive,
      ),
    );

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (waiting) {
      super.update(dt);
      return;
    }

    final target = movingDown ? downPosition : startPosition;

    position.moveToTarget(target, moveSpeed * dt);

    if ((position - target).length < 0.5) {
      position = target.clone();
      waiting = true;

      Future.delayed(const Duration(milliseconds: waitMs), () {
        movingDown = !movingDown;
        waiting = false;
      });
    }

    super.update(dt);
  }
}
