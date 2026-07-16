import 'dart:async';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pixel_ui/pixel_ui.dart';
import 'package:portfolio/game/pixel_adventure.dart';
import 'package:portfolio/game/services/game_api_caller.dart';
import 'package:portfolio/game/utils/arrow_button.dart';
import 'package:portfolio/game/utils/enums.dart';
import 'package:portfolio/globals/globals.dart';

class GameMainMenu extends StatefulWidget {
  final PixelAdventure game;
  final VoidCallback onPlayPressed;

  const GameMainMenu({super.key, required this.game, required this.onPlayPressed});

  @override
  State<GameMainMenu> createState() => _GameMainMenuState();
}

class _GameMainMenuState extends State<GameMainMenu> {
  int actorIndex = 0;
  PlayerState state = PlayerState.idle;
  Key previewKey = UniqueKey();
  int swipeDirection = 1;
  bool _hovered = false;

  final RegExp emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  final TextEditingController emailController = TextEditingController();
  String? emailError;
  bool loadingEmail = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Actor get actor => Actor.values[actorIndex];

  bool isValidEmail(String email) {
    return emailRegex.hasMatch(email);
  }

  @override
  void initState() {
    super.initState();

    Global.init().then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> submitEmail() async {
    final String email = emailController.text.trim();

    if (!isValidEmail(email)) {
      setState(() {
        emailError = 'Invalid email';
      });
      return;
    }

    setState(() {
      loadingEmail = true;
      emailError = null;
    });

    try {
      await Global.saveEmail(email);
      await GameApiCaller.loadOrCreateUser(email);
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        emailError = 'Unable to load user data';
      });
    } finally {
      if (mounted) {
        setState(() {
          loadingEmail = false;
        });
      }
    }
  }

  void changeActor(int delta) {
    setState(() {
      swipeDirection = delta;

      actorIndex = (actorIndex + delta) % Actor.values.length;
      if (actorIndex < 0) {
        actorIndex = Actor.values.length - 1;
      }

      state = PlayerState.idle;
      previewKey = UniqueKey();
    });

    widget.game.selectedActor = actor;
  }

  void playState(PlayerState newState) {
    setState(() {
      state = newState;
      previewKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    widget.game.selectedActor = actor;

    return Material(
      color: const Color(0xFF211F30),
      child: Stack(
        children: <Widget>[
          Positioned(top: 20, left: 20, child: _buildUserDataBox()),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 128,
                  height: 128,
                  child: Center(
                    child: MouseRegion(
                      onEnter: (_) => setState(() => _hovered = true),
                      onExit: (_) {
                        setState(() {
                          _hovered = false;
                        });
                      },
                      child: GestureDetector(
                        onTap: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          widget.onPlayPressed();
                          widget.game.startGame();
                        },
                        child: Image.asset(
                          'assets/game/images/Menu/Buttons/Play.png',
                          width: _hovered ? 128 : 96,
                          height: _hovered ? 128 : 96,
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.none,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 48),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ArrowButton(icon: Icons.arrow_left, onPressed: () => changeActor(-1)),

                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 150),
                      switchInCurve: Curves.easeIn,
                      switchOutCurve: Curves.easeOut,
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      child: SpriteSheetPreview(
                        key: ValueKey<String>(actor.name),
                        actor: actor,
                        state: state,
                        onFinished: () {
                          if (state != PlayerState.idle) {
                            playState(PlayerState.idle);
                          }
                        },
                      ),
                    ),
                    ArrowButton(icon: Icons.arrow_right, onPressed: () => changeActor(1)),
                  ],
                ),
                SizedBox(height: 30),
                Text(
                  actor.name.toUpperCase(),
                  style: PixelText.mulmaru(
                    fontSize: 24,
                    color: Colors.white,
                  ).copyWith(decoration: TextDecoration.none, decorationColor: Colors.transparent),
                ),
                SizedBox(
                  width: 300,
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Use Joystick: ",
                        style: PixelText.mulmaru(
                          fontSize: 24,
                          color: Colors.white,
                        ).copyWith(decoration: TextDecoration.none, decorationColor: Colors.transparent),
                      ),
                      Switch(
                        value: Global.showJoystick,
                        onChanged: (bool value) {
                          setState(() {
                            Global.showJoystick = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Sounds: ",
                        style: PixelText.mulmaru(
                          fontSize: 24,
                          color: Colors.white,
                        ).copyWith(decoration: TextDecoration.none, decorationColor: Colors.transparent),
                      ),
                      Switch(
                        value: Global.playSound,
                        onChanged: (bool value) {
                          setState(() {
                            Global.playSound = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserDataBox() {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xCC000000),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Global.email == null ? _buildEmailInput() : _buildLevelData(),
    );
  }

  Widget _buildEmailInput() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          'ENTER EMAIL TO ACCESS DATA',
          style: PixelText.mulmaru(
            fontSize: 14,
            color: Colors.white,
          ).copyWith(decoration: TextDecoration.none),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: emailController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'email@example.com',
            hintStyle: const TextStyle(color: Colors.white54),
            errorText: emailError,
            enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF4FC3F7))),
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: loadingEmail ? null : submitEmail,
          child: Text(loadingEmail ? 'LOADING...' : 'SUBMIT'),
        ),
      ],
    );
  }

  Widget _buildLevelData() {
    final List<MapEntry<String, String>> entries = Global.levelData.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                Global.email!,
                overflow: TextOverflow.ellipsis,
                style: PixelText.mulmaru(
                  fontSize: 12,
                  color: const Color(0xFF4FC3F7),
                ).copyWith(decoration: TextDecoration.none),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                setState(() {
                  Global.email = null;
                  Global.removeEmail();
                  Global.levelData.clear();
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.red.shade700, borderRadius: BorderRadius.circular(4)),
                child: Text(
                  'Logout',
                  style: PixelText.mulmaru(
                    fontSize: 10,
                    color: Colors.white,
                  ).copyWith(decoration: TextDecoration.none),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 160,
          child: entries.isEmpty
              ? Text(
                  'NO LEVEL DATA',
                  style: PixelText.mulmaru(
                    fontSize: 14,
                    color: Colors.white,
                  ).copyWith(decoration: TextDecoration.none),
                )
              : ListView.builder(
                  itemCount: entries.length,
                  itemBuilder: (BuildContext context, int index) {
                    final MapEntry<String, String> entry = entries[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        'LEVEL ${entry.key}  -  ${entry.value}',
                        style: PixelText.mulmaru(
                          fontSize: 14,
                          color: Colors.white,
                        ).copyWith(decoration: TextDecoration.none),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class SpriteSheetPreview extends StatefulWidget {
  final Actor actor;
  final PlayerState state;
  final VoidCallback onFinished;

  const SpriteSheetPreview({super.key, required this.actor, required this.state, required this.onFinished});

  @override
  State<SpriteSheetPreview> createState() => _SpriteSheetPreviewState();
}

class _SpriteSheetPreviewState extends State<SpriteSheetPreview> {
  ui.Image? image;
  Timer? timer;
  int frame = 0;

  bool get isOneShot => widget.state != PlayerState.idle;

  @override
  void initState() {
    super.initState();
    loadImage();
  }

  Future<void> loadImage() async {
    final int pixels = widget.state == PlayerState.appearing || widget.state == PlayerState.disappearing
        ? 96
        : 32;

    final ByteData data = await rootBundle.load(
      'assets/game/images/Main Characters/${widget.actor.name}/${widget.state.name} (${pixels}x$pixels).png',
    );

    final Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());

    final FrameInfo frameInfo = await codec.getNextFrame();

    image = frameInfo.image;

    timer = Timer.periodic(const Duration(milliseconds: 80), (_) {
      if (!mounted) return;

      setState(() {
        frame++;

        if (frame >= widget.state.frames) {
          if (isOneShot) {
            timer?.cancel();
            widget.onFinished();
          } else {
            frame = 0;
          }
        }
      });
    });

    setState(() {});
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (image == null) {
      return const SizedBox(width: 128, height: 128);
    }

    return SizedBox(
      width: 128,
      height: 128,
      child: CustomPaint(
        painter: SpriteFramePainter(
          image: image!,
          frame: frame.clamp(0, widget.state.frames - 1),
          frameSize: 32,
        ),
      ),
    );
  }
}

class SpriteFramePainter extends CustomPainter {
  final ui.Image image;
  final int frame;
  final double frameSize;

  SpriteFramePainter({required this.image, required this.frame, required this.frameSize});

  @override
  void paint(Canvas canvas, Size size) {
    final Rect src = Rect.fromLTWH(frame * frameSize, 0, frameSize, frameSize);

    final Rect dst = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.drawImageRect(image, src, dst, Paint()..filterQuality = FilterQuality.none);
  }

  @override
  bool shouldRepaint(covariant SpriteFramePainter oldDelegate) {
    return oldDelegate.frame != frame || oldDelegate.image != image;
  }
}
