import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:hot_cold/game.dart';
import 'package:hot_cold/models/level_data.dart';

class GamePage extends StatefulWidget {
  final LevelData level;

  const GamePage({
    super.key,
    required this.level,
  });

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late GameClass game = GameClass(widget.level);

  void _resetGame() => setState(() => game = GameClass(widget.level));

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
      body: Stack(children: [
        const Image(
          image:
              AssetImage('assets/images/backgrounds/cave_background_one.jpg'),
        ),
        Center(
          child: GameWidget<GameClass>(game: game),
        ),
      ]),
    );
  }
}
