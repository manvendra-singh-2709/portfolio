import 'package:flutter/material.dart';
import '../utils/extensions.dart';
import '../widgets/glass_container.dart';
import '../utils/nav_bar_item.dart';

class Navbar extends StatefulWidget {
  final Function(String) onNavItemTap;
  final Function(bool) onMenuToggle;
  final bool isMenuOpen;

  const Navbar({
    super.key,
    required this.onNavItemTap,
    required this.onMenuToggle,
    required this.isMenuOpen,
  });

  @override
  State<Navbar> createState() => _NavbarState();
  static const _navItems = ['Home', 'Projects', 'Resume', 'Blogs', 'Contact'];
}

class _NavbarState extends State<Navbar> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _removeOverlay();
    _animationController.dispose();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _toggleMenu() {
    if (widget.isMenuOpen) {
      _animationController.reverse();
      _removeOverlay();
      widget.onMenuToggle(false);
    } else {
      _animationController.forward();
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
      widget.onMenuToggle(true);
    }
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Barrier to close menu when tapping outside
          GestureDetector(
            onTap: _toggleMenu,
            child: Container(color: Colors.transparent),
          ),
          Positioned(
            top: 100, // Distance from top
            left: 20,
            right: 20,
            child: Material(
              color: Colors.transparent,
              child: _buildMobileOverlay(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GlassContainer(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.texts.manvendrasingh,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              if (context.isDesktop)
                Row(
                  children: Navbar._navItems
                      .map((item) => _buildDesktopItem(item))
                      .toList(),
                )
              else
                _buildAnimatedMenuIcon(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedMenuIcon() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(
              0xFF4FACFE,
            ).withValues(alpha: widget.isMenuOpen ? 0.6 : 0),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: IconButton(
        onPressed: _toggleMenu,
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _animationController,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildMobileOverlay() {
    return GlassContainer(child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: Navbar._navItems
              .map(
                (item) => GlowMenuLink(
                  title: item,
                  onTap: () {
                    _toggleMenu();
                    _handleNavigation(item);
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  void _handleNavigation(String item) {
    if (item == 'Blogs') {
      Navigator.pushNamed(context, '/blogs');
    } else if (item == 'Resume') {
      Navigator.pushNamed(context, '/resume');
    } else {
      widget.onNavItemTap(item);
    }
  }

  Widget _buildDesktopItem(String item) {
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: HoverNavItem(title: item, onTap: () => _handleNavigation(item)),
    );
  }
}
