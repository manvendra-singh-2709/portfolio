import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:portfolio/game/pixel_adventure.dart';
import 'package:portfolio/game/utils/enums.dart';

class Player extends SpriteAnimationGroupComponent
    with HasGameReference<PixelAdventure>, KeyboardHandler {
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;

  final double stepTime = 0.05;

  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();
  bool isFacingRight = true;

  Actor character;
  PlayerDirection playerDirection = PlayerDirection.none;

  Player({super.position, this.character = Actor.ninjaFrog});

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerMovement(dt);
    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final bool isLeftKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final bool isRightKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    if (isLeftKeyPressed && isRightKeyPressed) {
      playerDirection = PlayerDirection.none;
    } else if (isLeftKeyPressed) {
      playerDirection = PlayerDirection.left;
    } else if (isRightKeyPressed) {
      playerDirection = PlayerDirection.right;
    } else {
      playerDirection = PlayerDirection.none;
    }
    return super.onKeyEvent(event, keysPressed);
  }

  SpriteAnimation _spriteAnimation({
    required String actor,
    required PlayerState action,
  }) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache(
        'Main Characters/$actor/${action.name} (32x32).png',
      ),
      SpriteAnimationData.sequenced(
        amount: action.frames,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
  }

  void _loadAllAnimations() {
    String actor = character.name;

    idleAnimation = _spriteAnimation(actor: actor, action: PlayerState.idle);
    runningAnimation = _spriteAnimation(
      actor: actor,
      action: PlayerState.running,
    );

    // List of all animations
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
    };

    // Srt current animation
    current = PlayerState.running;
  }

  void _updatePlayerMovement(double dt) {
    double dirX = 0.0;

    switch (playerDirection) {
      case PlayerDirection.left:
        if (isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = false;
        }
        current = PlayerState.running;
        dirX -= moveSpeed;
        break;
      case PlayerDirection.right:
        if (!isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = true;
        }
        current = PlayerState.running;
        dirX += moveSpeed;
        break;
      case PlayerDirection.none:
        current = PlayerState.idle;
        break;
    }

    velocity = Vector2(dirX, 0);
    position += velocity * dt;
  }
}
