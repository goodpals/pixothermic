import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hot_cold/game.dart';
import 'package:hot_cold/objects/foreground_layer.dart';
import 'package:hot_cold/objects/static_block.dart';

class Player extends BodyComponent with KeyboardHandler {
  int hDir = 0;

  // Technically possible for this to be true at the apex of a jump, but w/e.
  bool get isGrounded => body.linearVelocity.y.abs() < 0.1;
  Player({required Vector2 position, double width = 4, double height = 8})
      : super(
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
              friction: 0.4,
              density: 1,
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
        Vector2(hDir * dt * (isGrounded ? 2000 : 500), 0),
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
