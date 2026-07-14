import 'dart:developer';

import 'package:flame_tiled/flame_tiled.dart';
import 'package:portfolio/game/pixel_adventure.dart';
import 'package:portfolio/game/services/game_api_caller.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  static final String _emailKey = 'email_flame_games';
  static String? email;
  static Map<String, String> levelData = <String, String>{};
  static double tileSize = 64;
  static double soundVoulme = 1.0;
  static double visionFrontRange = 160;
  static double visionBackRange = 160;
  static int numLevels = 6;
  static bool showJoystick = false;
  static bool playSound = true;
  static TiledObject? playerSpawnpoint;

  Global() {
    log("Global Invoked");
    game = PixelAdventure();
    getData();
  }

  void getData() async {
    email = await getEmail();
    projectsStream = ApiCaller.getProjects();
    movieData = await ProjectData.loadAllFrames();
    blogs = await ApiCaller.getBlogs();
  }

  static bool initialized = false;

  static Future<void> init() async {
    if (initialized) return;

    game = PixelAdventure();

    email = await getEmail();

    projectsStream = ApiCaller.getProjects();
    movieData = await ProjectData.loadAllFrames();
    blogs = await ApiCaller.getBlogs();

    if (email != null) {
      await GameApiCaller.loadOrCreateUser(email!);
    }

    initialized = true;
  }

  static Future<void> saveEmail(String email) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email);
  }

  static Future<String?> getEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  static Future<void> removeEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_emailKey);
  }

  static Future<void> loadLevelData() async {
    if (email != null) {
      await GameApiCaller.loadOrCreateUser(email!);
    }
  }
}
