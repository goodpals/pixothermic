import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:hot_cold/models/constants.dart';
import 'package:hot_cold/models/sprites.dart';
import 'package:hot_cold/objects/static_sprite.dart';

class HeavyCrate extends BodyComponent {
  HeavyCrate({required Vector2 position, double size = unit * 31 / 32})
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
              density: 2.5,
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
              spritePath: SpritePaths.heavyCrate,
              size: size,
            ),
          ],
          renderBody: false,
        );
}
