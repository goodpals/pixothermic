import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:hot_cold/models/constants.dart';
import 'package:hot_cold/models/sprites.dart';
import 'package:hot_cold/objects/heatable.dart';
import 'package:hot_cold/objects/static_sprite.dart';
import 'package:hot_cold/utils/long_tick.dart';

class MetalCrate extends BodyComponent with LongTick, Heatable {
  final StaticSprite sprite;
  final double size;

  MetalCrate({
    required Vector2 position,
    this.size = unit * 7 / 8,
  })  : sprite = StaticSprite(
          spritePath: SpritePaths.metalCrate,
          size: size,
          // tintColour: Colors.blue.withOpacity(0.5),
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
  final int tempHoldTicks = 40;

  @override
  final double heatDissipationRate = .2;

  @override
  final double heatAbsorptionRate = 2.0;

  @override
  final (double, double) tempRange = (-1, 4);

  @override
  String toString() => 'MetalCrate';
}
