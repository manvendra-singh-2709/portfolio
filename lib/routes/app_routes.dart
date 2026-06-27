import 'package:flutter/material.dart';
import 'package:portfolio/pages/add_blog_page.dart';
import 'package:portfolio/pages/blog_page.dart';
import 'package:portfolio/pages/home_page.dart';
import 'package:portfolio/pages/resume_page.dart';
import 'package:portfolio/routes/game_routes.dart';

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
    game: (_) => const GameRoute(),
  };
}