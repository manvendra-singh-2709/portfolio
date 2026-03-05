import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:port/globals/globals.dart';
import 'package:port/models/atoms.dart';
import 'package:port/routes/app_routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'pages/not_found_page.dart';

// sb_publishable_9YVS2n7DavQwQYXLklUM5w_lQ8WVgzI
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait([
    Supabase.initialize(
      // url: 'https://kypcdyvwffcbubqrybqh.supabase.co',
      url: 'https://portfolio.jiobase.com',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt5cGNkeXZ3ZmZjYnVicXJ5YnFoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzA4ODE0MjksImV4cCI6MjA4NjQ1NzQyOX0.NVgCvDXMKMq-u2KWYiZ9AlnYXyXubRKk-fPjp94dj5M',
    ),
  ]);

  Global();

  usePathUrlStrategy();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    ProjectData.loadAllFrames();
    return MaterialApp(
      title: 'Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const NotFoundPage(),
        );
      },
      initialRoute: AppRoutes.home,
      routes: AppRoutes.routes,
      onUnknownRoute: (settings) =>
          MaterialPageRoute(builder: (context) => const NotFoundPage()),
    );
  }
}
