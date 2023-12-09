import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EditorPage extends StatefulWidget {
  const EditorPage({super.key});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Editor'),
            OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('back')),
          ],
        ),
      ),
    );
  }
}
