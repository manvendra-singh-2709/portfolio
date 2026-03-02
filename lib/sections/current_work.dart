import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:port/utils/extensions.dart';
import 'package:vector_math/vector_math_64.dart' as vmath;
import 'package:port/globals/globals.dart';
import '../models/atoms.dart';

class CurrentWorkSimulation extends StatefulWidget {
  const CurrentWorkSimulation({super.key});

  @override
  State<CurrentWorkSimulation> createState() => _CurrentWorkSimulationState();
}

class _CurrentWorkSimulationState extends State<CurrentWorkSimulation>
    with SingleTickerProviderStateMixin {
  final vmath.Vector3 _rotation = vmath.Vector3(10.97, -2.14, 7.0);

  late AnimationController _controller;
  int _currentFrameIndex = 0;
  bool _isForward = true;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    )..addListener(_updateFrame);
  }

  void _updateFrame() {
    if (!_isPlaying || Global.movieData.isEmpty) return;

    setState(() {
      if (_isForward) {
        if (_currentFrameIndex < Global.movieData.length - 1) {
          _currentFrameIndex++;
        } else {
          _isForward = false; // Reverse at the end
          _currentFrameIndex--;
        }
      } else {
        if (_currentFrameIndex > 0) {
          _currentFrameIndex--;
        } else {
          _isForward = true; // Forward at the start
          _currentFrameIndex++;
        }
      }
    });
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Atom> atoms = Global.movieData.isNotEmpty
        ? Global.movieData[_currentFrameIndex]
        : [];

    if (atoms.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white24),
      );
    }

    return Center(
      child: SizedBox(
        width: context.width * 0.95,
        child: LiquidGlass.withOwnLayer(
          fake: true,
          settings: const LiquidGlassSettings(
            thickness: 5,
            blur: 25,
            glassColor: Color(0x0DFFFFFF),
          ),
          shape: LiquidRoundedSuperellipse(borderRadius: 25),
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                _rotation.y += details.delta.dx * 0.01;
                _rotation.x -= details.delta.dy * 0.01;

                debugPrint(
                  'Rotation -> X: ${_rotation.x.toStringAsFixed(2)}, '
                  'Y: ${_rotation.y.toStringAsFixed(2)}, '
                  'Z: ${_rotation.z.toStringAsFixed(2)}',
                );
              });
            },
            child: Container(
              width: double.infinity,
              height: 400,
              color: Colors.transparent,
              margin: const EdgeInsets.symmetric(horizontal: 40),
              child: CustomPaint(
                painter: AtomFramePainter(atoms: atoms, rotation: _rotation),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: IconButton(
                          onPressed: _togglePlay,
                          icon: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white70,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "Pt Relaxation on amorphous Silica",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      child: Text(
                        "Frame: $_currentFrameIndex / ${Global.movieData.length - 1}",
                        style: const TextStyle(
                          color: Colors.white24,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
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

    // Sort by depth (Painters Algorithm) so front atoms cover back atoms
    projected.sort((a, b) => b.depth.compareTo(a.depth));

    for (var p in projected) {
      canvas.drawCircle(p.pos, p.radius, Paint()..color = p.color);
      if (p.radius > 4) {
        // Add glow to Platinum
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
