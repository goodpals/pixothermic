import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:hot_cold/app.dart';
import 'package:hot_cold/game.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Flame.device.fullScreen();

  // runApp(const App());
  runApp(const GameWidget<GameClass>.controlled(gameFactory: GameClass.new));
}
