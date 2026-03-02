import 'package:flutter/material.dart';
import '../widgets/glass_container.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      child: GlassContainer(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'About Me',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'I am a Research Scholar in the Department of Chemical Engineering Indian Institute of Technology (IIT) Kanpur. My field of research is computational catalysis and chemistry. Currently, I\'m exploring the force and energy dynamic of Platinum and Tin nanoclusters on amorphous silica surface using MLIPS or Machine Learned Interatomic Potentials. In the past, I have also done experimental work which you can find in the sections below. I have extensive knowledge in Flutter, Java, and Python. Prior to joining PhD, I have worked as freelancer developer during my undergraduate degree. \n\nBy the way I was the All India Rank 2 position holder in the GATE 2025 exam and the Gold Medalist of my department in NIT Jaipur. 😉',
                style: TextStyle(fontSize: 18, height: 1.5),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
