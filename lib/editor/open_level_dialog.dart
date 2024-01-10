import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hot_cold/models/level_data.dart';
import 'package:hot_cold/store/level_store.dart';

class OpenLevelDialog extends StatefulWidget {
  const OpenLevelDialog({super.key});

  @override
  State<OpenLevelDialog> createState() => _OpenLevelDialogState();
}

class _OpenLevelDialogState extends State<OpenLevelDialog> {
  // todo: lazy load these, could potentially be a lot of them

  LevelData? selectedLevel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Open Level'),
      content: BlocBuilder<LevelStore, LevelStoreState>(
        builder: (context, state) {
          final levels = [
            ...state.customLevels.values,
            ...state.campaignLevels.values,
          ];
          return SizedBox(
            width: double.maxFinite,
            // height: constraints.maxHeight * 0.9,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: levels.length,
              itemBuilder: (context, i) => ListTile(
                tileColor: i % 2 == 0 ? Colors.grey[200] : Colors.white,
                title: Text(levels[i].id),
                onTap: () => Navigator.of(context).pop(levels[i]),
              ),
            ),
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: selectedLevel != null
              ? () => Navigator.of(context).pop(selectedLevel)
              : null,
          child: const Text('Open'),
        ),
      ],
    );
  }
}
