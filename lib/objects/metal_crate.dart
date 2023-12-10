import 'package:flame_forge2d/flame_forge2d.dart';
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
    this.size = unit * 31 / 32,
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
    return super.onLoad();
  }

  @override
  void onTemperatureChange() {
    // TODO: implement onTemperatureChange
    // also, sprite isn't showing - looks like only the shadow is showing
    // sprite.tint(Colors.red.withOpacity((1 - temperature).clamp(0, 1) * 0.5));
  }

  // @override
  // double accTime;
}
