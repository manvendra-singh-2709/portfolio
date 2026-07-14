import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame_audio/flame_audio.dart' hide PlayerState;
import 'package:flutter/services.dart';
import 'package:portfolio/game/components/items/abstracts/enemy.dart';
import 'package:portfolio/game/components/items/checkpoint.dart';
import 'package:portfolio/game/components/items/traps/fan.dart';
import 'package:portfolio/game/components/items/fruit.dart';
import 'package:portfolio/game/components/items/abstracts/game_entity.dart';
import 'package:portfolio/game/components/items/hitbox.dart';
import 'package:portfolio/game/components/collisions/blocks.dart';
import 'package:portfolio/game/components/items/traps/saw.dart';
import 'package:portfolio/game/components/items/traps/spike.dart';
import 'package:portfolio/game/components/levels/level.dart';
import 'package:portfolio/game/utils/enums.dart';
import 'package:portfolio/game/utils/utils.dart';
import 'package:portfolio/globals/globals.dart';

class Player extends GameEntity<PlayerState> {
  late final SpriteAnimation hitAnimation;
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation jumpingAnimation;
  late final SpriteAnimation fallingAnimation;
  late final SpriteAnimation wallJumpAnimation;
  late final SpriteAnimation appearingAnimation;
  late final SpriteAnimation doubleJumpAnimation;
  late final SpriteAnimation disappearingAnimation;

  bool gotHit = false;
  bool hasJumped = false;
  bool isOnGround = false;
  bool levelFinished = false;
  bool canDoubleJump = false;
  bool reachedCheckpoint = false;
  bool jumpKeyPreviouslyPressed = false;

  Vector2 velocity = Vector2.zero();
  Vector2 initialPosition = Vector2.zero();
  Vector2 checkpointPosition = Vector2.zero();

  List<CollisionBlock> collisionBlocks = [];
  CustomHitbox hitbox = CustomHitbox(offsetX: 10, offsetY: 4, width: 14, height: 28);

  Actor character;

  Player({this.character = Actor.ninjaFrog, required super.spawnPoint});

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    initialPosition = Vector2(position.x, position.y);
    checkpointPosition = Vector2(position.x, position.y);
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
    dt = dt.clamp(0, 1 / 60);

    if (!gotHit && !reachedCheckpoint) {
      _updatePlayerState();
      _updatePlayerMovement(dt);
      _checkHorizontalCollisions();
      _applyGravity(dt); //add after horizontal collision check
      _checkVerticalCollisions();
      _checkLevelBounds();
    }
    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    keyboardHorizontalMovement = 0;

    final bool isLeftKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.keyA) || keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final bool isRightKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.keyD) || keysPressed.contains(LogicalKeyboardKey.arrowRight);

    keyboardHorizontalMovement += isLeftKeyPressed ? -1 : 0;
    keyboardHorizontalMovement += isRightKeyPressed ? 1 : 0;

    final bool jumpPressed =
        keysPressed.contains(LogicalKeyboardKey.space) || keysPressed.contains(LogicalKeyboardKey.arrowUp);

    if (jumpPressed && !jumpKeyPreviouslyPressed) {
      hasJumped = true;
    }

    jumpKeyPreviouslyPressed = jumpPressed;

    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (reachedCheckpoint || gotHit || levelFinished) {
      super.onCollision(intersectionPoints, other);
      return;
    }

    if (other is Fruit) {
      other.collisionWithPlayer();
    }

    if (other is Saw) {
      _respawn();
    }

    if (other is Spike) {
      _respawn();
    }

    if (other is Fan && other.on) {
      _respawn();
    }

    if (other is Enemy) {
      other.collisionWithPlayer();
    }

    if (other is Checkpoint) {
      checkpointPosition = position.clone();

      if (parent is Level) {
        final Level level = parent as Level;

        if (level.allFruitsCollected) {
          levelFinished = true;
          game.finishLevelTimer();
          _reachedCheckpoint();
        }
      }
    }

    super.onCollision(intersectionPoints, other);
  }

  void resetPlayerForNewLevel() {
    gotHit = false;
    hasJumped = false;
    isOnGround = false;
    levelFinished = false;
    reachedCheckpoint = false;
    canDoubleJump = false;

    velocity = Vector2.zero();

    horizontalMovement = 0;
    keyboardHorizontalMovement = 0;
    joystickHorizontalMovement = 0;

    scale.x = 1;

    if (isLoaded) {
      current = PlayerState.idle;
    }

    collisionBlocks = [];
  }

  SpriteAnimation _spriteAnimation({required String actor, required PlayerState action, bool loop = true}) {
    int pixels = action == PlayerState.appearing || action == PlayerState.disappearing ? 96 : 32;
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/$actor/${action.name} (${pixels}x$pixels).png'),
      SpriteAnimationData.sequenced(
        amount: action.frames,
        stepTime: stepTime,
        textureSize: Vector2.all(pixels.toDouble()),
        loop: loop,
      ),
    );
  }

  void _loadAllAnimations() {
    String actor = character.name;

    idleAnimation = _spriteAnimation(actor: actor, action: PlayerState.idle);
    jumpingAnimation = _spriteAnimation(actor: actor, action: PlayerState.jump);
    fallingAnimation = _spriteAnimation(actor: actor, action: PlayerState.fall);
    runningAnimation = _spriteAnimation(actor: actor, action: PlayerState.running);
    hitAnimation = _spriteAnimation(actor: actor, action: PlayerState.hit, loop: false);
    wallJumpAnimation = _spriteAnimation(actor: actor, action: PlayerState.wallJump, loop: false);
    appearingAnimation = _spriteAnimation(actor: actor, action: PlayerState.appearing, loop: false);
    doubleJumpAnimation = _spriteAnimation(actor: actor, action: PlayerState.doubleJump, loop: false);
    disappearingAnimation = _spriteAnimation(actor: actor, action: PlayerState.disappearing, loop: false);

    animations = {
      PlayerState.hit: hitAnimation,
      PlayerState.idle: idleAnimation,
      PlayerState.jump: jumpingAnimation,
      PlayerState.fall: fallingAnimation,
      PlayerState.running: runningAnimation,
      PlayerState.wallJump: wallJumpAnimation,
      PlayerState.appearing: appearingAnimation,
      PlayerState.doubleJump: doubleJumpAnimation,
      PlayerState.disappearing: disappearingAnimation,
    };

    // Set current animation
    current = PlayerState.running;
  }

  void _updatePlayerMovement(double dt) {
    if (hasJumped) {
      game.startLevelTimer();

      if (isOnGround) {
        _playerJump(dt);
        canDoubleJump = true;
      } else if (canDoubleJump) {
        _secondJump();
        canDoubleJump = false;
      }

      hasJumped = false;
    }

    // To avoid jumping while falling
    // if (velocity.y > gravity) isOnGround = false;

    horizontalMovement = keyboardHorizontalMovement + joystickHorizontalMovement;
    horizontalMovement = horizontalMovement.clamp(-1, 1);

    if (horizontalMovement != 0) {
      game.startLevelTimer();
    }

    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
  }

  void _secondJump() {
    if (Global.playSound) {
      FlameAudio.play(Audio.jump.name, volume: Global.soundVoulme);
    }

    velocity.y = -jumpForce;
    current = PlayerState.jump;
  }

  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;

    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    // Check if moving
    if (velocity.x != 0) playerState = PlayerState.running;

    // Check if falling
    if (velocity.y > gravity) playerState = PlayerState.fall;

    // Check if jumping
    if (velocity.y < 0) playerState = PlayerState.jump;

    current = playerState;
  }

  void _checkHorizontalCollisions() {
    for (final CollisionBlock block in collisionBlocks) {
      if (!block.isPlatform) {
        if (checkCollisions(this, block)) {
          if (velocity.x > 0) {
            velocity.x = 0;
            position.x = block.x - hitbox.offsetX - hitbox.width;
            break;
          }
          if (velocity.x < 0) {
            velocity.x = 0;
            position.x = block.x + hitbox.width + block.width + hitbox.offsetX;
            break;
          }
        }
      }
    }
  }

  void _applyGravity(double dt) {
    velocity.y += gravity * dt * 60;
    velocity.y = velocity.y.clamp(-jumpForce, terminalVelocity);
    position.y += velocity.y * dt;
  }

  void _checkVerticalCollisions() {
    for (final CollisionBlock block in collisionBlocks) {
      if (!block.isPlatform) {
        if (checkCollisions(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            canDoubleJump = false;
            break;
          }
          if (velocity.y < 0) {
            velocity.y = 0;
            position.y = block.y + block.height - hitbox.offsetY;
            hasJumped = false;
            break;
          }
        }
      } else {
        if (checkCollisions(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            canDoubleJump = false;
            break;
          }
        }
      }
    }
  }

  void _playerJump(double dt) {
    if (Global.playSound) FlameAudio.play(Audio.jump.name, volume: Global.soundVoulme);
    velocity.y = -jumpForce;
    isOnGround = false;
    hasJumped = false;
  }

  void _respawn() {
    canDoubleJump = false;
    if (gotHit) return;
    gotHit = true;
    velocity = Vector2.zero();
    hasJumped = false;
    isOnGround = false;
    if (Global.playSound) FlameAudio.play(Audio.hit.name, volume: Global.soundVoulme);
    current = PlayerState.hit;
    final SpriteAnimationTicker hitAnimation = animationTickers![PlayerState.hit]!;
    hitAnimation.completed.whenComplete(() {
      current = PlayerState.appearing;
      scale.x = 1;
      position = checkpointPosition - Vector2.all(32);
      hitAnimation.reset();
      final SpriteAnimationTicker appearingAnimation = animationTickers![PlayerState.appearing]!;
      appearingAnimation.completed.whenComplete(() {
        position = checkpointPosition;
        current = PlayerState.idle;
        Future.delayed(const Duration(milliseconds: 400), () => gotHit = false);
        appearingAnimation.reset();
      });
    });
  }

  void _reachedCheckpoint() {
    if (Global.playSound) FlameAudio.play(Audio.disappear.name, volume: Global.soundVoulme);
    reachedCheckpoint = true;

    if (scale.x > 0) {
      position = position - Vector2.all(32);
    } else if (scale.x < 0) {
      position = position + Vector2(32, -32);
    }
    current = PlayerState.disappearing;

    final SpriteAnimationTicker disappearingAnimation = animationTickers![PlayerState.disappearing]!;
    disappearingAnimation.completed.whenComplete(() {
      position = checkpointPosition.clone();
      velocity = Vector2.zero();
      hasJumped = false;
      isOnGround = false;
      current = PlayerState.idle;
      reachedCheckpoint = false;
      disappearingAnimation.reset();
      removeFromParent();
      game.completeLevel();
    });
  }

  void collisionWithEnemy() {
    _respawn();
  }

  void bounceFromEnemy(double enemyTopY) {
    velocity.y = -jumpForce * 0.3;
    position.y = enemyTopY - hitbox.height - hitbox.offsetY - 1;
    isOnGround = false;
    hasJumped = false;
  }

  void _checkLevelBounds() {
    if (position.y + hitbox.offsetY < 0) {
      position.y = -hitbox.offsetY;
      velocity.y = 0;
      hasJumped = false;
    }
  }
}
