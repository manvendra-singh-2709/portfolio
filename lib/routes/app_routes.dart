import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:portfolio/globals/globals.dart';

import '../pages/add_blog_page.dart';
import '../pages/blog_page.dart';
import '../pages/home_page.dart';
import '../pages/resume_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String blog = '/blogs';
  static const String resume = '/resume';
  static const String blogAdd = '/add_blog';
  static const String messages = '/messages_to_me';
  static const String game = '/game';

  static Map<String, WidgetBuilder> get routes => {
    home: (_) => HomePage(),
    blog: (_) => const BlogPage(),
    resume: (_) => const ResumePage(),
    blogAdd: (_) => const BlogAddScreen(),
    messages: (_) => const Placeholder(),
    game: (_) => GameWidget(game: Global.game!),
  };
}
