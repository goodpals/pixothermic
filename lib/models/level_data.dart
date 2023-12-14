import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hot_cold/models/entities.dart';
import 'package:hot_cold/models/sprites.dart';
import 'package:hot_cold/models/types.dart';
import 'package:hot_cold/utils/misc.dart';

class LevelData extends Equatable {
  final String id;
  final String? title;
  final String? author;
  final int version;

  /// Whether this is part of the campaign.
  /// This is filled in automatically, not from the JSON.
  final bool isCampaign;
  final IntVec spawn;
  final IntVec goal;
  final Map<IntVec, String> foreground;
  final Map<IntVec, EntityType> entities;
  final Map<IntVec, num> water;
  final num sunHeight;
  final num sunAngle;
  final Color sunColour;
  final Color waterColour;

  (int, int) get horizontalConstraints => (leftMostBlock, rightMostBlock);
  int get leftMostBlock => foreground.keys.map((e) => e.$1).reduce(min);
  int get rightMostBlock => foreground.keys.map((e) => e.$1).reduce(max);

  const LevelData({
    required this.id,
    this.title,
    this.author,
    this.version = 1,
    this.isCampaign = false,
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
        'id': id,
        'title': title,
        'author': author,
        'version': version,
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

  factory LevelData.fromJson(Map json, {bool isCampaign = false}) => LevelData(
        id: json['id'] ?? generateIdPhrase(),
        title: json['title'],
        author: json['author'],
        version: json['version'] ?? 1,
        isCampaign: isCampaign,
        spawn: intVecFromString(json['spawn']),
        goal: intVecFromString(json['goal']),
        foreground: json['foreground'].map<IntVec, String>(
                (k, v) => MapEntry<IntVec, String>(intVecFromString(k), v))
            as Map<IntVec, String>,
        entities: json['entities']
            .map<IntVec, EntityType>((k, v) => MapEntry<IntVec, EntityType>(
                  intVecFromString(k),
                  EntityType.fromString(v)!,
                )),
        water: json['water'].map<IntVec, num>(
                (k, v) => MapEntry<IntVec, num>(intVecFromString(k), v))
            as Map<IntVec, num>,
        sunHeight: json['sunHeight'],
        sunAngle: json['sunAngle'],
        sunColour: Color(json['sunColour']),
        waterColour: Color(json['waterColour']),
      );

  @override
  List<Object?> get props => [title, author, version];
}

LevelData testLevel() => LevelData(
      id: 'test',
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
      water: const {
        (6, -1): 5,
      },
    );
