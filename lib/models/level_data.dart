import 'package:hot_cold/models/entities.dart';
import 'package:hot_cold/models/sprites.dart';
import 'package:hot_cold/models/types.dart';

class LevelData {
  final IntVec spawn;
  final Map<IntVec, String> foreground;
  final Map<IntVec, String> background;
  final Map<IntVec, EntityType> entities;

  const LevelData({
    required this.spawn,
    required this.foreground,
    required this.background,
    required this.entities,
  });
}

LevelData testLevel() => LevelData(
      spawn: (0, 0),
      foreground: {
        for (int i in List.generate(10, (i) => i))
          (i - 5, 4): SpritePaths.brick,
        (3, 3): SpritePaths.brick,
      },
      background: {},
      entities: {
        (-2, 0): EntityType.lightCrate,
      },
    );
