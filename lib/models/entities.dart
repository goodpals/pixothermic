import 'package:hot_cold/models/sprites.dart';

enum EntityType {
  spawn(SpritePaths.spawn),
  goal(SpritePaths.goal),
  lightCrate(SpritePaths.crate),
  heavyCrate(SpritePaths.heavyCrate),
  metalCrate(SpritePaths.metalCrate),
  iceBlock(SpritePaths.iceBlock),
  mirror(SpritePaths.mirror);

  final String spritePath;
  const EntityType(this.spritePath);

  static EntityType? fromString(String str) =>
      EntityType.values.where((e) => e.name == str).firstOrNull;
}
