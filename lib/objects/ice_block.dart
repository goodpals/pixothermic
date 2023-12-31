import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:hot_cold/models/constants.dart';
import 'package:hot_cold/models/sprites.dart';
import 'package:hot_cold/utils/buoyant.dart';
import 'package:hot_cold/utils/heatable.dart';
import 'package:hot_cold/utils/reflective.dart';
import 'package:hot_cold/objects/static_sprite.dart';
import 'package:hot_cold/utils/long_tick.dart';

class IceBlock extends BodyComponent
    with LongTick, Heatable, Buoyant, Reflective {
  final void Function(IceBlock)? onMelt;

  final StaticSprite sprite;
  final double size;

  IceBlock({
    required Vector2 position,
    this.onMelt,
    this.size = unit * 31 / 32,
  })  : sprite = StaticSprite(
          spritePath: SpritePaths.iceBlock,
          size: size,
        ),
        super(
          bodyDef: BodyDef(
            position: position,
            type: BodyType.dynamic,
            fixedRotation: true,
            gravityScale: Vector2(0, 2),
          ),
          renderBody: false,
        );

  @override
  Future<void> onLoad() {
    fixtureDefs = [
      FixtureDef(
        PolygonShape()
          ..set([
            Vector2(-size / 2, -size / 2),
            Vector2(-size / 2, size / 2),
            Vector2(size / 2, size / 2),
            Vector2(size / 2, -size / 2),
          ]),
        friction: 0.4,
        density: 2,
        userData: this,
      ),
    ];
    add(sprite);
    sprite.tint(Colors.blue.withOpacity((1 - temperature).clamp(0, 1) * 0.5));
    return super.onLoad();
  }

  @override
  void onTemperatureChange() {
    sprite.tint(Colors.blue.withOpacity((1 - temperature).clamp(0, 1) * 0.5));
    if (temperature >= tempRange.$2) {
      onMelt?.call(this);
    }
  }

  @override
  double get specularity => 0.5;

  @override
  String toString() => 'IceBlock';
}
