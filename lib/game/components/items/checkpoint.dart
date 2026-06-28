import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:portfolio/game/components/items/abstracts/game_entity.dart';
import 'package:portfolio/game/components/items/player.dart';
import 'package:portfolio/game/utils/enums.dart';

class Checkpoint extends GameEntity<CheckpointState> {
  late final SpriteAnimation noFlagAnimation;
  late final SpriteAnimation flagOutAnimation;
  late final SpriteAnimation flagIdleAnimation;

  bool reachedCheckpoint = false;

  Checkpoint({super.position, super.size});

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    add(
      RectangleHitbox(
        position: Vector2(18, 18),
        size: Vector2(12, 46),
        collisionType: CollisionType.passive,
      ),
    );
    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player && !reachedCheckpoint) _reachedCheckPoint(other);
    super.onCollision(intersectionPoints, other);
  }

  void _reachedCheckPoint(Player player) {
    reachedCheckpoint = true;
    player.checkpointPosition = player.position;
    current = CheckpointState.flagOut;

    final SpriteAnimationTicker flagOutAnimation = animationTickers![CheckpointState.flagOut]!;
    flagOutAnimation.completed.whenComplete(() {
      current = CheckpointState.flagIdle;
      flagOutAnimation.reset();
    });
  }

  SpriteAnimation _spriteAnimation({required CheckpointState checkpointState}) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/Checkpoints/Checkpoint/Checkpoint ${checkpointState.name}.png'),
      SpriteAnimationData.sequenced(
        amount: checkpointState.frames,
        stepTime: stepTime,
        textureSize: Vector2.all(64),
        loop: checkpointState.loop,
      ),
    );
  }

  void _loadAllAnimations() {
    noFlagAnimation = _spriteAnimation(checkpointState: CheckpointState.noFlag);
    flagOutAnimation = _spriteAnimation(checkpointState: CheckpointState.flagOut);
    flagIdleAnimation = _spriteAnimation(checkpointState: CheckpointState.flagIdle);

    animations = {
      CheckpointState.noFlag: noFlagAnimation,
      CheckpointState.flagOut: flagOutAnimation,
      CheckpointState.flagIdle: flagIdleAnimation,
    };

    current = CheckpointState.noFlag;
  }
}
