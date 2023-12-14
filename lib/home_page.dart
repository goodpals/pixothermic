import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hot_cold/game_page.dart';
import 'package:hot_cold/locator.dart';
import 'package:hot_cold/editor/editor_page.dart';
import 'package:hot_cold/models/levels.dart';
import 'package:hot_cold/store/progress_store.dart';
import 'package:quiver/iterables.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const EditorPage())),
            icon: const Icon(Icons.handyman),
          ),
          IconButton(
            onPressed: () => context.read<ProgressStore>().clear(),
            icon: const Icon(Icons.delete),
          ),
          IconButton(
            onPressed: () => music().toggleMusic(),
            icon: const Icon(Icons.music_note),
          ),
        ],
      ),
      body: Center(
        child: LayoutBuilder(builder: (context, constraints) {
          return Column(
            children: [
              Flexible(
                child: BlocBuilder<ProgressStore, Set<int>>(
                  builder: (context, completedLevels) {
                    return GridView.count(
                      crossAxisCount: constraints.maxWidth ~/ 100,
                      children: [
                        for (final (i, _) in campaignLevelPaths.indexed)
                          GestureDetector(
                            onTap: () async {
                              final level = await levelStore()
                                  .loadCampaignLevel(context, i);
                              if (!mounted) return;
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => GamePage(
                                    level: level,
                                    levelId: i,
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              color: completedLevels.contains(i)
                                  ? Colors.green.withOpacity(0.1)
                                  : null,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                    child: Text(
                                  partition(List.filled(i + 1, '•'),
                                          sqrt(i + 1).floor())
                                      .map((e) => e.join())
                                      .join('\n'),
                                  style: const TextStyle(
                                    fontSize: 24,
                                    height: 0.5,
                                  ),
                                )),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
