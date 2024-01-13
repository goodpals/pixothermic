import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:hot_cold/models/constants.dart';
import 'package:hot_cold/objects/static_sprite.dart';

class StaticBlock extends BodyComponent {
  final String spritePath;
  final double size;

  StaticBlock({
    required Vector2 position,
    required this.spritePath,
    this.size = unit,
  }) : super(
          bodyDef: BodyDef(
            position: position,
            type: BodyType.static,
            fixedRotation: true,
          ),
          children: [StaticSprite(spritePath: spritePath, size: size)],
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
        friction: 0.5,
        userData: this,
      ),
    ];
    return super.onLoad();
  }
}
