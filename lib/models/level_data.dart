import 'package:flutter/material.dart';
import 'package:hot_cold/models/entities.dart';
import 'package:hot_cold/models/sprites.dart';
import 'package:hot_cold/models/types.dart';

class LevelData {
  final IntVec spawn;
  final IntVec goal;
  final Map<IntVec, String> foreground;
  final Map<IntVec, EntityType> entities;
  final Map<IntVec, double> water;
  final double sunHeight;
  final double sunAngle;
  final Color sunColour;
  final Color waterColour;

  const LevelData({
    required this.spawn,
    required this.goal,
    this.foreground = const {},
    this.entities = const {},
    this.water = const {},
    this.sunHeight = 200,
    this.sunAngle = 0,
    this.sunColour = Colors.amber,
    this.waterColour = Colors.indigo,
  });

  Map<String, dynamic> toJson() => {
        'spawn': spawn.export(),
        'goal': goal.export(),
        'foreground': foreground.map((k, v) => MapEntry(k.export(), v)),
        'entities': entities.map((k, v) => MapEntry(k.export(), v)),
        'water': water.map((k, v) => MapEntry(k.export(), v)),
        'sunHeight': sunHeight,
        'sunAngle': sunAngle,
        'sunColour': sunColour.value,
        'waterColour': waterColour.value,
      };

  factory LevelData.fromJson(Map json) => LevelData(
        spawn: intVecFromString(json['spawn']),
        goal: intVecFromString(json['goal']),
        foreground: json['foreground'].map<IntVec, String>(
                (k, v) => MapEntry<IntVec, String>(intVecFromString(k), v))
            as Map<IntVec, String>,
        entities: json['entities'].map<IntVec, EntityType>((k, v) =>
            MapEntry<IntVec, EntityType>(
                intVecFromString(k), EntityType.fromString(k)!)),
        water: json['water'].map<IntVec, double>(
                (k, v) => MapEntry<IntVec, double>(intVecFromString(k), v))
            as Map<IntVec, double>,
        sunHeight: json['sunHeight'],
        sunAngle: json['sunAngle'],
        sunColour: Color(json['sunColour']),
        waterColour: Color(json['waterColour']),
      );
}

LevelData testLevel() => LevelData(
      spawn: (0, -4),
      goal: (0, 20),
      sunColour: Colors.amber.shade400,
      waterColour: Colors.indigo.shade400,
      sunAngle: 100,
      foreground: {
        // upper platforms
        for (int i in List.generate(6, (i) => i))
          (i - 6, -5): SpritePaths.brick,
        for (int i in List.generate(7, (i) => i))
          (i + 2, -5): SpritePaths.brick,

        //main platforms
        (-7, 0): SpritePaths.leftBasePiece,
        for (int i in List.generate(2, (i) => i))
          (i - 6, 0): SpritePaths.middleBasePiece,
        for (int i in List.generate(5, (i) => i))
          (i - 1, 0): SpritePaths.middleBasePiece,
        for (int i in List.generate(3, (i) => i))
          (-5, i + 1): SpritePaths.brick1,
        for (int i in List.generate(3, (i) => i))
          (-1, i + 1): SpritePaths.brick2,
        for (int i in List.generate(2, (i) => i))
          (i - 5, 4): SpritePaths.brick3,
        for (int i in List.generate(2, (i) => i))
          (i - 2, 4): SpritePaths.brick4,
        (-3, 4): SpritePaths.grate,
        (4, 0): SpritePaths.rightBasePiece,
        (7, -1): SpritePaths.brick,
        for (int i in List.generate(6, (i) => i))
          (i - -7, 0): SpritePaths.brick,
        (4, 1): SpritePaths.dirt1,
        (4, 2): SpritePaths.dirt2,
        (5, 2): SpritePaths.dirt1,
        (6, 2): SpritePaths.dirt2,
        (7, 2): SpritePaths.dirt1,
        (7, 1): SpritePaths.dirt2,
      },
      entities: {
        // (-5, -1): EntityType.heavyCrate,
        // (-1, -6): EntityType.mirror,
        (-1, -3): EntityType.metalCrate,
        (1, -3): EntityType.mirror,
        (3, -3): EntityType.metalCrate,
        for (int i in List.generate(9, (i) => i))
          ((i % 3) - 4, 3 - (i ~/ 3)): EntityType.iceBlock,
      },
      water: {
        (6, -1): 5,
      },
    );

LevelData levelOne() => LevelData(
      spawn: (0, 0),
      goal: (0, 20),
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
      entities: {
        (-4, 0): EntityType.heavyCrate,
        (1, 0): EntityType.lightCrate,
        (3, 0): EntityType.iceBlock,
        (5, 0): EntityType.lightCrate,
        (-6, 0): EntityType.metalCrate,
      },
      water: {
        (9, -3): 6.125,
      },
    );
