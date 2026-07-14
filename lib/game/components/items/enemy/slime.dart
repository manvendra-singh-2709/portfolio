import 'package:flame/sprite.dart';

import 'package:portfolio/game/components/items/abstracts/simple_enemy.dart';
import 'package:portfolio/game/components/items/hitbox.dart';
import 'package:portfolio/game/utils/enums.dart';

class Slime extends SimpleEnemy<EnemyState> {
  static final SpriteAnimation? idleAnimation = null;
  static final SpriteAnimation? runningAnimation = null;
  static final SpriteAnimation? hitAnimation = null;

  Slime({
    super.priority,
    super.position,
    super.size,
    super.enemyType = EnemyType.slime,
    super.hitbox = const CustomHitbox(offsetX: 6, offsetY: 6, width: 20, height: 22),
    required super.spawnPoint,
  }) {
    animationMap = {
      EnemyState.idle: idleAnimation,
      EnemyState.hit: hitAnimation,
      EnemyState.run: runningAnimation,
    };
  }
}
