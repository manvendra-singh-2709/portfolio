import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/painting.dart';
import 'package:portfolio/game/components/items/player.dart';
import 'package:portfolio/game/components/levels/level.dart';
import 'package:portfolio/game/utils/enums.dart';
import 'package:portfolio/globals/globals.dart';

class PixelAdventure extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks, TapCallbacks, HasCollisionDetection {
  late CameraComponent cam;

  JoystickComponent? joystick;

  Level? currentLevelComponent;

  Player player = Player(character: Actor.maskDude);
  bool showControls = true;
  List<String> levelNames = List.generate(5, (i) => '${i + 1}'.padLeft(2, '0'));
  int currentLevel = 1;

  static const double controlRadius = 40;
  static const double margin = 25;

  @override
  Color backgroundColor() => Color(0xFF211F30);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    images.prefix = Global.imagesPrefix;
    await images.loadAllImages();

    await _loadLevel();

    await cam.loaded;
  }

  Future<bool> loadNextLevel() async {
    if (currentLevel < levelNames.length) {
      currentLevel++;
      await _loadLevel();
      return true;
    }

    return false;
  }

  Future<void> _loadLevel() async {
    await Future.delayed(const Duration(seconds: 1));

    if (currentLevelComponent != null) {
      currentLevelComponent!.removeFromParent();
      cam.removeFromParent();
    }

    currentLevelComponent = Level(levelName: levelNames[currentLevel - 1], player: player);

    player.resetPlayerForNewLevel();

    cam = CameraComponent.withFixedResolution(
      world: currentLevelComponent,
      width: 640,
      height: 360,
    );

    cam.viewfinder.anchor = Anchor.topLeft;

    await addAll([cam, currentLevelComponent!]);
    await cam.loaded;

    await cam.loaded;

    if (showControls) {
      addJoystick();
    }
  }

  @override
  void update(double dt) {
    if (showControls) {
      updateJoystick();
    }
    super.update(dt);
  }

  @override
  void onTapUp(TapUpEvent event) {
    final tap = event.canvasPosition;

    // ignore joystick area
    if (tap.x < size.x * 0.45 && tap.y > size.y * 0.45) {
      return;
    }

    player.hasJumped = true;

    super.onTapUp(event);
  }

  void addJoystick() {
    joystick = JoystickComponent(
      knob: CircleComponent(
        radius: 15,
        paint: Paint()..color = const Color(0xAAFFFFFF), // semi-transparent white
      ),
      background: CircleComponent(
        radius: 40,
        paint: Paint()..color = const Color(0x55333333), // dark, more transparent
      ),
      margin: const EdgeInsets.only(left: margin, bottom: margin),
      priority: 10,
    );

    cam.viewport.add(joystick!);
  }

  void updateJoystick() {
    switch (joystick!.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.joystickHorizontalMovement = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.joystickHorizontalMovement = 1;
        break;
      case JoystickDirection.up:
        player.hasJumped = true;
      default:
        player.joystickHorizontalMovement = 0;
        break;
    }
  }
}
