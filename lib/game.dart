import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart' hide Route, DragTarget;
import 'package:hot_cold/actors/player.dart';
import 'package:hot_cold/models/constants.dart';
import 'package:hot_cold/models/level_data.dart';
import 'package:hot_cold/models/sprites.dart';
import 'package:hot_cold/objects/foreground_layer.dart';
import 'package:hot_cold/objects/heatable.dart';

class GameClass extends Forge2DGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  late final RouterComponent router;

  static const double sunHeight = 200;
  double sunAngle = 0;
  double timeElapsed = 0;

  bool dragging = false;

  @override
  Color backgroundColor() => Colors.blueGrey;
  late final CameraComponent cam;
  late Player player;
  late ForegroundLayer foregroundLayer;

  List<(Vector2, Vector2)> light = [];
  Set<Heatable> heatables = {};

  @override
  FutureOr<void> onLoad() async {
    await images
        .loadAll([SpritePaths.brick, SpritePaths.crate, SpritePaths.iceblock]);
    super.onLoad();

    final level = testLevel();

    // cam = CameraComponent(world: world)..viewfinder.anchor = Anchor.topLeft;
    // addAll([cam, world]);
    camera.viewfinder.zoom = 5;
    camera.viewfinder.anchor = Anchor.center;

    player =
        Player(position: Vector2(level.spawn.$1 * unit, level.spawn.$2 * unit));
    foregroundLayer = ForegroundLayer(level: level);
    world.add(foregroundLayer);
    world.add(player);
    world.add(
        FpsTextComponent(anchor: Anchor.topRight, scale: Vector2(0.1, 0.1)));
  }

  @override
  void update(double dt) {
    timeElapsed += dt;
    // sunAngle = 200 * sin(timeElapsed);
    _praiseTheSun();
    for (final h in heatables) {
      h.heat(dt * heatTransferRate);
    }
    // camera.moveBy(Vector2(0, 0.1));
    if (player.isLoaded) {
      camera.moveTo(player.position);
    }
    super.update(dt);
  }

  final _lightPaint = Paint()
    ..color = Colors.yellow.shade100.withOpacity(0.1)
    ..strokeWidth = 1;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final st = DateTime.now().microsecondsSinceEpoch;
    for (final e in light) {
      canvas.drawLine(
        worldToScreen(e.$1).toOffset(),
        worldToScreen(e.$2).toOffset(),
        _lightPaint,
      );
    }
    final et = DateTime.now().microsecondsSinceEpoch;
    // print('Time: ${et - st}micros');
  }

  void _praiseTheSun() {
    final st = DateTime.now().microsecondsSinceEpoch;
    const nRays = 2000;
    final xPoints = List.generate(nRays, (i) => (i - nRays / 2) * 0.02 * unit);
    final results = xPoints
        .map((e) =>
            _castRay(Vector2(e, -sunHeight), Vector2(e + sunAngle, sunHeight)))
        .nonNulls
        .toList();
    light = results.map((e) => e.$1).toList();
    heatables = results.map((e) => e.$2).whereType<Heatable>().toSet();

    final et = DateTime.now().microsecondsSinceEpoch;
    // print('Time: ${et - st}micros');
  }

  ((Vector2, Vector2), Object?)? _castRay(Vector2 start, Vector2 end) {
    final output = NearestBoxRayCastCallback();
    world.raycast(output, start, end);
    if (output.nearestPoint == null) {
      return null;
    }
    return ((start, output.nearestPoint!), output.data);
  }
}

class NearestBoxRayCastCallback extends RayCastCallback {
  Vector2? nearestPoint;
  Vector2? normalAtInter;
  Object? data;

  @override
  double reportFixture(
    Fixture fixture,
    Vector2 point,
    Vector2 normal,
    double fraction,
  ) {
    nearestPoint = point.clone();
    normalAtInter = normal.clone();
    data = fixture.userData;

    // Returning fraction implies that we care only about
    // fixtures that are closer to ray start point than
    // the current fixture
    return fraction;
  }
}
