import 'package:flame/sprite.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:portfolio/game/components/items/abstracts/enemy.dart';
import 'package:portfolio/game/utils/enums.dart';
import 'package:portfolio/globals/globals.dart';

class ShootingEnemy<T extends Enum> extends Enemy {
  ShootingEnemy({
    super.size,
    super.position,
    super.priority,
    required super.hitbox,
    required super.enemyType, required super.spawnPoint,
  });

  @override
  bool canSeePlayer() {
    final double enemyCenterX = x + width / 2;
    final double enemyCenterY = y + height / 2;
    final double playerCenterX = player.x + player.width / 2;
    final double playerCenterY = player.y + player.height / 2;

    final double dx = playerCenterX - enemyCenterX;
    final double dy = (playerCenterY - enemyCenterY).abs();

    if (dy > visionHeight) return false;

    final bool playerOnRight = dx > 0;
    final bool lookingRight = moveDirection > 0;

    final bool playerVeryClose = dx.abs() <= attackRange;

    final bool playerInFront = playerOnRight == lookingRight && dx.abs() <= visionFrontRange;

    final bool playerBehind = playerOnRight != lookingRight && dx.abs() <= visionBackRange;

    if (!playerVeryClose && !playerInFront && !playerBehind) return false;

    if (!playerInFront && !playerBehind) return false;

    if (hasWallBetween(enemyCenterX, playerCenterX, enemyCenterY)) return false;
    if (hasDropBetween(enemyCenterX, playerCenterX)) return false;

    return true;
  }

  @override
  void collisionWithPlayer() {
    if (!canDamagePlayer || !isAlive) return;

    final double playerLeft = player.x + player.hitbox.offsetX;
    final double playerRight = playerLeft + player.hitbox.width;

    final double enemyLeft = x + hitbox.offsetX;
    final double enemyRight = enemyLeft + hitbox.width;

    final bool isHorizontallyOverEnemy = playerRight > enemyLeft && playerLeft < enemyRight;

    final bool isFallingOntoEnemy = player.velocity.y > 0 && player.y + player.height > y;

    if (isHorizontallyOverEnemy && isFallingOntoEnemy) {
      player.bounceFromEnemy(y + hitbox.offsetY);
      if (Global.playSound) FlameAudio.play(Audio.jumpOnEnemy.name, volume: Global.soundVoulme);
      isAlive = false;
      canDamagePlayer = false;
      aiEnabled = false;

      EnemyState hitState = animationMap.keys.elementAt(1);

      current = hitState;

      final SpriteAnimationTicker hitTicker = animationTickers![hitState]!;

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
