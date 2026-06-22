import 'dart:async';

import 'package:flame/components.dart';
import 'package:portfolio/game/pixel_adventure.dart';
import 'package:portfolio/globals/globals.dart';

class BackgroundTile extends SpriteComponent with HasGameReference<PixelAdventure> {
  final String color;
  final double scrollSpeed = 0.4;

  BackgroundTile({super.position, required this.color});

  @override
  FutureOr<void> onLoad() {
    priority = -1;
    size = Vector2.all(64.6);
    sprite = Sprite(game.images.fromCache('Background/$color.png'));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    position.y += scrollSpeed;
    double tileSize = Global.tileSize;
    int scrollHeight = (game.size.y / tileSize).floor();

    if (position.y > scrollHeight * tileSize) position.y = -tileSize;

    super.update(dt);
  }
}
