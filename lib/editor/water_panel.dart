import 'package:flutter/material.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:hot_cold/editor/panel.dart';

class WaterPanel extends StatelessWidget {
  final bool active;
  final void Function(bool?) onSetActive;
  final Color colour;
  final void Function(Color) onSetColour;

  const WaterPanel({
    super.key,
    required this.active,
    required this.onSetActive,
    required this.colour,
    required this.onSetColour,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSetActive(!active),
      child: Panel(
        title: 'Water',
        icon: const Icon(Icons.water),
        active: active,
        child: Column(
          children: [
            Row(
              children: [
                Checkbox(value: active, onChanged: onSetActive),
                const Text('Water'),
              ],
            ),
            ColorPicker(
              color: colour,
              onChanged: onSetColour,
              initialPicker: Picker.wheel,
              pickerOrientation: PickerOrientation.portrait,
              paletteHeight: 100,
            )
          ],
        ),
      ),
    );
  }
}
