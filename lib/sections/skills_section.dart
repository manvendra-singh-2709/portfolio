import 'package:flutter/material.dart';
import 'package:port/models/skill.dart';
import '../widgets/glass_container.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Skill> skills = Skill.skills;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      child: Column(
        children: [
          const Text(
            'My Skills',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: skills
                .map(
                  (skill) => GlassContainer(
                    borderRadius: 15,
                    child: Container(
                      width: 120,
                      height: 120,
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(skill.icon, size: 40, color: skill.color),
                          const SizedBox(height: 10),
                          Text(
                            skill.name,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
