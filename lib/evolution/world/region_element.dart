import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:portfolio/evolution/utils/enums.dart';
import 'package:portfolio/evolution/world/hex_tile.dart';

class RegionElement extends PositionComponent with CollisionCallbacks {
  RegionElement({required super.position, required this.tile, required this.elementType});

  final HexTile tile;
  final REGION_ELEMENTS elementType;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // if (REGION_ELEMENTS.trees.contains(elementType)) {
    // add(RectangleHitbox(size: Vector2.all(40), anchor: Anchor.bottomCenter));
    // }
  }
}
