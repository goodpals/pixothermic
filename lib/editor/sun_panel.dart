import 'package:flutter/material.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:hot_cold/editor/panel.dart';

class SunPanel extends StatelessWidget {
  final Color sunColour;
  final void Function(Color) onSetSunColour;
  final double sunAngle;
  final void Function(double) onSetSunAngle;

  const SunPanel({
    super.key,
    required this.sunColour,
    required this.onSetSunColour,
    required this.sunAngle,
    required this.onSetSunAngle,
  });

  @override
  Widget build(BuildContext context) {
    return Panel(
      title: 'Sun',
      icon: const Icon(Icons.sunny),
      child: Column(
        children: [
          ColorPicker(
            color: sunColour,
            onChanged: onSetSunColour,
            initialPicker: Picker.wheel,
            pickerOrientation: PickerOrientation.portrait,
            paletteHeight: 100,
          ),
          Text('Angle: $sunAngle'),
          Slider(
            value: sunAngle,
            min: -200,
            max: 200,
            divisions: 401,
            onChanged: (v) => onSetSunAngle(v.round().toDouble()),
          ),
        ],
      ),
    );
  }
}
