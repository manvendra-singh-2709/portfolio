import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/game/pixel_adventure.dart';
import 'package:portfolio/globals/globals.dart';

class GameRoute extends StatelessWidget {
  const GameRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final PixelAdventure game = Global.game ?? PixelAdventure();

    return GameWidget<PixelAdventure>(
      game: game,
      overlayBuilderMap: {
        'mainMenu': (context, game) {
          return Center(
            child: ElevatedButton(onPressed: game.startGame, child: const Text('PLAY')),
          );
        },
        'levelHud': (context, game) {
          return Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ValueListenableBuilder<int>(
                  valueListenable: game.levelNotifier,
                  builder: (_, level, _) {
                    return Image.asset(
                      'assets/game/images/Menu/Levels/${level.toString().padLeft(2, '0')}.png',
                      height: 40,
                      width: 40,
                      fit: BoxFit.fill,
                      filterQuality: FilterQuality.none,
                    );
                  },
                ),

                const SizedBox(width: 20),

                ValueListenableBuilder<double>(
                  valueListenable: game.levelTimeNotifier,
                  builder: (_, time, _) {
                    final seconds = time.floor();
                    final minutes = seconds ~/ 60;
                    final remSeconds = seconds % 60;

                    final text =
                        '${minutes.toString().padLeft(2, '0')}:${remSeconds.toString().padLeft(2, '0')}';

                    return Text(
                      text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontFamily: 'monospace',
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
        'gameOver': (context, game) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'GAME COMPLETE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    game.overlays.remove('gameOver');
                    game.startGame();
                  },
                  child: const Text('PLAY AGAIN'),
                ),
              ],
            ),
          );
        },
        'levelComplete': (context, game) {
          return Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              color: const Color(0xCC211F30),
              child: ValueListenableBuilder<double>(
                valueListenable: game.completedLevelTimeNotifier,
                builder: (_, time, _) {
                  final int seconds = time.floor();
                  final int minutes = seconds ~/ 60;
                  final int remSeconds = seconds % 60;

                  final text =
                      '${minutes.toString().padLeft(2, '0')}:${remSeconds.toString().padLeft(2, '0')}';

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'LEVEL COMPLETE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'TIME  $text',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(onPressed: game.loadNextLevel, child: const Text('NEXT LEVEL')),
                      const SizedBox(height: 12),
                      ElevatedButton(onPressed: game.exitToMainMenu, child: const Text('MAIN MENU')),
                    ],
                  );
                },
              ),
            ),
          );
        },
      },
    );
  }
}
