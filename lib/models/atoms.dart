import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:port/globals/globals.dart';

class Atom {
  final String species;
  final double x, y, z;
  Atom({
    required this.species,
    required this.x,
    required this.y,
    required this.z,
  });
}

class ProjectData {
  static Map<String, List<List<Atom>>> movieData = {};

  static Future<List<String>> loadAnimationAssets() async {
    final AssetManifest manifest = await AssetManifest.loadFromAssetBundle(
      rootBundle,
    );

    String animationPath = '';

    if (kDebugMode) {
      animationPath = 'assets/animations/';
      log("Running in DEBUG mode");
    } else {
      animationPath = 'assets/assets/animations/';
      log("Running in PRODUCTION mode");
    }

    return manifest
        .listAssets()
        .where(
          (String asset) =>
              asset.startsWith(animationPath) && asset.endsWith('.csv'),
        )
        .toList();
  }

  static void readAssetList() async {
    final assetManifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    log("jhhhhh");
    Global.data = assetManifest.listAssets();
  }

  static Future<Map<String, List<List<Atom>>>> loadAllFrames() async {
    List<String> paths = await ProjectData.loadAnimationAssets();
    readAssetList();
    // paths = Animations.loadPaths();
    try {
      Map<String, List<List<Atom>>> allMovies = {};

      for (String path in paths) {
        final String content = await rootBundle.loadString(path);
        final List<String> lines = content.split('\n');

        if (lines.length < 3) continue;

        String projectTitle = lines[0].trim();
        List<List<Atom>> tempFrames = [];
        List<Atom> currentFrameAtoms = [];
        int? lastFrameIdx;

        for (int i = 2; i < lines.length; i++) {
          String line = lines[i].trim();
          if (line.isEmpty) continue;

          final List<String> parts = line.split(',');
          if (parts.length < 5) continue;

          int? frameIdx = int.tryParse(parts[0]);
          if (frameIdx == null) continue;

          if (lastFrameIdx != null && frameIdx != lastFrameIdx) {
            tempFrames.add(List<Atom>.from(currentFrameAtoms));
            currentFrameAtoms.clear();
          }

          currentFrameAtoms.add(
            Atom(
              species: parts[1],
              x: double.parse(parts[2]),
              y: double.parse(parts[3]),
              z: double.parse(parts[4]),
            ),
          );
          lastFrameIdx = frameIdx;
        }

        if (currentFrameAtoms.isNotEmpty) {
          tempFrames.add(List<Atom>.from(currentFrameAtoms));
        }

        allMovies[projectTitle] = tempFrames;
      }

      movieData = allMovies;
      return allMovies;
    } catch (e) {
      log("Critical Error in loadAllFrames: $e");
      return {};
    }
  }
}
