import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hot_cold/locator.dart';
import 'package:hot_cold/store/settings_store.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.settings),
          SizedBox(width: 16),
          Text('Settings'),
        ],
      ),
      content: BlocBuilder<SettingsStore, Settings>(
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.sunny),
                  Text('Ray density: ${state.rayDensity.round()}'),
                ],
              ),
              Slider(
                value: state.rayDensity,
                onChanged: settings().setRayDensity,
                min: 4,
                max: 32,
                divisions: 28,
              ),
              // music volume
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.music_note),
                  Text('Music volume: ${(state.musicVolume * 100).round()}%'),
                ],
              ),
              Slider(
                value: state.musicVolume,
                onChanged: settings().setMusicVolume,
                min: 0,
                max: 1,
                divisions: 10,
              ),
            ],
          );
        },
      ),
    );
  }
}
