import 'package:flutter/material.dart';

class ArrowButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const ArrowButton({super.key, required this.icon, required this.onPressed});

  @override
  State<ArrowButton> createState() => _ArrowButtonState();
}

class _ArrowButtonState extends State<ArrowButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) {
        setState(() {
          _hovered = false;
          _pressed = false;
        });
      },
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) {
          setState(() => _pressed = false);
          widget.onPressed();
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(2),
          transform: Matrix4.identity()..scale(_pressed ? 0.9 : (_hovered ? 1.08 : 1.0)),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: _hovered
                ? [BoxShadow(color: Colors.blue.withValues(alpha: 0.2), blurRadius: 0.5, spreadRadius: 0.25)]
                : null,
          ),
          child: Icon(widget.icon, size: 96, color: Colors.white),
        ),
      ),
    );
  }
}
