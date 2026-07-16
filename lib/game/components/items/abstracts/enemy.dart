import 'dart:async';
import 'dart:math' as math;

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame_audio/flame_audio.dart';

import 'package:portfolio/game/components/collisions/blocks.dart';
import 'package:portfolio/game/components/items/hitbox.dart';
import 'package:portfolio/game/components/items/player.dart';
import 'package:portfolio/game/utils/enums.dart';
import 'package:portfolio/globals/globals.dart';
import 'package:portfolio/game/components/items/abstracts/game_entity.dart';

abstract class Enemy<T extends Enum> extends GameEntity<EnemyState> {
  final EnemyType enemyType;

  Enemy({required super.spawnPoint, required this.hitbox, required this.enemyType}) {
    offNeg = spawnPoint.properties.getProperty('offNeg')!.value as double;
    offPos = spawnPoint.properties.getProperty('offPos')!.value as double;
    shouldPatrol = spawnPoint.properties.getProperty('patrol')!.value as bool;
    undead = spawnPoint.properties.getProperty('undead')!.value as bool;
    deadDamage = spawnPoint.properties.getProperty('deadDamage')!.value as bool;
    position = Vector2(spawnPoint.x, spawnPoint.y);
    size = Vector2(spawnPoint.width, spawnPoint.height);
  }

  bool? shouldPatrol;
  bool? undead;
  bool? deadDamage;
  bool canDamagePlayer = true;
  bool isAlive = true;
  bool aiEnabled = true;
  bool isChasing = false;
  bool lastWallAhead = false;
  bool lastGroundAhead = false;
  bool lastCanSeePlayer = false;

  CustomHitbox hitbox = CustomHitbox(offsetX: 6, offsetY: 6, width: 20, height: 22);

  late final Player player;

  double? offPos;
  double? offNeg;
  double rangeNeg = 0;
  double rangePos = 0;
  double attackRange = 18;
  double moveDirection = 1;
  double visionRange = 160;
  double visionHeight = 16;
  double visionFrontRange = Global.visionFrontRange;
  double visionBackRange = Global.visionBackRange;

  int runIndex = 2;

  Map<EnemyState, SpriteAnimation?> animationMap = {};

  double runSpeed = 60;
  double get patrolSpeed => runSpeed / 2;

  void disableDamageTemporarily() {
    canDamagePlayer = false;
    aiEnabled = false;

    Future<void>.delayed(const Duration(milliseconds: 800), () {
      canDamagePlayer = true;
      aiEnabled = true;
    });
  }

  @override
  FutureOr<void> onLoad() {
    player = game.player;
    rangePos = position.x + offPos! * tileSize;
    rangeNeg = position.x - offNeg! * tileSize;

    _loadAllAnimations();

    add(
      RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height),
      ),
    );

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (!isAlive) {
      super.update(dt);
      return;
    }
    if (directionLockTimer > 0) {
      directionLockTimer -= dt;
    }

    lastCanSeePlayer = canSeePlayer();
    lastWallAhead = _hasWallAhead();
    lastGroundAhead = _hasGroundAhead();

    _updateEnemyMovement(dt);
    _updateEnemyState();

    super.update(dt);
  }

  void _updateEnemyMovement(double dt) {
    if (!aiEnabled) {
      position.x += moveDirection * patrolSpeed * dt;
      return;
    }

    isChasing = lastCanSeePlayer;

    if (isChasing) {
      final double enemyCenterX = x + width / 2;
      final double playerCenterX = player.x + player.width / 2;
      final double dx = playerCenterX - enemyCenterX;

      if (dx.abs() > attackRange) {
        moveDirection = dx < 0 ? -1 : 1;
      }
    } else if (!shouldPatrol!) {
      current = animationMap.keys.first;
      return;
    }

    final bool shouldTurnAround = isChasing ? false : _isAtPatrolEdge() || lastWallAhead || !lastGroundAhead;

    if (shouldTurnAround && directionLockTimer <= 0) {
      moveDirection *= -1;
      directionLockTimer = directionLockDuration;
      isChasing = false;

      if (!shouldPatrol!) {
        current = animationMap.keys.first;
        return;
      }
    }

    final double speed = isChasing ? runSpeed : patrolSpeed;
    position.x += moveDirection * speed * dt;
  }

  void _updateEnemyState() {
    if (!isChasing && !shouldPatrol!) {
      current = animationMap.keys.first;
    } else {
      current = animationMap.keys.elementAt(runIndex);
    }

    if ((moveDirection < 0 && scale.x < 0) || (position.x <= rangeNeg || position.x >= rangePos)) {
      flipHorizontallyAroundCenter();
    } else if ((moveDirection > 0 && scale.x > 0) || (position.x <= rangeNeg || position.x >= rangePos)) {
      flipHorizontallyAroundCenter();
    }
  }

  bool _isAtPatrolEdge() {
    if (!shouldPatrol! && !isChasing) return false;

    if (position.x <= rangeNeg && moveDirection < 0) {
      position.x = rangeNeg;
      return true;
    }

    if (position.x >= rangePos && moveDirection > 0) {
      position.x = rangePos;
      return true;
    }

    return false;
  }

  bool _hasWallAhead() {
    final double probeX = moveDirection > 0 ? x + hitbox.offsetX : x + hitbox.offsetX;
    final double probeY = y + hitbox.offsetY + 6;

    return _pointInsideSolidBlock(probeX, probeY);
  }

  bool _hasGroundAhead() {
    final double probeX = moveDirection > 0 ? x + hitbox.offsetX : x + hitbox.offsetX;
    final double probeY = y + hitbox.offsetY + hitbox.height + 4;

    return _pointInsideSolidBlock(probeX, probeY);
  }

  bool hasWallBetween(double startX, double endX, double yPosition) {
    final double minX = math.min(startX, endX);
    final double maxX = math.max(startX, endX);

    for (final CollisionBlock block in player.collisionBlocks) {
      if (block.isPlatform) continue;

      final bool overlapsX = block.x < maxX && block.x + block.width > minX;

      final bool overlapsY = yPosition >= block.y && yPosition <= block.y + block.height;

      if (overlapsX && overlapsY) {
        return true;
      }
    }

    return false;
  }

  bool hasDropBetween(double startX, double endX) {
    final double minX = math.min(startX, endX);
    final double maxX = math.max(startX, endX);
    final double step = 8;

    double checkX = minX;

    while (checkX <= maxX) {
      final double groundY = y + height + 6;

      if (!_pointInsideSolidBlock(checkX, groundY)) {
        return true;
      }

      checkX += step;
    }

    return false;
  }

  bool _pointInsideSolidBlock(double px, double py) {
    for (final CollisionBlock block in player.collisionBlocks) {
      if (block.isPlatform) continue;

      final bool insideX = px >= block.x && px <= block.x + block.width;
      final bool insideY = py >= block.y && py <= block.y + block.height;

      if (insideX && insideY) {
        return true;
      }
    }

    return false;
  }

  SpriteAnimation _spriteAnimation({required EnemyState state}) {
    final EnemyAnimationData data = enemyAnimationData(enemyType, state);

    return SpriteAnimation.fromFrameData(
      game.images.fromCache(enemyPath(enemyType, state)),
      SpriteAnimationData.sequenced(
        amount: data.frames,
        stepTime: stepTime,
        textureSize: data.textureSize,
        loop: data.loop,
      ),
    );
  }

  void _loadAllAnimations() {
    final Map<EnemyState, SpriteAnimation> loadedAnimations = <EnemyState, SpriteAnimation>{};

    for (final EnemyState enemyState in animationMap.keys) {
      loadedAnimations[enemyState] = _spriteAnimation(state: enemyState);
    }

    animations = loadedAnimations;
    animationMap = loadedAnimations;
    current = loadedAnimations.keys.first;
  }

  void collisionWithPlayer() {
    if (!canDamagePlayer || !isAlive) return;

    final double playerLeft = player.x + player.hitbox.offsetX;

    final double playerRight = playerLeft + player.hitbox.width;

    final double playerTop = player.y + player.hitbox.offsetY;

    final double playerBottom = playerTop + player.hitbox.height;

    final double enemyLeft = x + hitbox.offsetX;

    final double enemyRight = enemyLeft + hitbox.width;

    final double enemyTop = y + hitbox.offsetY;

    final bool horizontallyOverlapping = playerRight > enemyLeft && playerLeft < enemyRight;

    final double stompTolerance = 6;

    final bool playerFeetNearEnemyTop =
        playerBottom >= enemyTop - stompTolerance && playerBottom <= enemyTop + stompTolerance;

    final bool isFallingOntoEnemy =
        player.velocity.y > 0 && horizontallyOverlapping && playerFeetNearEnemyTop;

    if (isFallingOntoEnemy) {
      player.bounceFromEnemy(enemyTop);

      if (Global.playSound) {
        FlameAudio.play(Audio.jumpOnEnemy.name, volume: Global.soundVoulme);
      }

      isAlive = false;
      canDamagePlayer = false;
      aiEnabled = false;

      final EnemyState hitState = animationMap.keys.elementAt(1);

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

  bool canSeePlayer();
}
