import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:portfolio/game/components/actors/player.dart';
import 'package:portfolio/game/utils/enums.dart';

class Level extends World {
  late TiledComponent level;

  final String levelName;
  final Player player;

  Level({required this.levelName, required this.player});

  @override
  Future<void> onLoad() async {
    level = await TiledComponent.load(
      'Level-$levelName.tmx',
      Vector2.all(16),
      prefix: 'game/tiles/',
    );

    final ObjectGroup? spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>(
      Layers.spawnPoints.name,
    );

    add(level);

    for (final TiledObject spawnPoint in spawnPointsLayer!.objects) {
      switch (spawnPoint.class_) {
        case 'Player':
          player.position = Vector2(spawnPoint.x, spawnPoint.y);
          add(player);
          break;
        default:
      }
    }

    return super.onLoad();
  }
}
