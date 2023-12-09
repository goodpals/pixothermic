import 'package:flame/collisions.dart';
import 'package:flame/src/components/position_component.dart';
import 'package:vector_math/vector_math_64.dart';

mixin PhysicsObject on CollisionCallbacks {
  Vector2 velocity = Vector2.zero();
  double gravity = 15;
  bool onGround = false;
  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
  }
}
