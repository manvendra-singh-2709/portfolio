import 'package:flutter/services.dart' show rootBundle;
import 'package:port/utils/constants.dart';

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
  static List<List<Atom>> movieData = [];

  static Future<List<List<Atom>>> loadAllFrames() async {
    try {
      final String content = await rootBundle.loadString(Animations.xyzMovie);
      final List<String> lines = content.split('\n');

      List<List<Atom>> tempFrames = [];
      List<Atom> currentFrameAtoms = [];
      int? lastFrameIdx;

      for (int i = 1; i < lines.length; i++) {
        String line = lines[i].trim();
        if (line.isEmpty) continue;

        final List<String> parts = line.split(',');
        if (parts.length < 5) continue;

        final int frameIdx = int.parse(parts[0]);

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

      movieData = tempFrames;
      return tempFrames;
    } catch (e) {
      throw Exception("Error loading simulation frames: $e");
    }
  }
}
