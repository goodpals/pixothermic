import 'package:flutter/material.dart';
import 'package:hot_cold/models/level_data.dart';
import 'package:hot_cold/pages/game_page.dart';

class LevelSelectPage extends StatelessWidget {
  LevelSelectPage({super.key});

  late final levels = [testLevel(), levelOne()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GridView.count(
          crossAxisCount: 5,
          children: [
            for (final (i, level) in levels.indexed)
              OutlinedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => GamePage(level: level),
                  ),
                ),
                child: Text('Level ${i + 1}'),
              ),
          ],
        ),
      ),
    );
  }
}
