import 'package:portfolio/game/components/items/abstracts/enemy.dart';

class SimpleEnemy<T extends Enum> extends Enemy {
  SimpleEnemy({required super.hitbox, required super.enemyType, required super.spawnPoint});

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
}
