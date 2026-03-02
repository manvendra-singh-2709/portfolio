import 'package:flutter/material.dart';
import 'package:port/utils/extensions.dart';

class HoverNavItem extends StatefulWidget {
  final String title;
  final VoidCallback onTap;

  const HoverNavItem({super.key, required this.title, required this.onTap});

  @override
  State<HoverNavItem> createState() => _HoverNavItemState();
}

class _HoverNavItemState extends State<HoverNavItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click,
      child: TextButton(
        onPressed: widget.onTap,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          // Access your custom extension for font size
          style: TextStyle(
            color: Colors.white,
            fontSize: context.insets.fontSizeTitles,
            fontWeight: FontWeight.bold,
            // The "Glow" Effect using shadows
            shadows: isHovered
                ? ([
                    Shadow(
                      color: Colors.blue.withValues(alpha: 0.8),
                      blurRadius: 15,
                    ),
                    Shadow(
                      color: Colors.blue.withValues(alpha: 0.5),
                      blurRadius: 30,
                    ),
                  ])
                : [],
          ),
          child: Text(widget.title),
        ),
      ),
    );
  }
}

class GlowMenuLink extends StatefulWidget {
  final String title;
  final VoidCallback onTap;

  const GlowMenuLink({super.key, required this.title, required this.onTap});

  @override
  State<GlowMenuLink> createState() => _GlowMenuLinkState();
}

class _GlowMenuLinkState extends State<GlowMenuLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 2),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Center(
            child: Text(
              widget.title,
              style: TextStyle(
                color: _isHovered ? const Color(0xFF4FACFE) : Colors.white,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
