import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:portfolio/game/components/items/game_entity.dart';
import 'package:portfolio/game/components/items/hitbox.dart';
import 'package:portfolio/game/utils/enums.dart';

class Fan extends GameEntity<FanState>{
  late final SpriteAnimation onAnimation;
  late final SpriteAnimation offAnimation;

  final double stepTime = 0.05;
  bool on;
  bool canToggle = true;

  final CustomHitbox hitbox = CustomHitbox(offsetX: 0, offsetY: 0, width: 24, height: 8);

  Fan({super.position, super.size, required this.on});

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();

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
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (!canToggle) return;

    canToggle = false;

    on = !on;
    current = on ? FanState.on : FanState.off;

    Future.delayed(const Duration(milliseconds: 300), () => canToggle = true);

    super.onCollision(intersectionPoints, other);
  }

  SpriteAnimation _spriteAnimation({required FanState fanState}) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Traps/Fan/${fanState.name}.png'),
      SpriteAnimationData.sequenced(
        amount: fanState.frames,
        stepTime: stepTime,
        textureSize: Vector2(24, 8),
        loop: fanState.loop,
      ),
    );
  }

  void _loadAllAnimations() {
    onAnimation = _spriteAnimation(fanState: FanState.on);
    offAnimation = _spriteAnimation(fanState: FanState.off);

    animations = {FanState.on: onAnimation, FanState.off: offAnimation};

    current = on ? FanState.on : FanState.off;
  }
}
