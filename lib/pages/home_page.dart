import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hot_cold/game.dart';
import 'package:hot_cold/pages/editor_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            OutlinedButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const EditorPage())),
              child: const Text('Level Editor'),
            ),
            OutlinedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const GameWidget<GameClass>.controlled(
                      gameFactory: GameClass.new),
                ),
              ),
              child: const Text('Play'),
            ),
          ],
        ),
      ),
    );
  }
}
