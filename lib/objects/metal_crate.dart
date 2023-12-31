import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:hot_cold/models/constants.dart';
import 'package:hot_cold/models/sprites.dart';
import 'package:hot_cold/utils/heatable.dart';
import 'package:hot_cold/utils/reflective.dart';
import 'package:hot_cold/objects/static_sprite.dart';
import 'package:hot_cold/utils/long_tick.dart';

class MetalCrate extends BodyComponent
    with LongTick, Heatable, Reflective
    implements HeatableBody {
  final StaticSprite sprite;
  final double size;

  factory MetalCrate.static({
    required Vector2 position,
    double size = unit,
  }) =>
      MetalCrate(
        position: position,
        size: size,
        isStatic: true,
      );

  MetalCrate({
    required Vector2 position,
    this.size = unit * 15 / 16,
    bool isStatic = false,
  })  : sprite = StaticSprite(
          spritePath:
              isStatic ? SpritePaths.metalFloor : SpritePaths.metalCrate,
          size: size,
        ),
        super(
          bodyDef: BodyDef(
            position: position,
            type: BodyType.dynamic,
            fixedRotation: true,
            gravityScale: Vector2(0, 2),
            gravityOverride: isStatic ? Vector2.zero() : null,
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
      // would be nice to have this but it fucks raytracing
      // FixtureDef(
      //   PolygonShape()
      //     ..set([
      //       Vector2(-size / 1.5, -size / 1.5),
      //       Vector2(-size / 1.5, size / 1.5),
      //       Vector2(size / 1.5, size / 1.5),
      //       Vector2(size / 1.5, -size / 1.5),
      //     ]),
      //   userData: this,
      //   isSensor: true,
      // ),
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
  final double heatAbsorptionRate = 4.0;

  @override
  final (double, double) tempRange = (-1, 4.5);

  @override
  double get specularity => 0.1;

  @override
  String toString() => 'MetalCrate';
}
