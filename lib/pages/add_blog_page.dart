import 'package:flutter/material.dart';

class BlogAddScreen extends StatefulWidget {
  const BlogAddScreen({super.key});

  @override
  State<BlogAddScreen> createState() => _BlogAddScreenState();
}

class _BlogAddScreenState extends State<BlogAddScreen> {
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
          SingleChildScrollView(child: Column(children: [
              ],
            )),
        ],
      ),
    );
  }
}
