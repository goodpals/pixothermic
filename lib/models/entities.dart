import 'package:hive/hive.dart';
import 'package:hot_cold/models/sprites.dart';

enum EntityType {
  @HiveField(0)
  spawn(SpritePaths.spawn),
  @HiveField(1)
  goal(SpritePaths.goal),
  @HiveField(2)
  lightCrate(SpritePaths.crate),
  @HiveField(3)
  heavyCrate(SpritePaths.heavyCrate),
  @HiveField(4)
  metalCrate(SpritePaths.metalCrate),
  @HiveField(5)
  iceBlock(SpritePaths.iceBlock),
  @HiveField(6)
  mirror(SpritePaths.mirror);

  final String spritePath;
  const EntityType(this.spritePath);

  static EntityType? fromString(String str) =>
      EntityType.values.where((e) => e.name == str).firstOrNull;
}
