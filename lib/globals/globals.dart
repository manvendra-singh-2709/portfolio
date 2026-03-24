import 'dart:developer';

import '../data/api_caller.dart';
import '../models/blog.dart';
import '../models/project.dart';
import '../models/atoms.dart';

class Global {
  static late Stream<List<Project>> projectsStream;
  static Map<String, List<List<Atom>>> movieData = {};
  static List<Project> projectsList = [];
  static List<Blog> blogs = [];

  Global() {
    log("Global Invoked");
    getData();
  }

  void getData() async {
    projectsStream = ApiCaller.getProjects();
    movieData = await ProjectData.loadAllFrames();
    blogs = await ApiCaller.getBlogs();
  }
}
