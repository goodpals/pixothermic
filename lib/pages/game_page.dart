import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:hot_cold/game.dart';
import 'package:hot_cold/models/level_data.dart';

class GamePage extends StatelessWidget {
  final LevelData level;

  const GamePage({
    super.key,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
      ),
      body: Center(
        child: GameWidget<GameClass>.controlled(
          gameFactory: () => GameClass(level),
        ),
      ),
    );
  }
}
