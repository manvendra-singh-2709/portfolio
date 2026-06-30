import 'package:flame/components.dart';

enum Actor {
  maskDude('Mask Dude'),
  ninjaFrog('Ninja Frog'),
  pinkMan('Pink Man'),
  virtualGuy('Virtual Guy');

  const Actor(this.name);

  final String name;
}

enum PlayerState {
  idle(name: 'Idle', frames: 11),
  running(name: 'Run', frames: 12),
  jump(name: 'Jump', frames: 1),
  wallJump(name: 'Wall Jump', frames: 5),
  hit(name: 'Hit', frames: 7),
  appearing(name: 'Appearing', frames: 7),
  disappearing(name: 'Disappearing', frames: 7),
  fall(name: 'Fall', frames: 1),
  doubleJump(name: 'Double Jump', frames: 6);

  const PlayerState({required this.name, required this.frames});

  final String name;
  final int frames;
}

enum CheckpointState {
  noFlag(name: '(No Flag)', frames: 1, loop: true),
  flagOut(name: '(Flag Out) (64x64)', frames: 26, loop: false),
  flagIdle(name: '(Flag Idle) (64x64)', frames: 10, loop: true);

  const CheckpointState({required this.name, required this.frames, required this.loop});

  final String name;
  final int frames;
  final bool loop;
}

enum FanState {
  on(name: 'On (24x8)', frames: 4, loop: true),
  off(name: 'Off', frames: 1, loop: false);

  const FanState({required this.name, required this.frames, required this.loop});

  final String name;
  final int frames;
  final bool loop;
}

enum SawState {
  on(name: 'On (38x38)', frames: 8, loop: true),
  off(name: 'Off', frames: 1, loop: false);

  const SawState({required this.name, required this.frames, required this.loop});

  final String name;
  final int frames;
  final bool loop;
}

enum Layers {
  spawnPoints('Spawnpoints'),
  background('Background'),
  collisions('Collisions');

  const Layers(this.name);

  final String name;
}

enum SpawnPoints {
  player('Player'),
  chicken('Chicken'),
  saw('Saw'),
  fruit('Fruit'),
  fan('Fan'),
  checkpoint('Checkpoint'),
  spike('Spike');

  const SpawnPoints(this.name);

  final String name;
}

enum Audio {
  jump('jump.wav'),
  hit('hit.wav'),
  collect('collect.wav'),
  disappear('disappear.wav'),
  jumpOnEnemy('jumpOnEnemy.wav');

  const Audio(this.name);

  final String name;
}

enum EnemyType {
  angryPig('AngryPig'),
  bat('Bat'),
  bee('Bee'),
  blueBird('BlueBird'),
  bunny('Bunny'),
  chameleon('Chameleon'),
  chicken('Chicken'),
  duck('Duck'),
  fatBird('FatBird'),
  ghost('Ghost'),
  mushroom('Mushroom'),
  plant('Plant'),
  radish('Radish'),
  rino('Rino'),
  rocks('Rocks'),
  skull('Skull'),
  slime('Slime'),
  snail('Snail'),
  trunk('Trunk'),
  turtle('Turtle');

  const EnemyType(this.folder);

  final String folder;
}

enum EnemyState {
  attack(name: 'Attack'),
  appear(name: 'Appear'),
  ceilingIn(name: 'Ceiling In'),
  ceilingOut(name: 'Ceiling Out'),
  desappear(name: 'Desappear'),
  fall(name: 'Fall'),
  flying(name: 'Flying'),
  ground(name: 'Ground'),
  hit(name: 'Hit'),
  hit1(name: 'Hit 1'),
  hit2(name: 'Hit 2'),
  hitWall(name: 'Hit Wall'),
  hitWall1(name: 'Hit Wall 1'),
  hitWall2(name: 'Hit Wall 2'),
  idle(name: 'Idle'),
  idle1(name: 'Idle 1'),
  idle2(name: 'Idle 2'),
  idleRun(name: 'Idle-Run'),
  jump(name: 'Jump'),
  jumpAnticipation(name: 'Jump Anticipation'),
  rock1Hit(name: 'Rock1_Hit'),
  rock1Idle(name: 'Rock1_Idle'),
  rock1Run(name: 'Rock1_Run'),
  rock2Hit(name: 'Rock2_Hit'),
  rock2Idle(name: 'Rock2_Idle'),
  rock2Run(name: 'Rock2_Run'),
  rock3Hit(name: 'Rock3_Hit'),
  rock3Idle(name: 'Rock3_Idle'),
  rock3Run(name: 'Rock3_Run'),
  run(name: 'Run'),
  shellIdle(name: 'Shell Idle'),
  shellTopHit(name: 'Shell Top Hit'),
  shellWallHit(name: 'Shell Wall Hit'),
  spikesIn(name: 'Spikes in'),
  spikesOut(name: 'Spikes out'),
  walk(name: 'Walk');

  const EnemyState({required this.name});

  final String name;
}

class EnemyAnimationData {
  final String fileName;
  final int frames;
  final Vector2 textureSize;
  final bool loop;

  const EnemyAnimationData({
    required this.fileName,
    required this.frames,
    required this.textureSize,
    this.loop = true,
  });
}

Map<EnemyType, Map<EnemyState, EnemyAnimationData>>
enemyAssets = <EnemyType, Map<EnemyState, EnemyAnimationData>>{
  EnemyType.angryPig: <EnemyState, EnemyAnimationData>{
    EnemyState.hit1: EnemyAnimationData(
      fileName: 'Hit 1 (36x30).png',
      frames: 5,
      textureSize: Vector2(36, 30),
      loop: false,
    ),
    EnemyState.hit2: EnemyAnimationData(
      fileName: 'Hit 2 (36x30).png',
      frames: 5,
      textureSize: Vector2(36, 30),
      loop: false,
    ),
    EnemyState.idle: EnemyAnimationData(
      fileName: 'Idle (36x30).png',
      frames: 11,
      textureSize: Vector2(36, 30),
    ),
    EnemyState.run: EnemyAnimationData(fileName: 'Run (36x30).png', frames: 12, textureSize: Vector2(36, 30)),
    EnemyState.walk: EnemyAnimationData(
      fileName: 'Walk (36x30).png',
      frames: 16,
      textureSize: Vector2(36, 30),
    ),
  },

  EnemyType.bat: <EnemyState, EnemyAnimationData>{
    EnemyState.ceilingIn: EnemyAnimationData(
      fileName: 'Ceiling In (46x30).png',
      frames: 7,
      textureSize: Vector2(46, 30),
      loop: false,
    ),
    EnemyState.ceilingOut: EnemyAnimationData(
      fileName: 'Ceiling Out (46x30).png',
      frames: 7,
      textureSize: Vector2(46, 30),
      loop: false,
    ),
    EnemyState.flying: EnemyAnimationData(
      fileName: 'Flying (46x30).png',
      frames: 7,
      textureSize: Vector2(46, 30),
    ),
    EnemyState.hit: EnemyAnimationData(
      fileName: 'Hit (46x30).png',
      frames: 5,
      textureSize: Vector2(46, 30),
      loop: false,
    ),
    EnemyState.idle: EnemyAnimationData(
      fileName: 'Idle (46x30).png',
      frames: 5,
      textureSize: Vector2(46, 30),
    ),
  },

  EnemyType.bee: <EnemyState, EnemyAnimationData>{
    EnemyState.attack: EnemyAnimationData(
      fileName: 'Attack (36x34).png',
      frames: 8,
      textureSize: Vector2(36, 34),
    ),
    EnemyState.hit: EnemyAnimationData(
      fileName: 'Hit (36x34).png',
      frames: 5,
      textureSize: Vector2(36, 34),
      loop: false,
    ),
    EnemyState.idle: EnemyAnimationData(
      fileName: 'Idle (36x34).png',
      frames: 6,
      textureSize: Vector2(36, 34),
    ),
  },

  EnemyType.blueBird: <EnemyState, EnemyAnimationData>{
    EnemyState.flying: EnemyAnimationData(
      fileName: 'Flying (32x32).png',
      frames: 9,
      textureSize: Vector2(32, 32),
    ),
    EnemyState.hit: EnemyAnimationData(
      fileName: 'Hit (32x32).png',
      frames: 5,
      textureSize: Vector2(32, 32),
      loop: false,
    ),
  },

  EnemyType.bunny: <EnemyState, EnemyAnimationData>{
    EnemyState.fall: EnemyAnimationData(fileName: 'Fall.png', frames: 1, textureSize: Vector2(34, 44)),
    EnemyState.hit: EnemyAnimationData(
      fileName: 'Hit (34x44).png',
      frames: 5,
      textureSize: Vector2(34, 44),
      loop: false,
    ),
    EnemyState.idle: EnemyAnimationData(
      fileName: 'Idle (34x44).png',
      frames: 8,
      textureSize: Vector2(34, 44),
    ),
    EnemyState.jump: EnemyAnimationData(fileName: 'Jump.png', frames: 1, textureSize: Vector2(34, 44)),
    EnemyState.run: EnemyAnimationData(fileName: 'Run (34x44).png', frames: 12, textureSize: Vector2(34, 44)),
  },

  EnemyType.chameleon: <EnemyState, EnemyAnimationData>{
    EnemyState.attack: EnemyAnimationData(
      fileName: 'Attack (84x38).png',
      frames: 10,
      textureSize: Vector2(84, 38),
    ),
    EnemyState.hit: EnemyAnimationData(
      fileName: 'Hit (84x38).png',
      frames: 5,
      textureSize: Vector2(84, 38),
      loop: false,
    ),
    EnemyState.idle: EnemyAnimationData(
      fileName: 'Idle (84x38).png',
      frames: 13,
      textureSize: Vector2(84, 38),
    ),
    EnemyState.run: EnemyAnimationData(fileName: 'Run (84x38).png', frames: 8, textureSize: Vector2(84, 38)),
  },

  EnemyType.chicken: <EnemyState, EnemyAnimationData>{
    EnemyState.hit: EnemyAnimationData(
      fileName: 'Hit (32x34).png',
      frames: 5,
      textureSize: Vector2(32, 34),
      loop: false,
    ),
    EnemyState.idle: EnemyAnimationData(
      fileName: 'Idle (32x34).png',
      frames: 13,
      textureSize: Vector2(32, 34),
    ),
    EnemyState.run: EnemyAnimationData(fileName: 'Run (32x34).png', frames: 14, textureSize: Vector2(32, 34)),
  },

  EnemyType.duck: <EnemyState, EnemyAnimationData>{
    EnemyState.fall: EnemyAnimationData(
      fileName: 'Fall (36x36).png',
      frames: 1,
      textureSize: Vector2(36, 36),
    ),
    EnemyState.hit: EnemyAnimationData(
      fileName: 'Hit (36x36).png',
      frames: 5,
      textureSize: Vector2(36, 36),
      loop: false,
    ),
    EnemyState.idle: EnemyAnimationData(
      fileName: 'Idle (36x36).png',
      frames: 10,
      textureSize: Vector2(36, 36),
    ),
    EnemyState.jump: EnemyAnimationData(
      fileName: 'Jump (36x36).png',
      frames: 1,
      textureSize: Vector2(36, 36),
    ),
    EnemyState.jumpAnticipation: EnemyAnimationData(
      fileName: 'Jump Anticipation (36x36).png',
      frames: 4,
      textureSize: Vector2(36, 36),
      loop: false,
    ),
  },

  EnemyType.fatBird: <EnemyState, EnemyAnimationData>{
    EnemyState.fall: EnemyAnimationData(
      fileName: 'Fall (40x48).png',
      frames: 1,
      textureSize: Vector2(40, 48),
    ),
    EnemyState.ground: EnemyAnimationData(
      fileName: 'Ground (40x48).png',
      frames: 7,
      textureSize: Vector2(40, 48),
    ),
    EnemyState.hit: EnemyAnimationData(
      fileName: 'Hit (40x48).png',
      frames: 5,
      textureSize: Vector2(40, 48),
      loop: false,
    ),
    EnemyState.idle: EnemyAnimationData(
      fileName: 'Idle (40x48).png',
      frames: 8,
      textureSize: Vector2(40, 48),
    ),
  },

  EnemyType.ghost: <EnemyState, EnemyAnimationData>{
    EnemyState.appear: EnemyAnimationData(
      fileName: 'Appear (44x30).png',
      frames: 13,
      textureSize: Vector2(44, 30),
      loop: false,
    ),
    EnemyState.desappear: EnemyAnimationData(
      fileName: 'Desappear (44x30).png',
      frames: 13,
      textureSize: Vector2(44, 30),
      loop: false,
    ),
    EnemyState.hit: EnemyAnimationData(
      fileName: 'Hit (44x30).png',
      frames: 5,
      textureSize: Vector2(44, 30),
      loop: false,
    ),
    EnemyState.idle: EnemyAnimationData(
      fileName: 'Idle (44x30).png',
      frames: 10,
      textureSize: Vector2(44, 30),
    ),
  },
};

EnemyAnimationData enemyAnimationData(EnemyType type, EnemyState state) {
  final EnemyAnimationData? data = enemyAssets[type]?[state];

  if (data == null) {
    throw ArgumentError('Enemy animation not found: ${type.folder} / ${state.name}');
  }

  return data;
}

String enemyPath(EnemyType type, EnemyState state) {
  final EnemyAnimationData data = enemyAnimationData(type, state);

  return 'Enemies/${type.folder}/${data.fileName}';
}
