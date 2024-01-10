import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:hot_cold/models/constants.dart';
import 'package:hot_cold/models/sprites.dart';
import 'package:hot_cold/objects/static_sprite.dart';
import 'package:hot_cold/utils/heatable.dart';
import 'package:hot_cold/utils/long_tick.dart';
import 'package:hot_cold/utils/reflective.dart';

class HeatableStaticBlock extends BodyComponent
    with LongTick, Heatable, Reflective
    implements HeatableBody {
  final String spritePath;
  final double size;
  final StaticSprite sprite;

  HeatableStaticBlock({
    required Vector2 position,
    this.spritePath = SpritePaths.metalFloor,
    this.size = unit,
  })  : sprite = StaticSprite(
          spritePath: spritePath,
          size: size,
        ),
        super(
          bodyDef: BodyDef(
            position: position,
            type: BodyType.dynamic,
            fixedRotation: true,
            gravityOverride: Vector2.zero(),
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
      FixtureDef(
        PolygonShape()
          ..set([
            Vector2(-size / 1.9, -size / 1.9),
            Vector2(-size / 1.9, size / 1.9),
            Vector2(size / 1.9, size / 1.9),
            Vector2(size / 1.9, -size / 1.9),
          ]),
        userData: this,
        isSensor: true,
      ),
    ];
    add(sprite);
    return super.onLoad();
  }

  @override
  void onLongTick() {
    if (temperature > 0) {
      final heatables = body.contacts
          .where((e) => e.isTouching())
          .map((e) => [e.fixtureA.userData, e.fixtureB.userData])
          .expand((e) => e)
          .whereType<Heatable>()
          .where((e) => e.temperature < temperature)
          .toSet()
        ..remove(this);
      for (final h in heatables) {
        heatOther(h, heatTransferRate);
      }
    }
    super.onLongTick();
  }

  @override
  void onTemperatureChange() {
    sprite.tint(Colors.deepOrange.withOpacity(temperature.clamp(0, 4) * 0.125));
  }

  @override
  final int tempHoldTicks = 24;

  @override
  final double heatDissipationRate = .5;

  @override
  final double heatAbsorptionRate = 6.0;

  @override
  final (double, double) tempRange = (-1, 4);

  @override
  double get specularity => 0.1;

  @override
  String toString() => 'MetalBlock';
}
