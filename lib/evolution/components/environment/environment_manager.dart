import 'package:flame/components.dart';
import 'package:portfolio/evolution/utils/enums.dart';
import 'package:portfolio/evolution/world/hex_grid.dart';
import 'package:portfolio/evolution/world/hex_tile.dart';

class EnvironmentManager extends Component {
  EnvironmentManager({
    required this.worldOrigin,
    required this.worldSize,
    required this.world,
    required this.grid,
    this.bushCount = 100,
    this.minBushDistance = 70,
  });

  final Vector2 worldOrigin;
  final Vector2 worldSize;

  final Component world;
  final HexGrid grid;

  final int bushCount;
  final double minBushDistance;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    for (final HexTile tile in grid.tiles) {
      spawnEnvironment(tile);
    }
  }

  void spawnEnvironment(HexTile tile) {
    switch (tile.region) {
      case REGION.grass:
        _spawnGrass(tile);
        break;

      case REGION.desert:
        _spawnDesert(tile);
        break;

      case REGION.water:
        _spawnWater(tile);
        break;

      case REGION.forest:
        _spawnForest(tile);
        break;

      case REGION.tundra:
        _spawnTundra(tile);
        break;

      case REGION.undefined:
        break;
    }
  }

  void _spawnForest(HexTile tile) {}

  void _spawnWater(HexTile tile) {}

  void _spawnDesert(HexTile tile) {}

  void _spawnTundra(HexTile tile) {}

  void _spawnGrass(HexTile tile) {}
}
