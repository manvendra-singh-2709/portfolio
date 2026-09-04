import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart';

enum NATURE { selfish, cooperative, aultristic }

enum HEALTH { healthy, sick, recovered }

enum DISEASE { none, contagious, nonContagious }

enum SOCIALIZATION { solitary, groups }

enum SHAPE { square, triangle, oval }

enum EYES { neutral, happy1, happy2, sad, angry, dot }

enum ANTENNA { straight, inward, outward }

enum ANTENNA_SHAPE { square, triangle, oval }

enum DEATH_REASON { starvation, noHitpoints, oldAge, ill }

enum GENDER { male, female, neutral }

enum FERTILITY { fertile, infertile }

enum REGION { undefined, grass, water, desert, tundra, forest }

const Map<REGION, Color> regionColors = {
  REGION.grass: Color(0xFF93d463),
  REGION.water: Color(0xFF62add1),
  REGION.desert: Color(0xFFD9B44A),
  REGION.tundra: Color(0xFFb0cff9),
  REGION.forest: Color(0xFF4f9651),
};

const Map<REGION, double> growthProbability = {
  REGION.grass: 0.55,
  REGION.forest: 0.55,
  REGION.desert: 0.65,
  REGION.tundra: 0.55,
  REGION.water: 0.45,
};

const double treeHeight = 190;
const double treeWidth = 100;

const double cactusHeight = 140;
const double cactusWidth = 80;

const double grassHeight = 50;
const double grassWidth = 50;

const double rockHeight = 50;
const double rockWidth = 50;

const double bushHeight = 50;
const double bushWidth = 50;

const double waterElementHeight = 70;
const double waterElementWidth = 70;

const double mushroomHeight = 30;
const double mushroomWidth = 30;

enum REGION_ELEMENTS {
  grass_1(grassWidth, grassHeight),
  grass_2(grassWidth, grassHeight),
  grass_3(grassWidth, grassHeight),
  grass_4(grassWidth, grassHeight),

  rock_1(rockWidth, rockHeight),
  rock_2(rockWidth, rockHeight),
  rock_3(rockWidth, rockHeight),

  bush_1(bushWidth, bushHeight),
  bush_2(bushWidth, bushHeight),
  bush_3(bushWidth, bushHeight),
  bush_4(bushWidth, bushHeight),
  bush_5(bushWidth, bushHeight),

  wave_1(24, 14),
  wave_2(24, 14),
  wave_3(24, 14),

  sand_1(20, 16),
  sand_2(20, 16),
  sand_3(20, 16),

  twig_1(18, 22),
  twig_2(18, 22),

  cattail(waterElementWidth, waterElementHeight),
  water_lily(waterElementWidth, waterElementHeight),

  mushroom_1(mushroomWidth, mushroomHeight),
  mushroom_2(mushroomWidth, mushroomHeight),
  mushroom_3(mushroomWidth, mushroomHeight),
  mushroom_4(mushroomWidth, mushroomHeight),

  pine_tree_1(treeWidth, treeHeight),
  pine_tree_2(treeWidth, treeHeight),

  autumn_tree(treeWidth, treeHeight),

  evergreen_tree_1(treeWidth, treeHeight),
  evergreen_tree_2(treeWidth, treeHeight),
  evergreen_tree_3(treeWidth, treeHeight),
  evergreen_tree_4(treeWidth, treeHeight),
  evergreen_tree_5(treeWidth, treeHeight),
  evergreen_tree_6(treeWidth, treeHeight),

  snow_tree(treeWidth, treeHeight),
  ice_grass(grassWidth, grassHeight),

  cactus_1(cactusWidth, cactusHeight),
  cactus_2(cactusWidth, cactusHeight),
  cactus_3(cactusWidth, cactusHeight),
  cactus_4(cactusWidth, cactusHeight),

  desert_plant(cactusWidth / 2, cactusHeight / 2),
  desert_grass(grassWidth, grassHeight);

  const REGION_ELEMENTS(this.width, this.height);

  final double width;
  final double height;

  Vector2 get size => Vector2(width, height);

  static Map<REGION_ELEMENTS, double> get grass => {
    grass_1: 0.1,
    grass_2: 0.1,
    grass_3: 0.1,
    grass_4: 0.1,
    rock_1: 0.05,
    rock_2: 0.05,
    rock_3: 0.05,
    bush_1: 0.06,
    bush_2: 0.06,
    bush_3: 0.06,
    bush_4: 0.06,
    bush_5: 0.06,
    evergreen_tree_1: 0.025,
    evergreen_tree_2: 0.025,
    evergreen_tree_3: 0.025,
    evergreen_tree_4: 0.025,
    evergreen_tree_5: 0.025,
    evergreen_tree_6: 0.025,
  };

  static Map<REGION_ELEMENTS, double> get desert => {
    cactus_1: 0.075,
    cactus_2: 0.075,
    cactus_3: 0.075,
    cactus_4: 0.075,
    desert_plant: 0.25,
    desert_grass: 0.45,
  };

  static Map<REGION_ELEMENTS, double> get forest => {
    mushroom_1: 0.04,
    mushroom_2: 0.04,
    mushroom_3: 0.04,
    mushroom_4: 0.04,
    pine_tree_1: 0.28,
    pine_tree_2: 0.28,
    autumn_tree: 0.28,
  };

  static Map<REGION_ELEMENTS, double> get tundra => {snow_tree: 0.25, ice_grass: 0.75};

  static Map<REGION_ELEMENTS, double> get water => {water_lily: 0.5, cattail: 0.5};

  static List<REGION_ELEMENTS> trees = [
    mushroom_1,
    mushroom_2,
    mushroom_3,
    mushroom_4,
    pine_tree_1,
    pine_tree_2,
    autumn_tree,
    evergreen_tree_1,
    evergreen_tree_2,
    evergreen_tree_3,
    evergreen_tree_4,
    evergreen_tree_5,
    evergreen_tree_6,
    snow_tree,
  ];

  static List<REGION_ELEMENTS> desertPlants = [cactus_1, cactus_2, cactus_3, cactus_4];
}

Map<REGION, Map<REGION_ELEMENTS, double>> regionWiseElementMap = {
  REGION.grass: REGION_ELEMENTS.grass,
  REGION.desert: REGION_ELEMENTS.desert,
  REGION.forest: REGION_ELEMENTS.forest,
  REGION.tundra: REGION_ELEMENTS.tundra,
  REGION.water: REGION_ELEMENTS.water,
};

T randomEnum<T extends Enum>(List<T> values, Random random) {
  return values[random.nextInt(values.length)];
}

Map<REGION_ELEMENTS, String> regionElementAssets() {
  return {for (final REGION_ELEMENTS element in REGION_ELEMENTS.values) element: '${element.name}.png'};
}
