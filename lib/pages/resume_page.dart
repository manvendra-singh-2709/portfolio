import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/helpers.dart';
import '../widgets/glass_container.dart';

class ResumePage extends StatefulWidget {
  const ResumePage({super.key});

  @override
  State<ResumePage> createState() => _ResumePageState();
}

class _ResumePageState extends State<ResumePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withValues(alpha: 0.05),
              ),
            ),
          ),

          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white70,
                              ),
                            ),
                            IconButton(
                              onPressed: () => openUrl(
                                "cv.pdf",
                              ), 
                              tooltip: "View Full CV",
                              icon: const Icon(
                                Icons.download,
                                color: Color(
                                  0xFF4FACFE,
                                ), 
                                size: 28,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Manvendra Singh",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        _buildLinksSection(),
                        const Text(
                          "Research Scholar @ IIT Kanpur |AIR 2- GATE 2025 (CH) | Gold Medalist- NIT Jaipur 2025 | MITACS-GRI 2024 🇨🇦 | Chemical Engineering",
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF4FACFE),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildObjectiveSection(),
                      ],
                    ),
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildSectionTitle("Academic Background"),
                      _buildGlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Ph.D in Chemical Engineering",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text("IIT Kanpur | 2025 - Present"),
                            const Text(
                              "Current GPA: 10/10",
                              style: TextStyle(
                                color: Color(0xFF4FACFE),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildGlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "B.Tech. in Chemical Engineering",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text("MNIT Jaipur | 2021 - 2025"),
                            const Text(
                              "GPA: 9.88/10",
                              style: TextStyle(
                                color: Color(0xFF4FACFE),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      _buildSectionTitle("Research Experience"),
                      _buildResearchItem(
                        "Recovery from Li-ion Batteries",
                        "08/2024 - 04/2025",
                        "Focused on recovering Manganese oxide from spent Li-ion batteries to enhance activated carbon electrodes (derived from coconut shells) for water desalination. Achieved a peak salt removal capacity of 18.74 mg/g using the Capacitive Deionization (CDI) process.",
                      ),
                      _buildResearchItem(
                        "Conductive Biopolymer Sensors",
                        "11/2024 - 04/2025",
                        "Developed starch-based films doped with AgNPs (synthesized via green microwave methods) that are 100x more conductive than neat films. These were characterized and successfully tested as wearable sensors for tactile and writing detection.",
                      ),
                      _buildResearchItem(
                        "Biodegradable Packaging Development",
                        "09/2023 - 02/2024",
                        "Developed and characterized corn-starch-based polymer films for sustainable packaging. Performed rigorous mechanical and material property testing to evaluate the performance of these biodegradable alternatives to traditional plastics.",
                      ),

                      _buildSectionTitle("Internships"),
                      _buildResearchItem(
                        "MITACS GRI - Athabasca University, Alberta, Canada",
                        "05/2024 - 08/2024",
                        "Architected and developed the mFieldtrip mobile app from scratch using Dart/Flutter and QGIS integration. Additionally optimized the 'Doctors’ Hand' application to improve functional features and user experience.",
                      ),
                      _buildResearchItem(
                        "Amacle",
                        "05/2023 - 08/2023",
                        "Built the Client and the Developer management twin aps for the startup itself and the Offline Classes app for a client of the startup.",
                      ),

                      _buildSectionTitle("Conferences & Presentations"),
                      _buildConferenceItem(
                        "InDACON International Conference 2025",
                        "HBTU Kanpur | Feb 2025",
                        "Presented: 'Polymer Thin Films Synthesis from Starch with Silver Nanoparticles to Enhance Electrical Properties.' Focused on green synthesis and tactile detection applications.", //
                      ),

                      _buildSectionTitle("Leadership & Volunteering"),
                      _buildVolunteerItem(
                        "General Secretary, The Mavericks",
                        "MNIT Jaipur | 2023 - 2024",
                        "Managed overall club operations and acted as the official representative for the organization at various events.",
                        Icons.groups,
                      ),
                      _buildVolunteerItem(
                        "Writer, The Mavericks",
                        "MNIT Jaipur | 2022 - 2023",
                        "Authored creative content including short stories, articles, and poetry for social media engagement.",
                        Icons.edit_note,
                      ),

                      _buildSectionTitle("Technical Skills"),
                      _buildGlassCard(
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _buildSkillChip("MATLAB"),
                            _buildSkillChip("Aspen HYSYS"),
                            _buildSkillChip("Machine Learning"),
                            _buildSkillChip("Dart/Flutter"),
                            _buildSkillChip("Python"),
                            _buildSkillChip("Java"),
                            _buildSkillChip("Julia"),
                            _buildSkillChip("App Development"),
                          ],
                        ),
                      ),

                      _buildSectionTitle("Key Achievements"),
                      _buildGlassCard(
                        child: Column(
                          children: [
                            _buildAchievementRow(
                              FontAwesomeIcons.medal,
                              "Gold Medalist",
                              "Batch 2021-2025",
                            ),
                            _buildAchievementRow(
                              Icons.emoji_events,
                              "All India Rank 2",
                              "GATE Chemical Engineering 2025",
                            ),
                            _buildAchievementRow(
                              Icons.school,
                              "99.5% Aggregate",
                              "ISC All-India Second Topper (2021)",
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 50),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinksSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Wrap(
        spacing: 25,
        runSpacing: 10,
        children: [
          _buildTextLink(
            "Email: ",
            "12a.manvendrasingh@gmail.com",
            () => openUrl("12a.manvendrasingh@gmail.com"),
          ),
          _buildTextLink(
            "LinkedIn: ",
            "manvendra-singh-08a233222",
            () => openUrl(
              "https://www.linkedin.com/in/manvendra-singh-08a233222/",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextLink(String label, String linkText, VoidCallback? onTap) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 14),
        children: [
          TextSpan(
            text: label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: GestureDetector(
              onTap: onTap,
              child: Text(
                linkText,
                style: TextStyle(
                  color: const Color(0xFF4FACFE),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildObjectiveSection() {
    return Text(
      "I aim to advance the frontiers of computational materials science by integrating Machine Learning Interatomic Potentials (MLIP) and global optimization techniques into robust Molecular Dynamics (MD) workflows. I aim to design and simulate next-generation materials—focusing on catalytic systems to drive scalable, resource-efficient technologies for environmental sustainability and reaction dynamics.",
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.7),
        fontSize: 16,
        height: 1.5,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 14,
          letterSpacing: 2,
          fontWeight: FontWeight.bold,
          color: Colors.white38,
        ),
      ),
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: GlassContainer(
        child: Padding(padding: const EdgeInsets.all(20), child: child),
      ),
    );
  }

  Widget _buildResearchItem(String title, String date, String desc) {
    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Text(
                date,
                style: const TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            desc,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConferenceItem(String title, String location, String desc) {
    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 5),
          Text(
            location,
            style: const TextStyle(
              color: Color(0xFF4FACFE),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            desc,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVolunteerItem(
    String title,
    String date,
    String desc,
    IconData icon,
  ) {
    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF4FACFE), size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            date,
            style: const TextStyle(color: Colors.white38, fontSize: 12),
          ),
          const SizedBox(height: 12),
          Text(
            desc,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
        color: Colors.white.withValues(alpha: 0.05),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }

  Widget _buildAchievementRow(IconData icon, String title, String sub) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF4FACFE), size: 24),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(
                sub,
                style: const TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
