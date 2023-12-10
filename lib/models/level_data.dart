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
        // upper platforms
        for (int i in List.generate(6, (i) => i))
          (i - 6, -5): SpritePaths.brick,
        for (int i in List.generate(7, (i) => i))
          (i + 2, -5): SpritePaths.brick,

        //main platforms
        (-7, 0): SpritePaths.leftBasePiece,
        for (int i in List.generate(10, (i) => i))
          (i - 6, 0): SpritePaths.middleBasePiece,
        (4, 0): SpritePaths.rightBasePiece,
        (7, -1): SpritePaths.brick,
        for (int i in List.generate(6, (i) => i))
          (i - -7, 0): SpritePaths.brick,
        (4, 1): SpritePaths.subsurfBasePiece,
        (4, 2): SpritePaths.subsurfBasePiece,
        (5, 2): SpritePaths.subsurfBasePiece,
        (6, 2): SpritePaths.subsurfBasePiece,
        (7, 2): SpritePaths.subsurfBasePiece,
        (7, 1): SpritePaths.subsurfBasePiece,
      },
      background: {},
      entities: {
        (-5, -1): EntityType.heavyCrate,
        (-3, -4): EntityType.lightCrate,
        (-1, -3): EntityType.iceBlock,
      },
      water: {
        (6, -1): 5,
      },
    );

LevelData levelOne() => LevelData(
      spawn: (0, 0),
      foreground: {
        // upper platforms
        (-2, -1): SpritePaths.leftPlatPiece,
        (-1, -1): SpritePaths.rightPlatPiece,

        (1, -3): SpritePaths.leftPlatPiece,
        (2, -3): SpritePaths.midPlatPiece,
        (3, -3): SpritePaths.rightPlatPiece,

        (6, -4): SpritePaths.leftPlatPiece,
        for (int i in List.generate(3, (i) => i))
          (i - -7, -4): SpritePaths.midPlatPiece,
        (10, -4): SpritePaths.rightPlatPiece,

        // left boundary
        for (int i in List.generate(10, (i) => i))
          (-11, i - 9): SpritePaths.brick,

        // base boundary
        (-11, 1): SpritePaths.subsurfBasePiece,
        for (int i in List.generate(17, (i) => i))
          (i - 10, 1): SpritePaths.middleBasePiece,
        for (int i in List.generate(18, (i) => i))
          (i - -11, 1): SpritePaths.middleBasePiece,
        for (int i in List.generate(18, (i) => i))
          (i - 11, 2): SpritePaths.subsurfBasePiece,
        for (int i in List.generate(8, (i) => i))
          (i - -11, 2): SpritePaths.subsurfBasePiece,
        for (int i in List.generate(30, (i) => i))
          (i - 11, 3): SpritePaths.subsurfBasePiece,
        // for (int i in List.generate(30, (i) => i))
        //   (i - 11, 4): SpritePaths.subsurfBasePiece,
        // for (int i in List.generate(30, (i) => i))
        //   (i - 11, 5): SpritePaths.subsurfBasePiece,
        // for (int i in List.generate(30, (i) => i))
        //   (i - 11, 6): SpritePaths.subsurfBasePiece,
        // for (int i in List.generate(30, (i) => i))
        //   (i - 11, 7): SpritePaths.subsurfBasePiece,
      },
      background: {},
      entities: {
        (-4, 0): EntityType.heavyCrate,
        (1, 0): EntityType.lightCrate,
        (3, 0): EntityType.iceBlock,
        (5, 0): EntityType.lightCrate,

        // only shadow currently showing?
        (-6, 0): EntityType.metalCrate,
      },
      water: {
        (9, -3): 6.125,
      },
    );
