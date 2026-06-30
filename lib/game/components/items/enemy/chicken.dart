import 'package:flame/sprite.dart';

import 'package:portfolio/game/components/items/abstracts/enemy.dart';
import 'package:portfolio/game/components/items/hitbox.dart';
import 'package:portfolio/game/utils/enums.dart';

class Chicken extends Enemy<EnemyState> {
  static final SpriteAnimation? idleAnimation = null;
  static final SpriteAnimation? runningAnimation = null;
  static final SpriteAnimation? hitAnimation = null;

  Chicken({
    super.position,
    super.size,
    super.offNeg,
    super.offPos,
    super.shouldPatrol,
    super.deadDamage,
    super.undead,
    super.priority,
    super.hitbox = const CustomHitbox(offsetX: 6, offsetY: 6, width: 20, height: 22),
    super.enemyType = EnemyType.chicken,
  }) {
    animationMap = {
      EnemyState.idle: idleAnimation,
      EnemyState.hit: hitAnimation,
      EnemyState.run: runningAnimation,
    };
  }
}
