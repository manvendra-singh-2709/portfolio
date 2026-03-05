import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:port/utils/extensions.dart';
import 'package:vector_math/vector_math_64.dart' as vmath;
import 'package:port/globals/globals.dart';
import '../models/atoms.dart';
import '../widgets/glass_container.dart';

class CurrentWorkSimulation extends StatefulWidget {
  const CurrentWorkSimulation({super.key});

  @override
  State<CurrentWorkSimulation> createState() => _CurrentWorkSimulationState();
}

class _CurrentWorkSimulationState extends State<CurrentWorkSimulation>
    with SingleTickerProviderStateMixin {
  final vmath.Vector3 _rotation = vmath.Vector3(10.97, -2.14, 7.0);
  final TextEditingController _frameController = TextEditingController();

  late AnimationController _controller;
  int _currentFrameIndex = 0;
  int _currentMovieIndex = 0;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _setupController();
  }

  void _setupController() {
    int frameCount = _currentMovieFrames.length;

    int totalDurationMs;

    if (frameCount < 200) {
      totalDurationMs = 5000; // 10 seconds
    } else if (frameCount <= 1000) {
      totalDurationMs = 20000; // 20 seconds
    } else {
      totalDurationMs = 30000; // 30 seconds
    }

    _controller.duration = Duration(milliseconds: totalDurationMs);

    _controller.removeListener(_updateFrame);
    _controller.addListener(_updateFrame);

    if (_isPlaying) _controller.repeat();
  }

  String get _currentMovieTitle =>
      Global.movieData.keys.elementAt(_currentMovieIndex);
  List<List<Atom>> get _currentMovieFrames =>
      Global.movieData[_currentMovieTitle] ?? [];

  void _updateFrame() {
    if (!_isPlaying || _currentMovieFrames.isEmpty) return;

    int frameCount = _currentMovieFrames.length;

    setState(() {
      _currentFrameIndex = (_controller.value * (frameCount - 1)).round();
    });
  }

  void _navigateMovie(bool next) {
    setState(() {
      int totalMovies = Global.movieData.length;
      _currentMovieIndex = next
          ? (_currentMovieIndex + 1) % totalMovies
          : (_currentMovieIndex - 1 + totalMovies) % totalMovies;
      _currentFrameIndex = 0;
      _setupController();
    });
  }

  void _stepFrame(int delta) {
    setState(() {
      int next = _currentFrameIndex + delta;
      if (next >= 0 && next < _currentMovieFrames.length) {
        _currentFrameIndex = next;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (Global.movieData.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white24),
      );
    }

    final atoms = _currentMovieFrames.isNotEmpty
        ? _currentMovieFrames[_currentFrameIndex]
        : <Atom>[];
    final int maxFrame = _currentMovieFrames.length - 1;

    return Center(
      child: SizedBox(
        width: context.width * 0.95,
        child: GlassContainer(
          child: Column(
            children: [
              // Simulation Canvas
              GestureDetector(
                onPanUpdate: (d) => setState(() {
                  _rotation.y += d.delta.dx * 0.01;
                  _rotation.x -= d.delta.dy * 0.01;
                }),
                child: Container(
                  height: 250,
                  width: double.infinity,
                  color: Colors.transparent,
                  child: CustomPaint(
                    painter: AtomFramePainter(
                      atoms: atoms,
                      rotation: _rotation,
                    ),
                    child: Stack(children: [_buildHeader()]),
                  ),
                ),
              ),

              // Video Controls Bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildProgressBar(maxFrame),
                        _buildProjectNavigation(),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildPlaybackControls(maxFrame),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Positioned(
      top: 15,
      left: 20,
      child: Text(
        _currentMovieTitle,
        style: TextStyle(
          fontSize: context.isMobile ? 16 : 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildProjectNavigation() {
    return Positioned(
      top: 15,
      right: 15,
      child: Row(
        children: [
          _navButton(
            Icons.skip_previous,
            () => _navigateMovie(false),
            forward: false,
          ),
          const SizedBox(width: 8),
          _navButton(
            Icons.skip_next,
            () => _navigateMovie(true),
            forward: true,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(int maxFrame) {
    return Row(
      children: [
        Text(
          "$_currentFrameIndex",
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        SizedBox(
          width: context.width * 0.3,
          child: Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 2,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              ),
              child: Slider(
                value: _currentFrameIndex.toDouble(),
                min: 0,
                max: maxFrame.toDouble(),
                onChanged: (v) => setState(() {
                  _currentFrameIndex = v.toInt();
                  if (_isPlaying) _togglePlay(); // Pause while scrubbing
                }),
              ),
            ),
          ),
        ),
        Text(
          "$maxFrame",
          style: const TextStyle(color: Colors.white24, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildPlaybackControls(int maxFrame) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Frame Steppers
        Row(
          children: [
            _navButton(
              Icons.chevron_left,
              () => _stepFrame(-1),
              nextFrame: false,
            ),
            const SizedBox(width: 10),
            IconButton(
              onPressed: _togglePlay,
              icon: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(width: 10),
            _navButton(
              Icons.chevron_right,
              () => _stepFrame(1),
              nextFrame: true,
            ),
          ],
        ),

        // Jump to Frame Input
        Row(
          children: [
            const Text(
              "Go to frame: ",
              style: TextStyle(color: Colors.white38, fontSize: 12),
            ),
            SizedBox(
              width: 50,
              height: 30,
              child: TextField(
                controller: _frameController,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                ),
                onSubmitted: (val) {
                  int? target = int.tryParse(val);
                  if (target != null && target >= 0 && target <= maxFrame) {
                    setState(() => _currentFrameIndex = target);
                  }
                  _frameController.clear();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
      _isPlaying ? _controller.repeat() : _controller.stop();
    });
  }

  Widget _navButton(
    IconData icon,
    VoidCallback onPressed, {
    bool? forward,
    bool? nextFrame,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.05),
      ),
      child: IconButton(
        tooltip: forward == null
            ? (nextFrame == null
                  ? null
                  : (nextFrame ? "Next Frame" : "Previous Frame"))
            : (forward ? "Next" : "Previous"),
        onPressed: onPressed,
        iconSize: 20,
        icon: Icon(icon, color: Colors.white70),
      ),
    );
  }
}

class AtomFramePainter extends CustomPainter {
  final List<Atom> atoms;
  final vmath.Vector3 rotation;

  AtomFramePainter({required this.atoms, required this.rotation});

  @override
  void paint(Canvas canvas, Size size) {
    final double scale = size.height / 45;
    final Offset screenCenter = Offset(size.width / 2, size.height / 2);
    final vmath.Vector3 latticeCenter = vmath.Vector3(10.7, 10.7, 16.85);

    final List<({Offset pos, Color color, double radius, double depth})>
    projected = [];

    for (var atom in atoms) {
      double x = atom.x - latticeCenter.x;
      double y = atom.y - latticeCenter.y;
      double z = atom.z - latticeCenter.z;

      // X-Axis Rotation (Pitch)
      double cosX = math.cos(rotation.x);
      double sinX = math.sin(rotation.x);
      double y1 = y * cosX - z * sinX;
      double z1 = y * sinX + z * cosX;

      // Y-Axis Rotation (Yaw)
      double cosY = math.cos(rotation.y);
      double sinY = math.sin(rotation.y);
      double x2 = x * cosY + z1 * sinY;
      double z2 = -x * sinY + z1 * cosY;

      // Perspective Projection
      double perspective = 400 / (400 + z2 * scale);
      Offset screenPos = Offset(
        screenCenter.dx + x2 * scale * perspective,
        screenCenter.dy - y1 * scale * perspective,
      );

      Color color;
      double radius;
      switch (atom.species) {
        case 'Pt':
          color = const Color(0xFFE5E4E2);
          radius = 8.3;
          break;
        case 'Si':
          color = const Color(0xFF4FACFE);
          radius = 5.0;
          break;
        case 'O':
          color = Colors.redAccent;
          radius = 3.0;
          break;
        default:
          color = Colors.white60;
          radius = 2.0;
      }

      projected.add((
        pos: screenPos,
        color: color,
        radius: radius * perspective,
        depth: z2,
      ));
    }

    projected.sort((a, b) => b.depth.compareTo(a.depth));

    for (var p in projected) {
      canvas.drawCircle(p.pos, p.radius, Paint()..color = p.color);
      if (p.radius > 4) {
        canvas.drawCircle(
          p.pos,
          p.radius * 1.5,
          Paint()
            ..color = p.color.withValues(alpha: 0.1)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant AtomFramePainter oldDelegate) => true;
}
