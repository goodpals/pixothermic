import 'package:flutter/material.dart';

class SettingsDialog extends StatefulWidget {
  final double rayDensity;
  const SettingsDialog({super.key, required this.rayDensity});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  late double rayDensity = widget.rayDensity;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // title: const Icon(Icons.settings),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.sunny),
              Text('Ray density: ${rayDensity.round()}'),
            ],
          ),
          Slider(
            value: rayDensity,
            onChanged: (v) => setState(() => rayDensity = v),
            min: 4,
            max: 32,
            divisions: 28,
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () => Navigator.pop(context, null),
          icon: const Icon(Icons.cancel),
        ),
        IconButton(
          onPressed: () => Navigator.pop(context, rayDensity),
          icon: const Icon(Icons.check),
        ),
      ],
    );
  }
}
