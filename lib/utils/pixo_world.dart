import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:hot_cold/models/constants.dart';
import 'package:hot_cold/models/types.dart';

class PixothermicWorld extends Forge2DWorld {
  final Bounds bounds;
  final WorldBounds worldBounds;

  PixothermicWorld({
    required this.bounds,
    super.children,
    super.gravity,
    super.contactListener,
  }) : worldBounds = (
          left: bounds.left == null ? null : bounds.left! * unit,
          right: bounds.right == null ? null : bounds.right! * unit,
          top: bounds.top == null ? null : bounds.top! * unit,
          bottom: bounds.bottom == null ? null : bounds.bottom! * unit,
        );

  bool outOfBounds(Vector2 position) =>
      (worldBounds.bottom != null && position.y > worldBounds.bottom!) ||
      (worldBounds.left != null && position.x < worldBounds.left!) ||
      (worldBounds.right != null && position.x > worldBounds.right!) ||
      (worldBounds.top != null && position.y > worldBounds.top!);

  bool outOfBoundsInt(IntVec position) => (worldBounds.bottom != null &&
          position.$2 > worldBounds.bottom! / unit ||
      worldBounds.left != null && position.$1 < worldBounds.left! / unit ||
      worldBounds.right != null && position.$1 > worldBounds.right! / unit ||
      worldBounds.top != null && position.$2 > worldBounds.top! / unit);
}
