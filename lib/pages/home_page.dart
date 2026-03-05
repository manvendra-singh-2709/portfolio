import 'package:flutter/material.dart';
import '../sections/about_section.dart';
import '../sections/contact_section.dart';
import '../sections/footer.dart';
import '../sections/hero_section.dart';
import '../sections/navbar.dart';
import '../sections/projects_section.dart';
import '../sections/skills_section.dart';
import '../widgets/glass_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isMenuOpen = false;

  final Map<String, GlobalKey> _keys = {
    'Home': GlobalKey(),
    'Projects': GlobalKey(),
    'Contact': GlobalKey(),
  };

  void _scrollToSection(String item) {
    final key = _keys[item];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withValues(alpha: 0.2),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.purple.withValues(alpha: 0.2),
              ),
            ),
          ),

          SingleChildScrollView(
            child: Column(
              children: [
                Navbar(
                  onNavItemTap: _scrollToSection,
                  isMenuOpen: _isMenuOpen,
                  onMenuToggle: (isOpen) => setState(() => _isMenuOpen = isOpen),
                ),
                HeroSection(key: _keys['Home']),
                AboutSection(),
                SkillsSection(),
                ProjectsSection(key: _keys['Projects']),
                ContactSection(key: _keys['Contact']),
                Footer(),
              ],
            ),
          ),
          if (_isMenuOpen)
            Positioned(
              top: 100, 
              left: 20,
              right: 20,
              child: _buildMobileMenuOverlay(),
            ),
        ],
      ),
    );
  }

  Widget _buildMobileMenuOverlay() {
    return GlassContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: ['Home', 'Projects', 'Resume', 'Blogs', 'Contact'].map((item) => ListTile(
          title: Center(child: Text(item, style: const TextStyle(color: Colors.white))),
          onTap: () {
            setState(() => _isMenuOpen = false); // Close menu
            _scrollToSection(item); // Or navigate
          },
        )).toList(),
      ),
    );
  }
}
