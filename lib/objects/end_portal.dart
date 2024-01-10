import 'dart:ui';

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:hot_cold/actors/player.dart';
import 'package:hot_cold/models/constants.dart';
import 'package:hot_cold/objects/portal_particles.dart';
import 'package:hot_cold/utils/long_tick.dart';

class EndPortal extends BodyComponent with LongTick, ContactCallbacks {
  final double size;
  final VoidCallback onWin;

  bool hasWon = false;

  EndPortal({
    required Vector2 position,
    this.size = unit * 0.8,
    required this.onWin,
  }) : super(
          bodyDef: BodyDef(
            position: position,
            type: BodyType.static,
            fixedRotation: true,
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
        isSensor: true,
        userData: this,
      ),
    ];
    return super.onLoad();
  }

  @override
  void onLongTick() {
    add(PortalParticles());
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (hasWon) return;
    if (other is Player) {
      onWin();
    }
  }
}
