import 'dart:developer';

import 'package:portfolio/game/pixel_adventure.dart';

import '../data/api_caller.dart';
import '../models/blog.dart';
import '../models/project.dart';
import '../models/atoms.dart';

class Global {
  static late Stream<List<Project>> projectsStream;
  static Map<String, List<List<Atom>>> movieData = {};
  static List<Project> projectsList = [];
  static List<Blog> blogs = [];
  static PixelAdventure? game;
  static String imagesPrefix = 'assets/game/images/';
  static String audioPrefix = 'assets/game/audio/';
  static String? email;
  static Map<String, String> levelData = <String, String>{};
  static double tileSize = 64;
  static double soundVoulme = 1.0;
  static double visionFrontRange = 160;
  static double visionBackRange = 160;
  static int numLevels = 4;
  static bool showJoystick = false;
  static bool playSound = true;

  Global() {
    log("Global Invoked");
    game = PixelAdventure();
    getData();
  }

  void getData() async {
    projectsStream = ApiCaller.getProjects();
    movieData = await ProjectData.loadAllFrames();
    blogs = await ApiCaller.getBlogs();
  }
}
