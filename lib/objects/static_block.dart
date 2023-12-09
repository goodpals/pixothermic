import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:hot_cold/models/sprites.dart';
import 'package:hot_cold/objects/static_sprite.dart';

class StaticBlock extends BodyComponent {
  StaticBlock({required Vector2 position, double size = 8})
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
              friction: 0.5,
            ),
          ],
          bodyDef: BodyDef(
            position: position,
            type: BodyType.static,
            fixedRotation: true,
          ),
          children: [StaticSprite(spritePath: SpritePaths.brick, size: size)],
          renderBody: false,
        );
}
