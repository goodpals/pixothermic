import 'package:flutter/material.dart';

class LoadJsonDialog extends StatefulWidget {
  const LoadJsonDialog({super.key});

  @override
  State<LoadJsonDialog> createState() => _LoadJsonDialogState();
}

class _LoadJsonDialogState extends State<LoadJsonDialog> {
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Load Level'),
      content: TextField(
        controller: _controller,
        maxLines: 10,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'JSON',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(_controller.text),
          child: const Text('Load'),
        ),
      ],
    );
  }
}
