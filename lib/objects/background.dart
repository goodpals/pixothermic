import 'package:flame/components.dart';
import 'package:flame/flame.dart';

class Background extends SpriteComponent {
  Background();

  @override
  Future<void> onLoad() async {
    final background =
        await Flame.images.load('backgrounds/cave_background_one.jpg');
    size = Vector2(360, 219);
    anchor = Anchor.topLeft;
    sprite = Sprite(background);
  }
}
