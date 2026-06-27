import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
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

  bool hasStarted = false;
  bool timerStarted = false;
  bool timerStopped = false;
  bool showControls = true;
  bool levelTimerRunning = false;

  List<String> levelNames = List.generate(Global.numLevels, (i) => '${i + 1}'.padLeft(2, '0'));

  String get levelText => 'Level ${levelNames[currentLevel - 1]}';

  int currentLevel = 1;

  final ValueNotifier<int> levelNotifier = ValueNotifier<int>(1);
  final ValueNotifier<double> levelTimeNotifier = ValueNotifier<double>(0);
  final ValueNotifier<double> completedLevelTimeNotifier = ValueNotifier<double>(0);

  static const double controlRadius = 40;
  static const double margin = 25;

  @override
  Color backgroundColor() => Color(0xFF211F30);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    images.prefix = Global.imagesPrefix;
    await images.loadAllImages();

    overlays.add('mainMenu');
  }

  Future<void> startGame() async {
    hasStarted = true;
    currentLevel = 1;
    levelNotifier.value = currentLevel;

    overlays.remove('mainMenu');
    overlays.add('levelHud');

    await _loadLevel();
  }

  Future<bool> loadNextLevel() async {
    if (currentLevel < levelNames.length) {
      currentLevel++;
      levelNotifier.value = currentLevel;

      overlays.remove('levelComplete');
      overlays.add('levelHud');

      await _loadLevel();
      return true;
    }

    overlays.remove('levelComplete');
    overlays.add('gameOver');
    return false;
  }

  void startLevelTimer() {
    if (!timerStarted && !timerStopped) {
      timerStarted = true;
    }
  }

  void finishLevelTimer() {
    timerStopped = true;
  }

  void completeLevel() {
    finishLevelTimer();

    completedLevelTimeNotifier.value = levelTimeNotifier.value;

    overlays.remove('levelHud');

    if (currentLevel < levelNames.length) {
      overlays.add('levelComplete');
    } else {
      hasStarted = false;
      overlays.add('gameOver');
    }
  }

  Future<void> _loadLevel() async {
    levelTimeNotifier.value = 0;
    timerStarted = false;
    timerStopped = false;

    await Future.delayed(const Duration(seconds: 1));

    if (currentLevelComponent != null) {
      currentLevelComponent!.removeFromParent();
      cam.removeFromParent();
    }

    player.resetPlayerForNewLevel();
    currentLevelComponent = Level(levelName: levelNames[currentLevel - 1], player: player);

    cam = CameraComponent.withFixedResolution(world: currentLevelComponent, width: 640, height: 360);

    cam.viewfinder.anchor = Anchor.topLeft;

    await addAll([cam, currentLevelComponent!]);

    await cam.loaded;

    if (showControls) {
      addJoystick();
    }
  }

  @override
  void update(double dt) {
    if (hasStarted && timerStarted && !timerStopped) {
      levelTimeNotifier.value += dt;
    }

    if (hasStarted && showControls) {
      updateJoystick();
    }

    super.update(dt);
  }

  void addJoystick() {
    joystick?.removeFromParent();
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
    if (joystick == null) {
      player.joystickHorizontalMovement = 0;
      return;
    } else if (!joystick!.isMounted) {
      player.joystickHorizontalMovement = 0;
      return;
    }
    if (joystick!.direction != JoystickDirection.idle) {
      startLevelTimer();
    }

    if (joystick!.direction == JoystickDirection.up ||
        joystick!.direction == JoystickDirection.upLeft ||
        joystick!.direction == JoystickDirection.upRight) {
      player.hasJumped = true;
    }

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

  Future<void> exitToMainMenu() async {
    currentLevelComponent?.removeFromParent();
    cam.removeFromParent();

    joystick?.removeFromParent();
    joystick = null;

    currentLevelComponent = null;

    hasStarted = false;
    currentLevel = 1;
    levelNotifier.value = 1;

    levelTimeNotifier.value = 0;
    completedLevelTimeNotifier.value = 0;

    timerStarted = false;
    timerStopped = false;

    overlays.remove('levelHud');
    overlays.remove('levelComplete');
    overlays.remove('gameOver');
    overlays.add('mainMenu');
  }
}
