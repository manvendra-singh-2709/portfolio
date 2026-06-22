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

enum Layers {
  spawnPoints('Spawnpoints');

  const Layers(this.name);

  final String name;
}
