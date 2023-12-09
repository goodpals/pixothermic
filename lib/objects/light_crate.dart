import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:hot_cold/models/sprites.dart';
import 'package:hot_cold/objects/static_block.dart';
import 'package:hot_cold/objects/static_sprite.dart';

class LightCrate extends BodyComponent {
  LightCrate({required Vector2 position, double size = 7.5})
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
          children: [StaticSprite(spritePath: SpritePaths.crate, size: size)],
          renderBody: false,
        );
}
