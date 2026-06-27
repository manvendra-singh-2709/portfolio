import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:portfolio/game/components/items/game_entity.dart';
import 'package:portfolio/game/utils/enums.dart';

class Saw extends GameEntity<SawState> {
  late final SpriteAnimation onAnimation;
  late final SpriteAnimation offAnimation;

  static final double sawSpeed = 0.03;
  static final double moveSpeed = 50;
  static final double tileSize = 16;

  double moveDirection = 1;
  double rangeNeg = 0;
  double rangePos = 0;

  bool on = true;

  final bool isVertical;
  final double offNeg;
  final double offPos;

  Saw({super.position, super.size, required this.isVertical, required this.offNeg, required this.offPos});

  @override
  FutureOr<void> onLoad() {
    priority = -1;
    _loadAllAnimations();
    add(CircleHitbox());

    if (isVertical) {
      rangeNeg = position.y - offNeg * tileSize;
      rangePos = position.y + offNeg * tileSize;
    } else {
      rangeNeg = position.x - offNeg * tileSize;
      rangePos = position.x + offNeg * tileSize;
    }
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (isVertical) {
      _moveVertically(dt);
    } else {
      _moveHorizontally(dt);
    }
    super.update(dt);
  }

  void _moveVertically(double dt) {
    if (position.y >= rangePos) {
      moveDirection = -1;
    } else if (position.y <= rangeNeg) {
      moveDirection = 1;
    }
    position.y += moveDirection * moveSpeed * dt;
  }

  void _moveHorizontally(double dt) {
    if (position.x >= rangePos) {
      moveDirection = -1;
    } else if (position.x <= rangeNeg) {
      moveDirection = 1;
    }
    position.x += moveDirection * moveSpeed * dt;
  }

  SpriteAnimation _spriteAnimation({required SawState sawState}) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Traps/Saw/${sawState.name}.png'),
      SpriteAnimationData.sequenced(
        amount: sawState.frames,
        stepTime: sawSpeed,
        textureSize: Vector2.all(38),
        loop: sawState.loop,
      ),
    );
  }

  void _loadAllAnimations() {
    onAnimation = _spriteAnimation(sawState: SawState.on);
    offAnimation = _spriteAnimation(sawState: SawState.off);

    animations = {SawState.on: onAnimation, SawState.off: offAnimation};

    current = on ? SawState.on : SawState.off;
  }
}
