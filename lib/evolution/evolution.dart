import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/evolution/components/creatures/body_color.dart';
import 'package:portfolio/evolution/components/creatures/creature.dart';
import 'package:portfolio/evolution/components/environment/environment_manager.dart';
import 'package:portfolio/evolution/utils/enums.dart';
import 'package:portfolio/evolution/utils/sizes.dart';
import 'package:portfolio/evolution/world/world_generator.dart';
import 'package:portfolio/globals/globals.dart';

class Evolution extends FlameGame with ScaleDetector, PanDetector, ScrollDetector, HasCollisionDetection {
  static const double minZoom = 0.1;
  static const double maxZoom = 10.0;

  bool _pinching = false;

  late final WorldGenerator worldGenerator;
  late final EnvironmentManager environment;

  double _startingZoom = 1.0;
  final Vector2 worldSize = Vector2(Global.worldX, Global.worldY);
  final Vector2 worldOrigin = Vector2.all(0);

  Vector2 get visibleWorldSize => Vector2(size.x / camera.viewfinder.zoom, size.y / camera.viewfinder.zoom);

  void zoomIn() {
    camera.viewfinder.zoom = (camera.viewfinder.zoom * 1.2).clamp(minZoom, maxZoom);
    _clampCamera();
  }

  void zoomOut() {
    camera.viewfinder.zoom = (camera.viewfinder.zoom / 1.2).clamp(minZoom, maxZoom);
    _clampCamera();
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    images.prefix = Global.evolutionImagesPrefix;
    await images.loadAllImages();

    world.add(RectangleComponent(position: worldOrigin, size: worldSize));

    camera.viewfinder.position = worldOrigin + worldSize / 2;

    worldGenerator = WorldGenerator(
      world: world,
      worldOrigin: worldOrigin,
      worldSize: worldSize,
      hexRadius: Global.hexRadius,
    );

    await world.add(worldGenerator);

    environment = EnvironmentManager(
      worldOrigin: worldOrigin,
      worldSize: worldSize,
      world: world,
      grid: worldGenerator.hexGrid,
    );

    await world.add(environment);

    world.addAll(<Component>[
      Creature(
        age: 0,
        speed: 24,
        energy: 500,
        eyeSize: EyeSize.m,
        hitpoints: 70,
        senseRange: 150,
        antennaSize: AntennaSize.m,
        maxAge: 700,
        maxEnergy: 500,
        maxHitpoints: 70,
        position: Vector2(500, 500),
        size: BodySize.m,
        color: Colors.green,
        worldOrigin: worldOrigin,
        worldSize: worldSize,
        shape: SHAPE.triangle,
        antenna: ANTENNA.straight,
        antennaShape: ANTENNA_SHAPE.square,
        nature: NATURE.aultristic,
        health: HEALTH.healthy,
        disease: DISEASE.contagious,
        socialization: SOCIALIZATION.groups,
        eyes: EYES.sad,
        fertility: FERTILITY.fertile,
        gender: GENDER.male,
        worldGenerator: worldGenerator,
      ),
      Creature(
        age: 0,
        speed: 36,
        energy: 500,
        eyeSize: EyeSize.m,
        hitpoints: 100,
        senseRange: 47,
        antennaSize: AntennaSize.m,
        maxAge: 700,
        maxEnergy: 500,
        maxHitpoints: 100,
        position: Vector2(1000, 1000),
        size: BodySize.m,
        worldOrigin: worldOrigin,
        worldSize: worldSize,
        color: BodyColor.amber.value,
        shape: SHAPE.oval,
        antenna: ANTENNA.straight,
        antennaShape: ANTENNA_SHAPE.square,
        nature: NATURE.aultristic,
        health: HEALTH.healthy,
        disease: DISEASE.contagious,
        socialization: SOCIALIZATION.groups,
        eyes: EYES.happy2,
        fertility: FERTILITY.fertile,
        gender: GENDER.female,
        worldGenerator: worldGenerator,
      ),
      Creature(
        age: 0,
        speed: 20,
        energy: 500,
        eyeSize: EyeSize.m,
        hitpoints: 100,
        senseRange: 37,
        antennaSize: AntennaSize.m,
        maxAge: 700,
        maxEnergy: 500,
        maxHitpoints: 100,
        position: Vector2(800, 800),
        size: BodySize.m,
        worldOrigin: worldOrigin,
        worldSize: worldSize,
        color: BodyColor.cyan.value,
        shape: SHAPE.square,
        antenna: ANTENNA.inward,
        antennaShape: ANTENNA_SHAPE.oval,
        nature: NATURE.aultristic,
        health: HEALTH.healthy,
        disease: DISEASE.contagious,
        socialization: SOCIALIZATION.groups,
        eyes: EYES.happy1,
        fertility: FERTILITY.fertile,
        gender: GENDER.male,
        worldGenerator: worldGenerator,
      ),
    ]);
  }

  @override
  Color backgroundColor() {
    return Colors.white;
  }

  @override
  void onScaleStart(ScaleStartInfo info) {
    super.onScaleStart(info);
    _pinching = info.pointerCount > 1;
    _startingZoom = camera.viewfinder.zoom;
  }

  @override
  void onScaleEnd(ScaleEndInfo info) {
    super.onScaleEnd(info);
    _pinching = false;
  }

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    super.onScaleUpdate(info);

    camera.viewfinder.zoom = (_startingZoom * info.scale.global.y).clamp(minZoom, maxZoom);
    _clampCamera();
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (_pinching) return;

    camera.viewfinder.position -= info.delta.global / camera.viewfinder.zoom;

    _clampCamera();
  }

  void _clampCamera() {
    final double visibleWidth = size.x / camera.viewfinder.zoom;
    final double visibleHeight = size.y / camera.viewfinder.zoom;

    final double halfW = visibleWidth / 2;
    final double halfH = visibleHeight / 2;

    final double left = worldOrigin.x;
    final double right = worldOrigin.x + worldSize.x;
    final double top = worldOrigin.y;
    final double bottom = worldOrigin.y + worldSize.y;

    if (visibleWidth >= worldSize.x) {
      camera.viewfinder.position.x = left + worldSize.x / 2;
    } else {
      camera.viewfinder.position.x = camera.viewfinder.position.x.clamp(left + halfW, right - halfW);
    }

    if (visibleHeight >= worldSize.y) {
      camera.viewfinder.position.y = top + worldSize.y / 2;
    } else {
      camera.viewfinder.position.y = camera.viewfinder.position.y.clamp(top + halfH, bottom - halfH);
    }
  }

  @override
  void onScroll(PointerScrollInfo info) {
    super.onScroll(info);

    final factor = info.scrollDelta.global.y > 0 ? 0.9 : 1.1;

    camera.viewfinder.zoom = (camera.viewfinder.zoom * factor).clamp(minZoom, maxZoom);

    _clampCamera();
  }
}
