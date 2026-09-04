import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/evolution/components/creatures/antenna/antenna.dart';
import 'package:portfolio/evolution/components/creatures/antenna/bent_antenna.dart';
import 'package:portfolio/evolution/components/creatures/antenna/straight_antenna.dart';
import 'package:portfolio/evolution/components/creatures/body/body.dart';
import 'package:portfolio/evolution/components/creatures/body/oval_body.dart';
import 'package:portfolio/evolution/components/creatures/body/square_body.dart';
import 'package:portfolio/evolution/components/creatures/body/triangle_body.dart';
import 'package:portfolio/evolution/components/creatures/eye/dot_eye.dart';
import 'package:portfolio/evolution/components/creatures/eye/eye.dart';
import 'package:portfolio/evolution/components/creatures/eye/happy_eye1.dart';
import 'package:portfolio/evolution/components/creatures/eye/neutral_eye.dart';
import 'package:portfolio/evolution/components/creatures/eye/slanted_eye.dart';
import 'package:portfolio/evolution/components/creatures/eye/happy_eye2.dart';
import 'package:portfolio/evolution/components/creatures/leg/leg.dart';
import 'package:portfolio/evolution/components/creatures/sense/sense.dart';
import 'package:portfolio/evolution/components/info/stat_bar.dart';
import 'package:portfolio/evolution/evolution.dart';
import 'package:portfolio/evolution/utils/enums.dart';
import 'package:portfolio/evolution/utils/sizes.dart';
import 'package:portfolio/evolution/world/region_element.dart';
import 'package:portfolio/evolution/world/world_generator.dart';

class Creature extends PositionComponent with CollisionCallbacks, HasGameReference<Evolution> {
  late double age;
  late double speed;
  late double energy;
  late double eyeSize;
  late double hitpoints;
  late double senseRange;
  late double antennaSize;
  late double spontaneousEmergenceChance;

  late int groupSize;

  final double maxAge;
  final double maxEnergy;
  final double maxHitpoints;

  int childern;

  double walkTime = 0;
  double decisionTimer = 0;
  double treeAvoidanceTimer = 0;

  final Color color;

  late final Body body;
  late final Leg leftLeg;
  late final Leg rightLeg;
  late final Sense sense;
  late final StatBar hpBar;
  late final StatBar energyBar;
  late final StatBar ageBar;
  late final WorldGenerator worldGenerator;

  final Random random = Random();

  late Vector2 target;

  final Vector2 worldOrigin;
  final Vector2 worldSize;

  final SHAPE shape;
  final ANTENNA antenna;
  final ANTENNA_SHAPE antennaShape;
  final NATURE nature;
  final HEALTH health;
  final DISEASE disease;
  final SOCIALIZATION socialization;
  final EYES eyes;
  final GENDER gender;
  final FERTILITY fertility;

  bool get isDead => energy <= 0 || hitpoints <= 0 || age >= maxAge;

  DEATH_REASON? get deathReason {
    if (energy <= 0) return DEATH_REASON.starvation;
    if (hitpoints <= 0) return DEATH_REASON.noHitpoints;
    if (age >= maxAge) return DEATH_REASON.oldAge;
    return null;
  }

  Creature({
    required super.position,
    required super.size,
    required this.worldOrigin,
    required this.worldSize,
    required this.age,
    required this.speed,
    required this.energy,
    required this.eyeSize,
    required this.hitpoints,
    required this.senseRange,
    required this.antennaSize,
    required this.maxAge,
    required this.maxEnergy,
    required this.maxHitpoints,
    required this.color,
    required this.shape,
    required this.antenna,
    required this.antennaShape,
    required this.nature,
    required this.health,
    required this.disease,
    required this.socialization,
    required this.eyes,
    required this.fertility,
    required this.gender,
    required this.worldGenerator,
    this.childern = 0,
  });

  @override
  void update(double dt) {
    super.update(dt);

    treeAvoidanceTimer -= dt;
    priority = RenderPriority.regionElement + position.y.toInt();
    age += dt;
    decisionTimer -= dt;

    if (decisionTimer <= 0) {
      target = randomTarget();
      decisionTimer = 6 + random.nextDouble() * 4;
    }

    Vector2 delta = target - position;

    if (delta.length < 10) {
      leftLeg.angle = -pi / 6;
      rightLeg.angle = pi / 6;

      target = randomTarget();
      return;
    }

    final Vector2 direction = delta.normalized();

    if (treeAvoidanceTimer <= 0 && _treeAhead(direction)) {
      _avoidTree(direction);
      return;
    }

    final double step = speed * dt;

    if (delta.length <= step) {
      position = target;
    } else {
      position += direction * step;
    }

    walkTime += dt * speed * 0.4;

    final double swing = sin(walkTime) * pi / 8;

    leftLeg.angle = pi / 6 + swing;
    rightLeg.angle = -pi / 6 - swing;

    body.position.y = sin(walkTime * 2) * body.size.y * 0.03;

    final double energyConsumption = (0.5 * body.size.x * body.size.x * speed) + (0.03 * senseRange);

    energy -= energyConsumption * 0.00005 * dt;

    energy = energy.clamp(0.0, maxEnergy);
    hitpoints = hitpoints.clamp(0.0, maxHitpoints);

    if (isDead) {
      final DEATH_REASON? reason = deathReason;

      debugPrint(
        'Creature died (${reason.toString()}) '
        'Age: ${age.toStringAsFixed(1)}/${maxAge.toStringAsFixed(1)}, '
        'Energy: ${energy.toStringAsFixed(2)}, '
        'HP: ${hitpoints.toStringAsFixed(2)}',
      );
      removeFromParent();
      return;
    }

    energyBar.value = energy;
    hpBar.value = hitpoints;
    ageBar.value = age;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    walkTime = random.nextDouble() * 2 * pi;

    sense = Sense(radius: senseRange, color: color);

    switch (shape) {
      case SHAPE.triangle:
        body = TriangleBody(position: Vector2.zero(), bodyColor: color);
        break;
      case SHAPE.square:
        body = SquareBody(position: Vector2.zero(), bodyColor: color);
        break;
      case SHAPE.oval:
        body = OvalBody(position: Vector2.zero(), bodyColor: color);
        break;
    }
    add(sense);
    energyBar = StatBar(
      position: Vector2(0, -body.size.y * 0.85),
      width: body.size.x * 0.9,
      height: 4,
      value: energy,
      maxValue: maxEnergy,
      fillColor: Colors.green,
    );

    hpBar = StatBar(
      position: Vector2(0, -body.size.y * 0.68),
      width: body.size.x * 0.9,
      height: 4,
      value: hitpoints,
      maxValue: maxHitpoints,
      fillColor: Colors.red,
    );

    ageBar = StatBar(
      position: Vector2(0, -body.size.y * 1.02),
      width: body.size.x * 0.9,
      height: 4,
      value: age,
      maxValue: maxAge,
      fillColor: Colors.blue,
    );

    add(energyBar);
    add(hpBar);
    add(ageBar);
    add(body);

    _addLegs();
    _addEyes();
    _addAntennas();

    target = randomTarget();
  }

  void _addLegs() {
    leftLeg = Leg(
      position: Vector2(-body.size.x * .18, body.size.y * .35),
      left: true,
      length: body.size.y * .55,
    );

    rightLeg = Leg(
      position: Vector2(body.size.x * .18, body.size.y * .35),
      left: false,
      length: body.size.y * .55,
    );

    add(leftLeg);
    add(rightLeg);
  }

  void _addAntennas() {
    final double x = antenna != ANTENNA.inward ? body.size.x * 0.22 : body.size.x * 0.44;
    final double y = -body.size.y * 0.3;

    add(_leftAntenna(Vector2(-0.8 * x, y)));
    add(_rightAntenna(Vector2(0.8 * x, y)));
  }

  double getLeftAntennaAngle() {
    switch (shape) {
      case SHAPE.square:
      case SHAPE.oval:
        return 0;

      case SHAPE.triangle:
        return -pi / 6; // -30°
    }
  }

  double getRightAntennaAngle() {
    switch (shape) {
      case SHAPE.square:
      case SHAPE.oval:
        return 0;

      case SHAPE.triangle:
        return pi / 6; // +30°
    }
  }

  Antenna _leftAntenna(Vector2 pos) {
    switch (antenna) {
      case ANTENNA.straight:
        return StraightAntenna(
          position: pos,
          tipSize: antennaSize,
          tipShape: antennaShape,
          color: color,
          angle: getLeftAntennaAngle(),
        );

      case ANTENNA.inward:
        return BentAntenna(
          position: pos,
          tipSize: antennaSize,
          tipShape: antennaShape,
          outward: true,
          color: color,
          angle: getLeftAntennaAngle(),
        );

      case ANTENNA.outward:
        return BentAntenna(
          position: pos,
          tipSize: antennaSize,
          tipShape: antennaShape,
          outward: false,
          color: color,
          angle: getLeftAntennaAngle(),
        );
    }
  }

  Antenna _rightAntenna(Vector2 pos) {
    switch (antenna) {
      case ANTENNA.straight:
        return StraightAntenna(
          position: pos,
          tipSize: antennaSize,
          tipShape: antennaShape,
          color: color,
          angle: getRightAntennaAngle(),
        );

      case ANTENNA.inward:
        return BentAntenna(
          position: pos,
          tipSize: antennaSize,
          tipShape: antennaShape,
          outward: false,
          color: color,
          angle: getRightAntennaAngle(),
        );

      case ANTENNA.outward:
        return BentAntenna(
          position: pos,
          tipSize: antennaSize,
          tipShape: antennaShape,
          outward: true,
          color: color,
          angle: getRightAntennaAngle(),
        );
    }
  }

  void _addEyes() {
    final double radius = eyeSize;

    final double eyeY = -body.size.y * 0.20;
    final double eyeX = body.size.x * 0.22;

    add(_leftEye(Vector2(-eyeX, eyeY), radius));
    add(_rightEye(Vector2(eyeX, eyeY), radius));
  }

  Eye _leftEye(Vector2 position, double radius) {
    switch (eyes) {
      case EYES.neutral:
        return NeutralEye(position: position, radius: radius);

      case EYES.dot:
        return DotEye(position: position, radius: radius);

      case EYES.sad:
        return SlantedEye(position: position, radius: radius, eyeAngle: -pi / 4);

      case EYES.happy1:
        return HappyEye1(position: position, radius: radius);

      case EYES.angry:
        return SlantedEye(position: position, radius: radius, eyeAngle: pi / 4);

      case EYES.happy2:
        return HappyEye2(position: position, radius: radius);
    }
  }

  Eye _rightEye(Vector2 position, double radius) {
    switch (eyes) {
      case EYES.neutral:
        return NeutralEye(position: position, radius: radius);

      case EYES.dot:
        return DotEye(position: position, radius: radius);

      case EYES.sad:
        return SlantedEye(position: position, radius: radius, eyeAngle: pi / 4);

      case EYES.happy1:
        return HappyEye1(position: position, radius: radius);

      case EYES.angry:
        return SlantedEye(position: position, radius: radius, eyeAngle: -pi / 4);

      case EYES.happy2:
        return HappyEye2(position: position, radius: radius);
    }
  }

  Vector2 randomTarget() {
    return Vector2(
      worldOrigin.x + random.nextDouble() * worldSize.x,
      worldOrigin.y + random.nextDouble() * worldSize.y,
    );
  }

  bool _treeAhead(Vector2 direction) {
    final List<RegionElement> nearbyTrees = worldGenerator.getNearbyElements(position, [
      ...REGION_ELEMENTS.trees,
      ...REGION_ELEMENTS.desertPlants,
    ]);

    const double detectionDistance = 35.0;
    const double treeCollisionRadius = 18.0;

    for (final RegionElement tree in nearbyTrees) {
      final Vector2 toTree = tree.position - position;
      final double distanceSquared = toTree.length2;

      if (distanceSquared >
          (detectionDistance + treeCollisionRadius) * (detectionDistance + treeCollisionRadius)) {
        continue;
      }

      final double dot = direction.dot(toTree.normalized());

      if (dot > 0.2) {
        return true;
      }
    }

    return false;
  }

  void _avoidTree(Vector2 currentDirection) {
    const double maxAngle = pi / 4;
    final double angle = (random.nextDouble() * 2.0 - 1.0) * maxAngle;
    final Vector2 newDirection = currentDirection.clone()..rotate(angle);
    target = position + newDirection * 200;
    target.x = target.x.clamp(worldOrigin.x, worldOrigin.x + worldSize.x);
    target.y = target.y.clamp(worldOrigin.y, worldOrigin.y + worldSize.y);
    treeAvoidanceTimer = 0.25;
  }
}
