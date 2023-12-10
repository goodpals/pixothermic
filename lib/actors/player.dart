import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hot_cold/models/constants.dart';
import 'package:hot_cold/objects/steam_particles.dart';
import 'package:hot_cold/utils/long_tick.dart';

const breathMax = 4;
const jumpMax = 4;

class Player extends BodyComponent
    with KeyboardHandler, ContactCallbacks, LongTick {
  int hDir = 0;
  bool submerged = false;
  int breath = breathMax;
  bool dead = false;
  int jumped = 0;

  bool get isGrounded =>
      body.contacts.any((e) =>
          e.isTouching() &&
          (e.fixtureA.userData == Flags.feet ||
              e.fixtureB.userData == Flags.feet)) ||
      body.linearVelocity.y.abs() < 0.1;

  final double width;
  final double height;
  final VoidCallback onDeath;

  Player({
    required Vector2 position,
    this.width = unit / 2,
    this.height = unit * (7 / 8),
    required this.onDeath,
  }) : super(
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
  Future<void> onLoad() {
    fixtureDefs = [
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
        density: 0.8,
        userData: this,
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
    ];
    return super.onLoad();
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (dead) return false;
    hDir = 0;

    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    hDir += isLeftKeyPressed ? -1 : 0;
    hDir += isRightKeyPressed ? 1 : 0;
    if (keysPressed.contains(LogicalKeyboardKey.space) && jumped <= 0) {
      if (isGrounded) {
        body.applyForce(Vector2(0, -60000));
        jumped = jumpMax;
      }
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

  @override
  void onLongTick() {
    if (jumped > 0) {
      jumped--;
    }
    if (submerged && !dead) {
      add(SteamParticles(position: body.position));
      breath--;
      if (breath <= 0) {
        dead = true;
        onDeath();
      }
    } else {
      breath = min(breath + 1, breathMax);
    }
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
