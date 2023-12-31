import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:hot_cold/game.dart';
import 'package:hot_cold/locator.dart';
import 'package:hot_cold/models/level_data.dart';
import 'package:hot_cold/models/levels.dart';
import 'package:hot_cold/widgets/settings_dialog.dart';

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
  late GameClass game = _makeGame();

  void _onWin() {
    if (widget.levelId != null) {
      progress().add(widget.levelId!);
    }
  }

  GameClass _makeGame() => GameClass(widget.level, onWin: _onWin)
    ..rayDensity = settings().rayDensity;

  void _resetGame() => setState(() => game = _makeGame());

  void _adjustRayDensity(double density) {
    setState(() => game.rayDensity = density);
    _focusNode.requestFocus();
    settings().setRayDensity(density);
  }

  int? get nextLevelId =>
      (widget.levelId != null && campaignLevelPaths.length > widget.levelId!)
          ? widget.levelId! + 1
          : null;

  final _focusScopeNode = FocusScopeNode();
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      node: _focusScopeNode,
      child: Scaffold(
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
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () async {
                final rd = await showDialog(
                  context: context,
                  builder: (context) =>
                      SettingsDialog(rayDensity: game.rayDensity),
                );
                if (rd != null) {
                  _adjustRayDensity(rd);
                }
              },
            ),
          ],
        ),
        body: Center(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  'assets/images/backgrounds/cave_background_three.png',
                ),
              ),
            ),
            child: Focus(
              child: GameWidget<GameClass>(
                focusNode: _focusNode,
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
                                      levelId: nextLevelId,
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
        ),
      ),
    );
  }
}
