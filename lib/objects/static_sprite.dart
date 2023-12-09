import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:hot_cold/game.dart';
import 'package:hot_cold/models/constants.dart';

class StaticSprite extends SpriteComponent with HasGameRef<GameClass> {
  final String spritePath;
  final Color? tintColour;

  StaticSprite({
    required this.spritePath,
    double size = unit,
    this.tintColour,
  }) : super(size: Vector2.all(size), anchor: Anchor.center);

  @override
  void onLoad() {
    final image = game.images.fromCache(spritePath);
    sprite = Sprite(image);
    if (tintColour != null) {
      tint(tintColour!);
    }
  }
}
