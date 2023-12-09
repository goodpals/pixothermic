import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:hot_cold/models/constants.dart';
import 'package:hot_cold/models/sprites.dart';
import 'package:hot_cold/objects/heatable.dart';
import 'package:hot_cold/objects/static_sprite.dart';
import 'package:hot_cold/utils/long_tick.dart';

class IceBlock extends BodyComponent with LongTick, Heatable {
  IceBlock({required Vector2 position, double size = unit * 15 / 16})
      : super(
          fixtureDefs: [
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
            ),
          ],
          bodyDef: BodyDef(
            position: position,
            type: BodyType.dynamic,
            fixedRotation: true,
            gravityScale: Vector2(0, 2),
          ),
          children: [
            StaticSprite(
              spritePath: SpritePaths.crate,
              size: size,
              tintColour: Colors.blue.withOpacity(0.5),
            )
          ],
          renderBody: false,
        );
}
