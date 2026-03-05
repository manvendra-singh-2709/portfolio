import 'package:flutter/material.dart';
import 'package:port/utils/constants.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      child: Column(
        children: [
          MouseRegion(
            onEnter: (_) => setState(() => isHovered = true),
            onExit: (_) => setState(() => isHovered = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: isHovered
                    ? [
                        BoxShadow(
                          color: Colors.blue.withValues(alpha: 0.6),
                          blurRadius: 30,
                          spreadRadius: 10,
                        )
                      ]
                    : [],
              ),
              child: const CircleAvatar(
                radius: 100,
                backgroundImage: AssetImage(Images.pf2),
              ),
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'Hi There!',
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

