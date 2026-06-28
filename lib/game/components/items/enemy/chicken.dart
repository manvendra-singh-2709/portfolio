import 'package:flame/sprite.dart';
import 'package:flame_audio/flame_audio.dart';

import 'package:portfolio/game/components/items/abstracts/enemy.dart';
import 'package:portfolio/game/components/items/hitbox.dart';
import 'package:portfolio/game/utils/enums.dart';
import 'package:portfolio/globals/globals.dart';

class Chicken extends Enemy<EnemyState> {
  static final SpriteAnimation? idleAnimation = null;
  static final SpriteAnimation? runningAnimation = null;
  static final SpriteAnimation? hitAnimation = null;

  @override
  Map<EnemyState, SpriteAnimation?> animationMap = {
    EnemyState.idle: idleAnimation,
    EnemyState.run: runningAnimation,
    EnemyState.hit: hitAnimation,
  };

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
  });

  @override
  void collisionWithPlayer() {
    if (!canDamagePlayer || !isAlive) return;

    if (player.velocity.y > 0 && player.y + player.height > y) {
      player.hasJumped = true;
      if (Global.playSound) FlameAudio.play(Audio.jumpOnEnemy.name, volume: Global.soundVoulme);
      isAlive = false;
      canDamagePlayer = false;
      aiEnabled = false;

      current = EnemyState.hit;

      final SpriteAnimationTicker hitTicker = animationTickers![EnemyState.hit]!;

      hitTicker.reset();

      hitTicker.completed.whenComplete(() {
        hitTicker.reset();
        removeFromParent();
      });

      return;
    }

    disableDamageTemporarily();
    player.collisionWithEnemy();
  }
}
