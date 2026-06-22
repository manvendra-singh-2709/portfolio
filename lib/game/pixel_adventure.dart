import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/painting.dart';
import 'package:portfolio/game/components/actors/player.dart';
import 'package:portfolio/game/components/levels/level.dart';
import 'package:portfolio/game/utils/enums.dart';
import 'package:portfolio/globals/globals.dart';

class PixelAdventure extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks {
  late final CameraComponent cam;

  late JoystickComponent joystick;

  Player player = Player(character: Actor.maskDude);
  bool showJoystick = true;

  @override
  Color backgroundColor() => Color(0xFF211F30);

  @override
  FutureOr<void> onLoad() async {
    images.prefix = Global.imagesPrefix;
    await images.loadAllImages();

    final Level level = Level(levelName: '02', player: player);

    cam = CameraComponent.withFixedResolution(
      world: level,
      width: 640,
      height: 360,
    );

    cam.viewfinder.anchor = Anchor.topLeft;

    await addAll([cam, level]);

    if (showJoystick) {
      addJoystick();
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showJoystick) {
      updateJoystick();
    }
    super.update(dt);
  }

  void addJoystick() {
    joystick = JoystickComponent(
      knob: CircleComponent(
        radius: 15,
        paint: Paint()
          ..color = const Color(0xAAFFFFFF), // semi-transparent white
      ),
      background: CircleComponent(
        radius: 40,
        paint: Paint()
          ..color = const Color(0x55333333), // dark, more transparent
      ),
      margin: const EdgeInsets.only(right: 25, bottom: 25),
    );

    cam.viewport.add(joystick);
  }

  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.playerDirection = PlayerDirection.left;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.playerDirection = PlayerDirection.right;
        break;
      default:
        player.playerDirection = PlayerDirection.none;
        break;
    }
  }
}
