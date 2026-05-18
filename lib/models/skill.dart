import 'package:dev_icons/dev_icons.dart';
import 'package:flutter/material.dart';
import 'package:simple_icons/simple_icons.dart';

class Skill {
  final String name;
  final IconData icon;
  final Color color;

  Skill({required this.name, required this.icon, required this.color});

  static final List<Skill> skills = [
    Skill(
      name: 'Flutter',
      icon: SimpleIcons.flutter,
      color: SimpleIconColors.librariesdotio,
    ),
    Skill(
      name: 'Java',
      icon: DevIcons.javaPlain,
      color: const Color.fromARGB(255, 233, 72, 27),
    ),
    Skill(
      name: 'JS',
      icon: SimpleIcons.javascript,
      color: SimpleIconColors.javascript,
    ),
    Skill(
      name: 'Python',
      icon: SimpleIcons.python,
      color: SimpleIconColors.python,
    ),
    Skill(name: 'Dart', icon: SimpleIcons.dart, color: SimpleIconColors.dart),
    Skill(
      name: 'Firebase',
      icon: SimpleIcons.firebase,
      color: SimpleIconColors.firebase,
    ),
    Skill(
      name: 'Julia',
      icon: SimpleIcons.julia,
      color: SimpleIconColors.julia,
    ),
    Skill(name: 'QGIS', icon: SimpleIcons.qgis, color: SimpleIconColors.qgis),
    Skill(name: 'Git', icon: SimpleIcons.git, color: SimpleIconColors.git),
    Skill(
      name: 'Spring',
      icon: SimpleIcons.spring,
      color: Colors.lightGreen,
    ),
    Skill(
      name: 'PyTorch',
      icon: SimpleIcons.pytorch,
      color: SimpleIconColors.pytorch,
    ),
    Skill(
      name: 'GraphQL',
      icon: SimpleIcons.graphql,
      color: SimpleIconColors.graphql,
    ),
    Skill(
      name: 'Supabase',
      icon: SimpleIcons.supabase,
      color: SimpleIconColors.supabase,
    ),
    Skill(
      name: 'Android',
      icon: SimpleIcons.android,
      color: SimpleIconColors.android,
    ),
  ];
}

