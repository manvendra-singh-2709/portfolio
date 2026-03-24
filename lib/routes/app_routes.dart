import 'package:flutter/material.dart';
import '../pages/add_blog_page.dart';
import '../pages/blog_page.dart';
import '../pages/home_page.dart';
import '../pages/resume_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String blog = '/blogs';
  static const String resume = '/resume';
  static const String blogAdd = '/add_blog';

  static Map<String, WidgetBuilder> get routes => {
    home: (_) => HomePage(),
    blog: (_) => const BlogPage(),
    resume: (_) => const ResumePage(),
    blogAdd: (_) => const BlogAddScreen(),
  };
}
