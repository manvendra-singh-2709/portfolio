import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/sprite.dart';
import 'package:perlin/perlin.dart';
import 'package:portfolio/evolution/utils/enums.dart';
import 'package:portfolio/evolution/utils/sizes.dart';
import 'package:portfolio/evolution/world/hex_tile.dart';
import 'package:portfolio/evolution/world/region_element.dart';
import 'package:portfolio/globals/globals.dart';
import 'hex_grid.dart';

class WorldGenerator extends Component with HasGameReference {
  WorldGenerator({
    required this.world,
    required this.worldOrigin,
    required this.worldSize,
    this.hexRadius = 28,
  });

  final Component world;

  final Vector2 worldOrigin;
  final Vector2 worldSize;

  final double hexRadius;

  late final HexGrid grid;

  late final SpriteSheet cactusSpriteSheet;

  late final List<List<double>> temperatureNoise;
  late final List<List<double>> rainfallNoise;

  HexGrid get hexGrid => grid;

  late Map<REGION_ELEMENTS, String> regionAssets;

  static const double elementCellSize = 100.0;
  final Map<int, List<RegionElement>> elementsByCell = <int, List<RegionElement>>{};

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    regionAssets = regionElementAssets();

    final double hexWidth = sqrt(3) * hexRadius;
    final double hexHeight = 2 * hexRadius;

    final int cols = (worldSize.x / hexWidth).ceil() + 4;

    final int rows = (worldSize.y / (hexHeight * 0.75)).ceil() + 4;

    temperatureNoise = perlin2d(width: cols ~/ 6 + 1, height: rows ~/ 6 + 1, frequency: 6);

    rainfallNoise = perlin2d(width: cols ~/ 6 + 1, height: rows ~/ 6 + 1, frequency: 6);

    grid = HexGrid(worldOrigin: worldOrigin, worldSize: worldSize, hexRadius: hexRadius);

    grid.generate();

    _initializeGrass();
    _generateWaterBodies();
    _generateBiomeAroundWaterBodies();
    _preventDesertTundraContact();
    _generateForests();
    _fillForestHoles();
    _updateTileColors();

    world.addAll(grid.buildComponents());

    _generateRegionElements();
  }

  void _initializeGrass() {
    for (final HexTile tile in grid.tiles) {
      tile.region = REGION.grass;
    }
  }

  void _updateTileColors() {
    for (final HexTile tile in grid.tiles) {
      tile.color = regionColors[tile.region]!;
    }
  }

  void _generateWaterBodies() {
    final Random random = Random();

    // Random number of water bodies: 9–12
    final int numberOfBodies =
        Global.minWaterBodies + random.nextInt(Global.maxWaterBodies - Global.minWaterBodies + 1);

    int created = 0;

    // Shuffle all tiles so locations are random.
    final List<HexTile> candidates = List<HexTile>.from(grid.tiles);
    candidates.shuffle(random);

    for (final HexTile center in candidates) {
      if (created >= numberOfBodies) {
        break;
      }

      // Don't place a body too close to another water body.
      if (_tooCloseToWater(center)) {
        continue;
      }

      // Randomly choose one of the allowed shapes.
      final List<HexTile> body = _createRandomWaterShape(center, random);

      // Make sure the entire body is still grass.
      if (body.every((HexTile tile) => tile.region == REGION.grass)) {
        for (final HexTile tile in body) {
          tile.region = REGION.water;
        }

        created++;
      }
    }
  }

  List<HexTile> _createRandomWaterShape(HexTile center, Random random) {
    final List<List<(int, int)>> shapes = <List<(int, int)>>[
      // -------------------------
      // Single
      // -------------------------
      <(int, int)>[(0, 0)],

      // -------------------------
      // Horizontal 2
      // -------------------------
      <(int, int)>[(0, 0), (1, 0)],

      // -------------------------
      // Vertical 2
      // -------------------------
      <(int, int)>[(0, 0), (0, 1)],

      // -------------------------
      // Horizontal 3
      // -------------------------
      <(int, int)>[(0, 0), (1, 0), (2, 0)],

      // -------------------------
      // Vertical 3
      // -------------------------
      <(int, int)>[(0, 0), (0, 1), (0, 2)],

      // -------------------------
      // Triangle
      //
      // W
      // WW
      // -------------------------
      <(int, int)>[(0, 0), (0, 1), (1, 1)],

      // -------------------------
      // Flipped triangle
      //
      // WW
      // W
      // -------------------------
      <(int, int)>[(0, 0), (1, 0), (1, 1)],

      // -------------------------
      // Small triangle
      //
      // WW
      //  W
      // -------------------------
      <(int, int)>[(0, 0), (1, 0), (0, 1)],

      // -------------------------
      // Vertical triangle
      //
      // W
      // WW
      // -------------------------
      <(int, int)>[(0, 0), (0, 1), (-1, 1)],

      // -------------------------
      // Square
      //
      // WW
      // WW
      // -------------------------
      <(int, int)>[(0, 0), (1, 0), (0, 1), (1, 1)],
    ];

    final List<(int, int)> shape = shapes[random.nextInt(shapes.length)];

    final List<HexTile> result = <HexTile>[];

    for (final (int dq, int dr) in shape) {
      final HexTile? tile = grid.tileAtAxial(center.q + dq, center.r + dr);

      if (tile == null) {
        return <HexTile>[];
      }

      result.add(tile);
    }

    return result;
  }

  bool _tooCloseToWater(HexTile center) {
    for (final HexTile tile in grid.neighbours(center)) {
      if (tile.region == REGION.water) {
        return true;
      }

      // Also check one additional ring.
      for (final HexTile n in grid.neighbours(tile)) {
        if (n.region == REGION.water) {
          return true;
        }
      }
    }

    return false;
  }

  void _generateBiomeAroundWaterBodies() {
    final Random random = Random();

    // Find every water tile.
    final List<HexTile> waterTiles = grid.tiles.where((HexTile tile) => tile.region == REGION.water).toList();

    // Group connected water tiles into individual water bodies.
    final Set<HexTile> processed = <HexTile>{};

    for (final HexTile waterSeed in waterTiles) {
      if (processed.contains(waterSeed)) {
        continue;
      }

      final List<HexTile> waterBody = _getConnectedWaterBody(waterSeed, processed);

      if (waterBody.isEmpty) {
        continue;
      }

      // ----------------------------------------------------------
      // ONE biome for this entire water body
      // ----------------------------------------------------------

      final REGION biome = random.nextBool() ? REGION.desert : REGION.tundra;

      // Random number of rings for this water body.
      final int rings =
          Global.minBiomeRings + random.nextInt(Global.maxBiomeRings - Global.minBiomeRings + 1);

      _generateRingsAroundWaterBody(waterBody, biome, rings, random);
    }
  }

  List<HexTile> _getConnectedWaterBody(HexTile start, Set<HexTile> processed) {
    final List<HexTile> body = <HexTile>[];
    final List<HexTile> queue = <HexTile>[start];

    processed.add(start);

    while (queue.isNotEmpty) {
      final HexTile current = queue.removeAt(0);

      body.add(current);

      for (final HexTile neighbour in grid.neighbours(current)) {
        if (neighbour.region != REGION.water) {
          continue;
        }

        if (processed.contains(neighbour)) {
          continue;
        }

        processed.add(neighbour);
        queue.add(neighbour);
      }
    }

    return body;
  }

  void _generateRingsAroundWaterBody(List<HexTile> waterBody, REGION biome, int ringCount, Random random) {
    if (ringCount <= 0) {
      return;
    }

    // ==========================================================
    // 1. FIND DISTANCE FROM THE NEAREST WATER TILE
    // ==========================================================

    final Map<HexTile, int> distance = <HexTile, int>{};

    final List<HexTile> queue = <HexTile>[];

    // Every water tile starts at distance 0.
    for (final HexTile water in waterBody) {
      distance[water] = 0;
      queue.add(water);
    }

    // BFS outward from the ENTIRE water body.
    while (queue.isNotEmpty) {
      final HexTile current = queue.removeAt(0);

      final int currentDistance = distance[current]!;

      if (currentDistance >= ringCount) {
        continue;
      }

      for (final HexTile neighbour in grid.neighbours(current)) {
        if (distance.containsKey(neighbour)) {
          continue;
        }

        // Only grow through grass.
        //
        // This means we don't overwrite another biome.
        if (neighbour.region != REGION.grass) {
          continue;
        }

        final int nextDistance = currentDistance + 1;

        if (nextDistance > ringCount) {
          continue;
        }

        distance[neighbour] = nextDistance;
        queue.add(neighbour);
      }
    }

    // ==========================================================
    // 2. CREATE THE BIOME RINGS
    // ==========================================================

    for (final MapEntry<HexTile, int> entry in distance.entries) {
      final HexTile tile = entry.key;
      final int ring = entry.value;

      // NEVER change water.
      if (tile.region == REGION.water) {
        continue;
      }

      if (ring >= 1 && ring <= ringCount) {
        tile.region = biome;
      }
    }

    // ==========================================================
    // 3. HOW MANY OUTER RINGS GET RANDOM GRASS
    // ==========================================================

    int outerRingsToModify;

    if (ringCount <= 2) {
      // 1 or 2 rings:
      // disturb only the outermost ring.
      outerRingsToModify = 1;
    } else if (ringCount <= 4) {
      // 3 or 4 rings:
      // disturb outer 2 rings.
      outerRingsToModify = 2;
    } else {
      // 5+ rings:
      // disturb outer 3 rings.
      outerRingsToModify = 3;
    }

    outerRingsToModify = min(outerRingsToModify, ringCount);

    final int firstAffectedRing = ringCount - outerRingsToModify + 1;

    // ==========================================================
    // 4. RANDOMLY REMOVE SOME TILES
    //
    // IMPORTANT:
    //
    // A tile can only become grass if doing so does NOT
    // disconnect the remaining biome from the water.
    //
    // We perform the connectivity test HERE.
    // No extra function is needed.
    // ==========================================================

    final List<HexTile> candidates = <HexTile>[];

    for (final MapEntry<HexTile, int> entry in distance.entries) {
      final HexTile tile = entry.key;
      final int ring = entry.value;

      if (ring < firstAffectedRing || ring > ringCount) {
        continue;
      }

      if (tile.region != biome) {
        continue;
      }

      candidates.add(tile);
    }

    // Randomize the order so the holes are different every time.
    candidates.shuffle(random);

    for (final HexTile candidate in candidates) {
      if (random.nextDouble() >= Global.outerGrassChance) {
        continue;
      }

      // NEVER modify water.
      if (candidate.region == REGION.water) {
        continue;
      }

      if (candidate.region != biome) {
        continue;
      }

      // --------------------------------------------------------
      // Temporarily make this tile grass.
      // --------------------------------------------------------

      candidate.region = REGION.grass;

      // --------------------------------------------------------
      // Check whether every remaining biome tile belonging to
      // THIS water body's rings is still connected to the
      // inner biome.
      //
      // We start from all biome tiles directly touching water.
      // --------------------------------------------------------

      final Set<HexTile> visited = <HexTile>{};

      final List<HexTile> floodQueue = <HexTile>[];

      // Start from biome tiles touching this water body.
      for (final HexTile water in waterBody) {
        for (final HexTile neighbour in grid.neighbours(water)) {
          if (neighbour.region != biome) {
            continue;
          }

          if (visited.add(neighbour)) {
            floodQueue.add(neighbour);
          }
        }
      }

      // --------------------------------------------------------
      // Flood through the biome.
      // --------------------------------------------------------

      while (floodQueue.isNotEmpty) {
        final HexTile current = floodQueue.removeAt(0);

        for (final HexTile neighbour in grid.neighbours(current)) {
          if (visited.contains(neighbour)) {
            continue;
          }

          if (neighbour.region != biome) {
            continue;
          }

          // Only consider tiles belonging to THIS water body's
          // generated rings.
          if (!distance.containsKey(neighbour)) {
            continue;
          }

          if (distance[neighbour]! < 1 || distance[neighbour]! > ringCount) {
            continue;
          }

          visited.add(neighbour);
          floodQueue.add(neighbour);
        }
      }

      // --------------------------------------------------------
      // See whether removing candidate isolated ANY biome tile
      // in this water body's generated region.
      // --------------------------------------------------------

      bool disconnected = false;

      for (final MapEntry<HexTile, int> entry in distance.entries) {
        final HexTile tile = entry.key;
        final int ring = entry.value;

        if (ring < 1 || ring > ringCount) {
          continue;
        }

        if (tile.region != biome) {
          continue;
        }

        if (!visited.contains(tile)) {
          disconnected = true;
          break;
        }
      }

      // --------------------------------------------------------
      // If candidate caused an isolated biome piece:
      //
      // RESTORE IT.
      //
      // Otherwise leave it as grass.
      // --------------------------------------------------------

      if (disconnected) {
        candidate.region = biome;
      }
    }

    // ==========================================================
    // 5. ABSOLUTE SAFETY:
    // WATER REMAINS WATER
    // ==========================================================

    for (final HexTile water in waterBody) {
      water.region = REGION.water;
    }
  }

  void _generateForests() {
    final Random random = Random();

    // Fewer seeds = larger forest regions.
    final int forestSeeds = max(2, grid.tiles.length ~/ 300);

    int created = 0;
    int attempts = 0;

    while (created < forestSeeds && attempts < forestSeeds * 30) {
      attempts++;

      final HexTile seed = grid.tiles[random.nextInt(grid.tiles.length)];

      // Forest can only start on grass.
      if (seed.region != REGION.grass) {
        continue;
      }

      // Never start a forest next to water/desert/tundra.
      if (_touchesForbiddenBiome(seed)) {
        continue;
      }

      _growLargeForest(seed, random);

      created++;
    }

    // Remove small grass holes inside forests.
    _fillForestHoles();
  }

  void _growLargeForest(HexTile seed, Random random) {
    final List<HexTile> frontier = <HexTile>[seed];

    final Set<HexTile> visited = <HexTile>{seed};

    seed.region = REGION.forest;

    // Increase these for larger forests.
    final int targetSize = 60 + random.nextInt(80);

    while (frontier.isNotEmpty) {
      final int index = random.nextInt(frontier.length);

      final HexTile current = frontier.removeAt(index);

      for (final HexTile neighbour in grid.neighbours(current)) {
        if (visited.contains(neighbour)) {
          continue;
        }

        visited.add(neighbour);

        // Only grass can become forest.
        if (neighbour.region != REGION.grass) {
          continue;
        }

        // Forest must never touch these biomes.
        if (_touchesForbiddenBiome(neighbour)) {
          continue;
        }

        // High probability gives large connected forests.
        if (random.nextDouble() < 0.78) {
          neighbour.region = REGION.forest;
          frontier.add(neighbour);
        }
      }

      final int forestCount = visited.where((HexTile t) => t.region == REGION.forest).length;

      if (forestCount >= targetSize) {
        break;
      }
    }
  }

  bool _touchesForbiddenBiome(HexTile tile) {
    for (final HexTile neighbour in grid.neighbours(tile)) {
      if (neighbour.region == REGION.water ||
          neighbour.region == REGION.desert ||
          neighbour.region == REGION.tundra) {
        return true;
      }
    }

    return false;
  }

  void _fillForestHoles() {
    bool changed = true;

    while (changed) {
      changed = false;

      for (final HexTile tile in grid.tiles) {
        if (tile.region != REGION.grass) {
          continue;
        }

        final List<HexTile> neighbours = grid.neighbours(tile);

        if (neighbours.length < 6) {
          continue;
        }

        final int forestCount = neighbours.where((HexTile n) => n.region == REGION.forest).length;

        if (forestCount >= 5) {
          tile.region = REGION.forest;
          changed = true;
        }
      }
    }
  }

  void _preventDesertTundraContact() {
    final Set<HexTile> toGrass = <HexTile>{};

    for (final HexTile tile in grid.tiles) {
      if (tile.region != REGION.desert && tile.region != REGION.tundra) {
        continue;
      }

      for (final HexTile neighbour in grid.neighbours(tile)) {
        if (tile.region == REGION.desert && neighbour.region == REGION.tundra) {
          // Convert the boundary tile with fewer biome neighbours.
          final int tileBiomeNeighbours = grid
              .neighbours(tile)
              .where((n) => n.region == REGION.desert)
              .length;

          final int neighbourBiomeNeighbours = grid
              .neighbours(neighbour)
              .where((n) => n.region == REGION.tundra)
              .length;

          if (tileBiomeNeighbours <= neighbourBiomeNeighbours) {
            toGrass.add(tile);
          } else {
            toGrass.add(neighbour);
          }
        }

        if (tile.region == REGION.tundra && neighbour.region == REGION.desert) {
          final int tileBiomeNeighbours = grid
              .neighbours(tile)
              .where((n) => n.region == REGION.tundra)
              .length;

          final int neighbourBiomeNeighbours = grid
              .neighbours(neighbour)
              .where((n) => n.region == REGION.desert)
              .length;

          if (tileBiomeNeighbours <= neighbourBiomeNeighbours) {
            toGrass.add(tile);
          } else {
            toGrass.add(neighbour);
          }
        }
      }
    }

    for (final HexTile tile in toGrass) {
      tile.region = REGION.grass;
    }
  }

  REGION_ELEMENTS _randomRegionElement(Map<REGION_ELEMENTS, double> elements, Random random) {
    final double roll = random.nextDouble();

    double cumulative = 0.0;

    for (final MapEntry<REGION_ELEMENTS, double> entry in elements.entries) {
      cumulative += entry.value;

      if (roll < cumulative) {
        return entry.key;
      }
    }
    return elements.keys.last;
  }

  int getCellKey(Vector2 position) {
    final x = (position.x / elementCellSize).floor();
    final y = (position.y / elementCellSize).floor();

    return x * 100000 + y;
  }

  List<RegionElement> getNearbyElements(Vector2 position, List<REGION_ELEMENTS> elementList) {
    final int centerX = (position.x / elementCellSize).floor();
    final int centerY = (position.y / elementCellSize).floor();

    final List<RegionElement> result = <RegionElement>[];

    for (int dx = -1; dx <= 1; dx++) {
      for (int dy = -1; dy <= 1; dy++) {
        final int key = (centerX + dx) * 100000 + (centerY + dy);

        final List<RegionElement>? elements = elementsByCell[key];

        if (elements == null) {
          continue;
        }

        for (final RegionElement element in elements) {
          if (elementList.contains(element.elementType)) {
            result.add(element);
          }
        }
      }
    }

    return result;
  }

  void _generateRegionElements() {
    final Random random = Random();

    for (final HexTile tile in grid.tiles) {
      final Map<REGION_ELEMENTS, double>? available = regionWiseElementMap[tile.region];

      if (available == null || available.isEmpty) {
        continue;
      }

      int minElements;
      int maxElements;

      switch (tile.region) {
        case REGION.grass:
          minElements = 2;
          maxElements = 3;
          break;

        case REGION.forest:
          minElements = 6;
          maxElements = 9;
          break;

        case REGION.tundra:
          minElements = 2;
          maxElements = 3;
          break;

        case REGION.desert:
          minElements = 0;
          maxElements = 1;
          break;

        case REGION.water:
          minElements = 0;
          maxElements = 1;
          break;

        case REGION.undefined:
          continue;
      }

      final int elementCount = minElements + random.nextInt(maxElements - minElements + 1);

      for (int i = 0; i < elementCount; i++) {
        REGION_ELEMENTS element;

        // --------------------------------------------------------
        // Cattails are special:
        //
        // They may ONLY appear on a water tile that has at least
        // one NON-water neighbour.
        //
        // Therefore they cannot appear:
        //   - inside the water body
        //   - on a tile surrounded by water
        //   - on a tile whose every neighbour is water
        // --------------------------------------------------------

        if (tile.region == REGION.water &&
            random.nextBool() &&
            available.containsKey(REGION_ELEMENTS.cattail)) {
          final List<HexTile> neighbours = grid.neighbours(tile);

          final bool isWaterEdge = neighbours.any((HexTile n) => n.region != REGION.water);

          if (isWaterEdge) {
            element = REGION_ELEMENTS.cattail;
          } else {
            // Don't force cattail if this is an interior water tile.
            final Map<REGION_ELEMENTS, double> nonCattails = Map<REGION_ELEMENTS, double>.fromEntries(
              available.entries.where((entry) => entry.key != REGION_ELEMENTS.cattail),
            );

            if (nonCattails.isEmpty) {
              continue;
            }

            element = _randomRegionElement(nonCattails, random);
          }
        } else {
          element = _randomRegionElement(available, random);
        }

        // --------------------------------------------------------
        // Random position INSIDE the hex tile
        // --------------------------------------------------------

        final double offsetX = (random.nextDouble() * 2.0 - 1.0) * (sqrt(3) * hexRadius * 0.28);

        final double offsetY = (random.nextDouble() * 2.0 - 1.0) * (hexRadius * 0.35);

        final Vector2 position = tile.center.clone() - Vector2.all(Global.hexRadius)
          ..x += offsetX
          ..y += offsetY;

        final String assetName = regionAssets[element]!;
        final Image image = game.images.fromCache(assetName);
        final Sprite sprite = Sprite(image);
        final double scale = 0.85 + random.nextDouble() * 0.30;
        final Vector2 elementSize = element.size * scale;
        final RegionElement regionElement = RegionElement(
          position: position,
          tile: tile,
          elementType: element,
        )..priority = RenderPriority.regionElement + position.y.toInt();

        final int cellKey = getCellKey(position);

        elementsByCell.putIfAbsent(cellKey, () => <RegionElement>[]).add(regionElement);

        final SpriteComponent spriteComponent = SpriteComponent(
          sprite: sprite,
          anchor: Anchor.bottomCenter,
          position: Vector2.zero(),
          size: elementSize,
        );

        if (random.nextBool()) {
          spriteComponent.flipHorizontally();
        }

        regionElement.add(spriteComponent);
        world.add(regionElement);
      }
    }
  }
}
