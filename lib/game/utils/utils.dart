import 'package:portfolio/game/components/items/hitbox.dart';
import 'package:portfolio/game/components/items/player.dart';
import 'package:portfolio/game/components/collisions/blocks.dart';

bool checkCollisions(Player player, CollisionBlock block) {
  final CustomHitbox hitbox = player.hitbox;

  final double playerX = player.position.x + hitbox.offsetX;
  final double playerY = player.position.y + hitbox.offsetY;
  final double playerWidth = hitbox.width;
  final double playerHeight = hitbox.height;

  final double blockX = block.x;
  final double blockY = block.y;
  final double blockWidth = block.width;
  final double blockHeight = block.height;

  final double fixedX = player.scale.x < 0 ? playerX - (hitbox.offsetX * 2) - playerWidth : playerX;
  final double fixedY = block.isPlatform ? playerY + playerHeight : playerY;

  return (fixedY < blockY + blockHeight &&
      fixedX < blockX + blockWidth &&
      fixedX + playerWidth > blockX &&
      fixedY + playerHeight > blockY);
}
