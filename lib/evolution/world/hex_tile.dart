import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/evolution/utils/enums.dart';
import 'package:portfolio/evolution/world/region_element.dart';

class HexTile {
  HexTile({required this.q, required this.r, required this.center, this.region = REGION.grass}) {
    color = regionColors[region]!;
  }

  /// Axial coordinates
  final int q;
  final int r;

  bool expanded = false;

  /// World position of the centre
  final Vector2 center;

  REGION region;

  late Color color;

  final List<RegionElement> elements = <RegionElement>[];

  double temperature = 0;
  double rainfall = 0;

  bool visited = false;

  void setColor(Color c) {
    color = c;
  }

  @override
  String toString() {
    return 'Hex($q,$r)';
  }
}
