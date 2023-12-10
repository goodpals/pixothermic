import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hot_cold/models/constants.dart';

class Player extends BodyComponent with KeyboardHandler {
  int hDir = 0;

  bool get isGrounded => body.contacts.any((e) =>
      e.isTouching() &&
      (e.fixtureA.userData == Flags.feet || e.fixtureB.userData == Flags.feet));

  Player({
    required Vector2 position,
    double width = unit / 2,
    double height = unit * (7 / 8),
  }) : super(
          fixtureDefs: [
            FixtureDef(
              PolygonShape()
                ..set([
                  Vector2(-width / 2, -height / 2),
                  Vector2(-width / 2, height / 2),
                  Vector2(width / 2, height / 2),
                  Vector2(width / 2, -height / 2),
                ]),
              // restitution: 0.8,
              friction: 0.2,
              density: 1,
            ),
            FixtureDef(
              PolygonShape()
                ..set([
                  Vector2(-1, height / 2),
                  Vector2(1, height / 2),
                  Vector2(1, height / 2 + 0.5),
                  Vector2(-1, height / 2 + 0.5),
                ]),
              isSensor: true,
              userData: Flags.feet,
            ),
          ],
          bodyDef: BodyDef(
            position: position,
            type: BodyType.dynamic,
            fixedRotation: true,
            gravityScale: Vector2(1, 4),
            linearDamping: 0.2,
          ),
          children: [PlayerImage(Vector2(width, height))],
          renderBody: false,
        );

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    // if (event is RawKeyDownEvent) {
    //   if (event.data.logicalKey == LogicalKeyboardKey.space) {
    //     if (isGrounded) body.applyForce(Vector2(0, -50000));
    //     return false;
    //   }
    // }
    hDir = 0;

    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    hDir += isLeftKeyPressed ? -1 : 0;
    hDir += isRightKeyPressed ? 1 : 0;
    if (keysPressed.contains(LogicalKeyboardKey.space)) {
      if (isGrounded) body.applyForce(Vector2(0, -60000));
    }
    return false;
  }

  @override
  void update(double dt) {
    if (hDir != 0) {
      body.applyLinearImpulse(
        Vector2(hDir * dt * (isGrounded ? 2000 : 200), 0),
      );
    }
    super.update(dt);
  }
}

class PlayerImage extends RectangleComponent {
  PlayerImage(Vector2 size)
      : super(
          size: size,
          anchor: Anchor.center,
          paint: Paint()..color = Colors.deepOrange,
        );
}
