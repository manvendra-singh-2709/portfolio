import 'dart:math';

import 'package:portfolio/evolution/utils/enums.dart';
import 'package:portfolio/evolution/world/hex_component.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

import 'hex_tile.dart';

class HexGrid {
  HexGrid({required this.worldOrigin, required this.worldSize, required this.hexRadius});

  final Vector2 worldOrigin;
  final Vector2 worldSize;

  /// Radius of one hex
  final double hexRadius;

  /// Generated tiles
  final List<HexTile> tiles = <HexTile>[];

  /// Fast lookup
  final Map<(int, int), HexTile> tileMap = <(int, int), HexTile>{};

  //--------------------------------------------------
  // Build grid
  //--------------------------------------------------

  void generate() {
    tiles.clear();
    tileMap.clear();

    final double hexWidth = sqrt(3) * hexRadius;
    final double hexHeight = 2 * hexRadius;

    final double verticalSpacing = hexHeight * 0.75;

    final int rows = (worldSize.y / verticalSpacing).ceil() + 2;

    final int cols = (worldSize.x / hexWidth).ceil() + 2;

    final int qMin = -(rows ~/ 2);
    final int qMax = cols;

    final int rMin = -(rows ~/ 2);
    final int rMax = rows;

    for (int r = rMin; r <= rMax; r++) {
      for (int q = qMin; q <= qMax; q++) {
        final Vector2 worldPos = axialToWorld(q, r);

        if (worldPos.x < 0 || worldPos.x > worldSize.x || worldPos.y < 0 || worldPos.y > worldSize.y) {
          continue;
        }

        final HexTile tile = HexTile(q: q, r: r, center: worldPos);

        tiles.add(tile);
        tileMap[(q, r)] = tile;
      }
    }
  }

  //--------------------------------------------------
  // Coordinate conversion
  //--------------------------------------------------

  Vector2 axialToWorld(int q, int r) {
    final double x = hexRadius * sqrt(3) * (q + r / 2);

    final double y = hexRadius * 1.5 * r;

    return Vector2(x, y);
  }

  //--------------------------------------------------
  // Reverse lookup
  //--------------------------------------------------

  HexTile? tileAtAxial(int q, int r) {
    return tileMap[(q, r)];
  }

  //--------------------------------------------------
  // Hex neighbours
  //--------------------------------------------------

  static const List<(int, int)> neighbourOffsets = <(int, int)>[
    (1, 0),
    (1, -1),
    (0, -1),
    (-1, 0),
    (-1, 1),
    (0, 1),
  ];

  List<HexTile> neighbours(HexTile tile) {
    final List<HexTile> list = <HexTile>[];

    for (final (int dq, int dr) in neighbourOffsets) {
      final HexTile? n = tileAtAxial(tile.q + dq, tile.r + dr);

      if (n != null) {
        list.add(n);
      }
    }

    return list;
  }

  //--------------------------------------------------
  // Pixel -> nearest tile
  //--------------------------------------------------

  HexTile? tileAtWorld(Vector2 point) {
    HexTile? closest;

    double best = double.infinity;

    for (final HexTile tile in tiles) {
      final double d = tile.center.distanceToSquared(point);

      if (d < best) {
        best = d;
        closest = tile;
      }
    }

    return closest;
  }

  //--------------------------------------------------
  // Iterate
  //--------------------------------------------------

  void forEach(void Function(HexTile tile) fn) {
    for (final HexTile tile in tiles) {
      fn(tile);
    }
  }

  //--------------------------------------------------
  // Region flood fill helper
  //--------------------------------------------------

  List<HexTile> connectedRegion(HexTile start) {
    final List<HexTile> cluster = <HexTile>[];

    final List<HexTile> stack = <HexTile>[start];

    final REGION region = start.region;

    while (stack.isNotEmpty) {
      final HexTile current = stack.removeLast();

      if (current.visited) {
        continue;
      }

      current.visited = true;

      cluster.add(current);

      for (final HexTile n in neighbours(current)) {
        if (!n.visited && n.region == region) {
          stack.add(n);
        }
      }
    }

    return cluster;
  }

  //--------------------------------------------------
  // Reset flood fill state
  //--------------------------------------------------

  void clearVisited() {
    for (final HexTile tile in tiles) {
      tile.visited = false;
    }
  }

  List<HexComponent> buildComponents() {
    return tiles.map((HexTile tile) => HexComponent(tile: tile, radius: hexRadius, grid: this)).toList();
  }
}
