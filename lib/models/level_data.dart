import 'package:hot_cold/models/types.dart';

class LevelData {
  final IntVec spawn;
  final Map<IntVec, String> foreground;
  final Map<IntVec, String> background;

  const LevelData({
    required this.spawn,
    required this.foreground,
    required this.background,
  });
}
