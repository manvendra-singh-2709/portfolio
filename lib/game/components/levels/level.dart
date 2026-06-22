import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/foundation.dart';
import 'package:portfolio/game/components/items/checkpoint.dart';
import 'package:portfolio/game/components/items/fruit.dart';
import 'package:portfolio/game/components/items/player.dart';
import 'package:portfolio/game/components/collisions/blocks.dart';
import 'package:portfolio/game/components/items/saw.dart';
import 'package:portfolio/game/components/levels/background_tile.dart';
import 'package:portfolio/game/pixel_adventure.dart';
import 'package:portfolio/game/utils/enums.dart';
import 'package:portfolio/globals/globals.dart';

class Level extends World with HasGameReference<PixelAdventure> {
  late TiledComponent level;

  final String levelName;
  final Player player;

  List<CollisionBlock> collisionBlocks = [];

  Level({required this.levelName, required this.player});

  @override
  Future<void> onLoad() async {
    level = await TiledComponent.load(
      'Level-$levelName.tmx',
      Vector2.all(16),
      prefix: kReleaseMode ? 'assets/game/tiles/' : 'game/tiles/',
    );

    add(level);

    _scrollingBackground();
    _spawningObjects();
    _addCollisions();

    player.collisionBlocks = collisionBlocks;

    return super.onLoad();
  }

  void _scrollingBackground() {
    final Layer? backgroundLayer = level.tileMap.getLayer('Background');
    double tileSize = Global.tileSize;

    final int numTilesX = (game.size.x / tileSize).floor();
    final int numTilesY = (game.size.y / tileSize).floor();

    if (backgroundLayer != null) {
      final Object backgroundColor = backgroundLayer.properties
          .getProperty('BackgroundColor')!
          .value;

      for (double x = 0; x < numTilesX; x++) {
        for (double y = 0; y < game.size.y / numTilesY; y++) {
          final BackgroundTile backgroundTile = BackgroundTile(
            color: backgroundColor.toString(),
            position: Vector2(x * tileSize - tileSize, y * tileSize - tileSize),
          );
          add(backgroundTile);
        }
      }
    }
  }

  void _spawningObjects() {
    final ObjectGroup? spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>(
      Layers.spawnPoints.name,
    );

    if (spawnPointsLayer != null) {
      for (final TiledObject spawnPoint in spawnPointsLayer.objects) {
        switch (spawnPoint.class_) {
          case 'Player':
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            player.initialPosition = player.position.clone();
            player.checkpointPosition = player.position.clone();
            add(player);
            break;
          case 'Fruit':
            final Fruit fruit = Fruit(
              fruit: spawnPoint.name,
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(fruit);
            break;
          case 'Saw':
            final Saw saw = Saw(
              isVertical: spawnPoint.properties.getProperty('isVertical')!.value as bool,
              offNeg: spawnPoint.properties.getProperty('offNeg')!.value as double,
              offPos: spawnPoint.properties.getProperty('offPos')!.value as double,
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(saw);
            break;
          case 'Checkpoint':
            final Checkpoint checkpoint = Checkpoint(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(checkpoint);
          default:
        }
      }
    }
  }

  void _addCollisions() {
    final ObjectGroup? collisionsLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');

    if (collisionsLayer != null) {
      for (final TiledObject collisions in collisionsLayer.objects) {
        switch (collisions.class_) {
          case 'Platform':
            final CollisionBlock platform = CollisionBlock(
              position: Vector2(collisions.x, collisions.y),
              size: Vector2(collisions.width, collisions.height),
              isPlatform: true,
            );
            collisionBlocks.add(platform);
            add(platform);
            break;
          default:
            final CollisionBlock block = CollisionBlock(
              position: Vector2(collisions.x, collisions.y),
              size: Vector2(collisions.width, collisions.height),
            );
            collisionBlocks.add(block);
            add(block);
        }
      }
    }
  }
}
