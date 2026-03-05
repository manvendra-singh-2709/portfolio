import 'package:flutter/material.dart';
import 'package:port/data/api_caller.dart';
import 'package:port/globals/globals.dart';
import 'package:port/sections/current_work.dart';
import 'package:port/utils/extensions.dart';
import 'package:port/widgets/glass_container.dart';
import '../models/project.dart';

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;

  late Stream<List<Project>> _projectsStream;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(() => setState(() {}));
    _projectsStream = ApiCaller.getProjects();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Column(
        children: [
          const Text(
            'Work & Innovations',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),

          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(30),
            ),
            child: TabBar(
              controller: _tabController,
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              indicatorColor: Colors.transparent,
              dividerColor: Colors.transparent,
              labelPadding: EdgeInsets.zero,
              tabs: [
                _buildGlassTab('Past Projects', 0, context),
                _buildGlassTab('Current Work', 1, context),
              ],
            ),
          ),
          const SizedBox(height: 30),

          SizedBox(
            height: 400,
            child: TabBarView(
              controller: _tabController,
              children: [
                PersistentProjectsList(stream: _projectsStream),
                CurrentWorkSimulation(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassTab(String label, int index, BuildContext context) {
    bool isSelected = _tabController.index == index;

    return Tab(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        height: 45,
        alignment: Alignment.center,
        child: isSelected
            ? GlassContainer(
                child: Center(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: context.insets.fontSizeTitles,
                    ),
                  ),
                ),
              )
            : Text(
                label,
                style: TextStyle(fontSize: context.insets.fontSizeTitles),
              ),
      ),
    );
  }
}

class PersistentProjectsList extends StatefulWidget {
  final Stream<List<Project>> stream;
  const PersistentProjectsList({super.key, required this.stream});

  @override
  State<PersistentProjectsList> createState() => _PersistentProjectsListState();
}

class _PersistentProjectsListState extends State<PersistentProjectsList>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return StreamBuilder<List<Project>>(
      stream: Global.projectsStream,
      initialData: Global.projectsList.isNotEmpty ? Global.projectsList : null,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          Global.projectsList = snapshot.data!;
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) =>
                _buildProjectCard(snapshot.data![index], context),
          );
        }

        return const Center(
          child: CircularProgressIndicator(color: Colors.white24),
        );
      },
    );
  }

  Widget _buildProjectCard(Project project, BuildContext context) {
    return Container(
      width: !context.isMobile ? 400 : 200,
      margin: const EdgeInsets.only(right: 20),
      child: GlassContainer(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(project.icon.icon, size: 40, color: project.icon.color),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      project.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                project.description,
                textAlign: TextAlign.justify,
                overflow: TextOverflow.ellipsis,
                maxLines: context.isMobile ? 7 : 10,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  _openDetailedProjectView(context, project);
                },
                child: const Text('View in Detail >'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openDetailedProjectView(BuildContext context, Project project) {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: SizedBox(
          width: context.width * 0.8,
          child: GlassContainer(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        project.icon.icon,
                        color: project.icon.color,
                        size: 40,
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            project.name,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            project.description,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
