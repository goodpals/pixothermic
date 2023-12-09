import 'package:hot_cold/models/entities.dart';
import 'package:hot_cold/models/sprites.dart';
import 'package:hot_cold/models/types.dart';

class LevelData {
  final IntVec spawn;
  final Map<IntVec, String> foreground;
  final Map<IntVec, String> background;
  final Map<IntVec, EntityType> entities;
  final Map<IntVec, double> water;

  const LevelData({
    required this.spawn,
    this.foreground = const {},
    this.background = const {},
    this.entities = const {},
    this.water = const {},
  });
}

LevelData testLevel() => LevelData(
      spawn: (0, -4),
      foreground: {
        for (int i in List.generate(11, (i) => i))
          (i - 6, 0): SpritePaths.brick,
        (7, -1): SpritePaths.brick,
        for (int i in List.generate(6, (i) => i))
          (i - -7, 0): SpritePaths.brick,

        (5, 1): SpritePaths.brick,
        (6, 1): SpritePaths.brick,
        // (-8, 2): SpritePaths.brick,
        // (-7, 2): SpritePaths.brick,
        // (-3, 3): SpritePaths.brick,
        // (-3, 2): SpritePaths.brick,
      },
      background: {},
      entities: {
        (-2, -4): EntityType.lightCrate,
        (-4, -4): EntityType.lightCrate,
      },
      water: {
        (-5, 2): 1,
      },
    );
