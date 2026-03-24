import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'globals/globals.dart';
import 'models/atoms.dart';
import 'pages/not_found_page.dart';
import 'routes/app_routes.dart';

// sb_publishable_9YVS2n7DavQwQYXLklUM5w_lQ8WVgzI
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait([
    Supabase.initialize(
      url: 'https://kypcdyvwffcbubqrybqh.supabase.co',
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
  void initState() {
    super.initState();
    ProjectData.loadAllFrames();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portfolio',
      debugShowCheckedModeBanner: false,
      scrollBehavior: MyCustomScrollBehavior(), 
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.home,
      routes: AppRoutes.routes,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const NotFoundPage(),
        );
      },
      onUnknownRoute: (RouteSettings settings) => MaterialPageRoute(
        builder: (BuildContext context) => const NotFoundPage(),
      ),
    );
  }
}

// Ensure your ScrollBehavior is defined outside the class
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}