import 'dart:async';
import 'dart:math';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hot_cold/game.dart';
import 'package:hot_cold/locator.dart';
import 'package:hot_cold/models/level_data.dart';
import 'package:hot_cold/models/levels.dart';
import 'package:hot_cold/utils/fps_updater.dart';
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
  final _fpsController = FpsController();
  late final StreamSubscription _settingsSub;

  @override
  void initState() {
    super.initState();
    _settingsSub = settings().stream.listen(game.updateSettings);
  }

  @override
  void dispose() {
    _settingsSub.cancel();
    _fpsController.close();
    super.dispose();
  }

  void _onWin() {
    if (widget.levelId != null) {
      progress().add(widget.levelId!);
    }
  }

  GameClass _makeGame() =>
      GameClass(widget.level, onWin: _onWin, onFpsUpdate: _onFpsUpdate)
        ..updateSettings(settings().state);

  void _resetGame() => setState(() => game = _makeGame());

  void _onFpsUpdate(double fps) => _fpsController.update(fps);

  static const List<String> deathMessages = [
    'YOU\nDIED',
    'You are dead',
    'wasted',
    'We\'ll get \'em next time!',
    '\'F\' to pay respect',
    'We regret to inform you that you are no longer alive',
    'Character status: deceased',
    'Tip: staying underwater may prevent being alive',
    'GAME OVER',
    'Try again?',
    'git gud, scrub',
    'lol fail',
  ];

  static const List<String> winMessages = [
    'Level Complete!',
    'Well done!',
    'Passed',
    'Not bad',
    'Ok, nobody likes a show-off',
  ];

  String pickDeathMessage() =>
      deathMessages[Random().nextInt(deathMessages.length)];

  String pickWinMessage() => winMessages[Random().nextInt(winMessages.length)];

  int? get nextLevelId => (widget.levelId != null &&
          campaignLevelPaths.length > widget.levelId! + 1)
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
            BlocBuilder<FpsController, double>(
              bloc: _fpsController,
              builder: (context, fps) => Text('${fps.toStringAsFixed(0)} FPS'),
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => const SettingsDialog(),
                );
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
                        content: nextLevelId != null
                            ? Center(
                                heightFactor: 1,
                                child: Text(
                                  pickWinMessage(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            : const Center(
                                heightFactor: 1,
                                child: Text(
                                  'Congratulations!\nYou have completed all levels!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
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
                                await Navigator.of(context).pushReplacement(
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
                        content: Center(
                          heightFactor: 1,
                          child: Text(
                            pickDeathMessage(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
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
