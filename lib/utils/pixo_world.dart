import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:hot_cold/models/types.dart';

class PixothermicWorld extends Forge2DWorld {
  final Bounds bounds;

  PixothermicWorld({
    required this.bounds,
    super.children,
    super.gravity,
    super.contactListener,
  });

  bool outOfBounds(Vector2 position) =>
      (bounds.bottom != null && position.y > bounds.bottom!) ||
      (bounds.left != null && position.x < bounds.left!) ||
      (bounds.right != null && position.x > bounds.right!) ||
      (bounds.top != null && position.y > bounds.top!);
}
