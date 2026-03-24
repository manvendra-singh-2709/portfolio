import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../utils/constants.dart';
import '../utils/sizes.dart';
import '../utils/helpers.dart';

class Footer extends StatefulWidget {
  const Footer({super.key});

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  Map<String, String> links = IconFromImage.links;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _socialIcon(
                IconFromImage.linkedin,
                links[IconFromImage.linkedin]!,
              ),
              const SizedBox(width: 40),
              _socialIcon(IconFromImage.github, links[IconFromImage.github]!),
              const SizedBox(width: 40),
              _socialIcon(
                IconFromImage.instagram,
                links[IconFromImage.instagram]!,
              ),
              const SizedBox(width: 40),
              _socialIcon(IconFromImage.gmail, links[IconFromImage.gmail]!),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                IconFromImage.flutter,
                width: Insets.xxl,
                height: Insets.xxl,
              ),
              Gap(Insets.lg),
              Text('Built with Flutter.', style: TextStyle(fontSize: 20)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _socialIcon(String image, String link) {
    return GestureDetector(
      onTap: () {
        openUrl(link);
      },
      child: Image.asset(
        image,
        width: Insets.xxxl * 0.7,
        height: Insets.xxxl * 0.7,
      ),
    );
  }
}
