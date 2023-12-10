import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:hot_cold/models/constants.dart';
import 'package:hot_cold/utils/reflective.dart';

class Mirror extends BodyComponent with Reflective {
  final double size;
  Mirror({required Vector2 position, this.size = unit})
      : super(
          bodyDef: BodyDef(
            position: position,
            type: BodyType.dynamic,
            fixedRotation: true,
          ),
          renderBody: true,
        );

  @override
  Future<void> onLoad() {
    fixtureDefs = [
      FixtureDef(
        PolygonShape()
          ..set([
            Vector2(0, -size / 2),
            Vector2(size / 2, size / 2),
            Vector2(-size / 2, size / 2),
          ]),
        friction: 0.8,
        density: 0.4,
        userData: this,
      ),
    ];
    return super.onLoad();
  }
}
