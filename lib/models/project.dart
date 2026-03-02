import 'package:flutter/material.dart';

class Project {
  final int id;
  final String name;
  final String description;
  final ({IconData icon, Color color}) icon;

  Project({
    required this.name,
    required this.description,
    required this.icon,
    required this.id,
  });

  static ({IconData icon, Color color}) getIconData(String item) {
    switch (item) {
      case 'mlip':
        return (icon: Icons.science, color: const Color(0xFF4FACFE));
      case 'mFieldTrip':
        return (icon: Icons.hiking, color: Colors.greenAccent);
      case 'lib':
        return (
          icon: Icons.battery_charging_full_outlined,
          color: Colors.lightGreen,
        );
      case 'thin_film':
        return (icon: Icons.sensors, color: Colors.amberAccent);
      case 'doctors_hand':
        return (icon: Icons.medical_services, color: Colors.redAccent);
      case 'offline_classes':
        return (icon: Icons.school, color: Colors.orangeAccent);
      case 'amacle':
        return (icon: Icons.business_center, color: Colors.blueGrey);
      default:
        return (icon: Icons.question_mark, color: Colors.grey);
    }
  }
}
