import 'package:flutter/material.dart';
import 'package:hot_cold/game_page.dart';
import 'package:hot_cold/models/level_data.dart';
import 'package:hot_cold/editor/editor_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  late final levels = [testLevel(), levelOne()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LayoutBuilder(builder: (context, constraints) {
          return Column(
            children: [
              Flexible(
                child: GridView.count(
                  crossAxisCount: 5,
                  children: [
                    for (final (i, level) in levels.indexed)
                      GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => GamePage(level: level),
                          ),
                        ),
                        child: Card(
                          child: Column(
                            children: [Text('Level ${i + 1}')],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const EditorPage())),
                child: const Text('Level Editor'),
              ),
              // OutlinedButton(
              //   onPressed: () => Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (_) => const GameWidget<GameClass>.controlled(
              //           gameFactory: GameClass.new),
              //     ),
              //   ),
              //   child: const Text('Play'),
              // ),
            ],
          );
        }),
      ),
    );
  }
}
