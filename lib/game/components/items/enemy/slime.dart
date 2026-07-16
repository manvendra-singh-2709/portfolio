import 'package:flame/sprite.dart';

import 'package:portfolio/game/components/items/abstracts/simple_enemy.dart';
import 'package:portfolio/game/components/items/hitbox.dart';
import 'package:portfolio/game/utils/enums.dart';

class Slime extends SimpleEnemy<EnemyState> {
  static final SpriteAnimation? idleRunAnimation = null;
  static final SpriteAnimation? hitAnimation = null;

  Slime({
    super.enemyType = EnemyType.slime,
    super.hitbox = const CustomHitbox(offsetX: 6, offsetY: 6, width: 20, height: 22),
    required super.spawnPoint,
  }) {
    shouldPatrol = true;
    moveSpeed /= 2;
    runIndex = 0;
    animationMap = {EnemyState.idleRun: idleRunAnimation, EnemyState.hit: hitAnimation};
  }
}
