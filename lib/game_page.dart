import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:hot_cold/game.dart';
import 'package:hot_cold/locator.dart';
import 'package:hot_cold/models/level_data.dart';
import 'package:hot_cold/models/levels.dart';

class GamePage extends StatefulWidget {
  final int? levelId;
  final LevelData level;

  const GamePage({
    super.key,
    this.levelId,
    required this.level,
  });

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late GameClass game = GameClass(widget.level, onWin: _onWin);

  void _onWin() {
    if (widget.levelId != null) {
      progress().add(widget.levelId!);
    }
  }

  void _resetGame() =>
      setState(() => game = GameClass(widget.level, onWin: _onWin));

  int? get nextLevelId =>
      campaignLevelPaths.length > widget.levelId! ? widget.levelId! + 1 : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Row(
          children: [
            IconButton(
              onPressed: _resetGame,
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
      ),
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                'assets/images/backgrounds/cave_background_one.jpg',
              ),
            ),
          ),
          child: GameWidget<GameClass>(
            game: game,
            overlayBuilderMap: {
              'WonDialog': (context, game) {
                return Center(
                  child: AlertDialog(
                    title: const Center(child: Text('🎉🎉🎉')),
                    actions: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.home),
                      ),
                      if (nextLevelId != null)
                        IconButton(
                          onPressed: () async {
                            final level = await levelStore()
                                .loadCampaignLevel(context, nextLevelId!);
                            if (!mounted) return;
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => GamePage(
                                  level: level,
                                  levelId: nextLevelId!,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.arrow_right_alt),
                        ),
                    ],
                  ),
                );
              },
              'LostDialog': (context, game) {
                return Center(
                  child: AlertDialog(
                    title: const Center(child: Text('😢😢😢')),
                    actions: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.home),
                      ),
                      IconButton(
                        onPressed: _resetGame,
                        icon: const Icon(Icons.refresh),
                      ),
                    ],
                  ),
                );
              },
            },
          ),
        ),
      ),
    );
  }
}
