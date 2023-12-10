import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:hot_cold/app.dart';
import 'package:hot_cold/game.dart';
import 'package:hot_cold/models/level_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Flame.device.fullScreen();

  runApp(const App());
  // runApp(
  //   GameWidget<GameClass>.controlled(
  //     gameFactory: () => GameClass(testLevel()),
  //   ),
  // );
}
