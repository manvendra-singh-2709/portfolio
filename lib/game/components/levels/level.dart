import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/foundation.dart';
import 'package:portfolio/game/components/items/checkpoint.dart';
import 'package:portfolio/game/components/items/enemy/angry_pig.dart';
import 'package:portfolio/game/components/items/enemy/chicken.dart';
import 'package:portfolio/game/components/items/enemy/mushroom.dart';
import 'package:portfolio/game/components/items/enemy/slime.dart';
import 'package:portfolio/game/components/items/traps/fan.dart';
import 'package:portfolio/game/components/items/fruit.dart';
import 'package:portfolio/game/components/items/player.dart';
import 'package:portfolio/game/components/collisions/blocks.dart';
import 'package:portfolio/game/components/items/traps/saw.dart';
import 'package:portfolio/game/components/items/traps/spike.dart';
import 'package:portfolio/game/components/levels/background_tile.dart';
import 'package:portfolio/game/pixel_adventure.dart';
import 'package:portfolio/game/utils/enums.dart';
import 'package:portfolio/globals/globals.dart';

class Level extends World with HasGameReference<PixelAdventure> {
  late TiledComponent level;

  final String levelName;
  final Player player;

  int totalFruits = 0;
  int collectedFruits = 0;

  bool get allFruitsCollected => collectedFruits >= totalFruits;

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

  void fruitCollected() {
    collectedFruits++;
  }

  void _scrollingBackground() {
    final Layer? backgroundLayer = level.tileMap.getLayer(Layers.background.name);
    double tileSize = Global.tileSize;

    final int numTilesX = (game.size.x / tileSize).floor();
    final int numTilesY = (game.size.y / tileSize).floor();

    if (backgroundLayer != null) {
      final Object backgroundColor = backgroundLayer.properties.getProperty('BackgroundColor')!.value;

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
    final ObjectGroup? spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>(Layers.spawnPoints.name);

    if (spawnPointsLayer == null) return;

    for (final TiledObject spawnPoint in spawnPointsLayer.objects) {
      final SpawnPoints? type = SpawnPoints.values
          .where((SpawnPoints sp) => sp.name == spawnPoint.class_)
          .firstOrNull;

      switch (type) {
        case SpawnPoints.player:
          player.position = Vector2(spawnPoint.x, spawnPoint.y);
          player.initialPosition = player.position.clone();
          player.checkpointPosition = player.position.clone();
          player.setSpawnPoint(spawnPoint);
          add(player);
          break;

        case SpawnPoints.fruit:
          final Fruit fruit = Fruit(fruit: spawnPoint.name, spawnPoint: spawnPoint);
          fruit.level = this;
          totalFruits++;
          add(fruit);
          break;

        case SpawnPoints.saw:
          add(
            Saw(
              isVertical: spawnPoint.properties.getProperty('isVertical')!.value as bool,
              offNeg: spawnPoint.properties.getProperty('offNeg')!.value as double,
              offPos: spawnPoint.properties.getProperty('offPos')!.value as double,
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
              spawnPoint: spawnPoint,
            ),
          );
          break;

        case SpawnPoints.fan:
          add(
            Fan(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
              on: spawnPoint.properties.getProperty('on')!.value as bool,
              spawnPoint: spawnPoint,
            ),
          );
          break;

        case SpawnPoints.spike:
          add(Spike(spawnPoint: spawnPoint));
          break;

        case SpawnPoints.checkpoint:
          add(Checkpoint(spawnPoint: spawnPoint));
          break;

        case SpawnPoints.chicken:
          add(Chicken(spawnPoint: spawnPoint));
          break;

        case SpawnPoints.angryPig:
          add(AngryPig(spawnPoint: spawnPoint));
          break;

        case SpawnPoints.mushroom:
          add(Mushroom(spawnPoint: spawnPoint));
          break;

        case SpawnPoints.slime:
          add(Slime(spawnPoint: spawnPoint));
          break;

        case null:
          break;
      }
    }
  }

  void _addCollisions() {
    final ObjectGroup? collisionsLayer = level.tileMap.getLayer<ObjectGroup>(Layers.collisions.name);

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
