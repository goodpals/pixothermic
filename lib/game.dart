// ignore_for_file: unused_local_variable

import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart' hide Route, DragTarget;
import 'package:hot_cold/actors/player.dart';
import 'package:hot_cold/models/constants.dart';
import 'package:hot_cold/models/level_data.dart';
import 'package:hot_cold/models/sprites.dart';
import 'package:hot_cold/objects/end_portal.dart';
import 'package:hot_cold/objects/foreground_layer.dart';
import 'package:hot_cold/utils/heatable.dart';
import 'package:hot_cold/utils/reflective.dart';

class GameClass extends Forge2DGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  final VoidCallback? onWin;
  final LevelData level;
  GameClass(this.level, {this.onWin});

  late double sunAngle = level.sunAngle.toDouble();
  late double sunHeight = level.sunHeight.toDouble();
  double timeElapsed = 0;

  bool dragging = false;
  bool enableSun = true;
  bool lockCamera = true;

  late final (int, int) hConstraints = level.horizontalConstraints;
  double rayDensity = 50;

  @override
  Color backgroundColor() => Colors.transparent;
  late final CameraComponent cam;
  late Player player;
  late EndPortal portal;
  late ForegroundLayer foregroundLayer;

  List<(Vector2, Vector2, double)> light = [];
  Set<Heatable> heatables = {};

  @override
  FutureOr<void> onLoad() async {
    await images.loadAll([...SpritePaths.all]);
    super.onLoad();

    // cam = CameraComponent(world: world)..viewfinder.anchor = Anchor.topLeft;
    // addAll([cam, world]);
    camera.viewfinder.zoom = 5;
    camera.viewfinder.anchor = Anchor.center;

    player = Player(
      position: Vector2(level.spawn.$1 * unit, level.spawn.$2 * unit),
      onDeath: _onLost,
    );
    portal = EndPortal(
      position: Vector2(level.goal.$1 * unit, level.goal.$2 * unit),
      onWin: _onWin,
    );
    foregroundLayer = ForegroundLayer(level: level, player: player);
    world.add(foregroundLayer);
    world.add(player);
    world.add(portal);
    world.add(
        FpsTextComponent(anchor: Anchor.topRight, scale: Vector2(0.1, 0.1)));
  }

  @override
  void update(double dt) {
    timeElapsed += dt;
    // sunAngle = 200 * sin(timeElapsed);
    if (enableSun) {
      _praiseTheSun();
      for (final h in heatables) {
        h.heat(dt * heatTransferRate * h.heatAbsorptionRate);
      }
    }
    if (player.isLoaded && lockCamera) {
      camera.moveTo(player.position);
    }
    super.update(dt);
  }

  void _onWin() {
    onWin?.call();
    overlays.add('WonDialog');
  }

  void _onLost() {
    overlays.add('LostDialog');
  }

  late final List<Paint> _lightPaints = _buildLightPaints(level.sunColour);

  List<Paint> _buildLightPaints(Color colour) => List.generate(
      10, (i) => Paint()..color = colour.withOpacity((i + 1) / 20));

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final st = DateTime.now().microsecondsSinceEpoch;
    for (final e in light) {
      canvas.drawLine(
        worldToScreen(e.$1).toOffset(),
        worldToScreen(e.$2).toOffset(),
        _lightPaints[(e.$3 * 10 - 1).floor().clamp(0, 9)],
      );
    }
    final et = DateTime.now().microsecondsSinceEpoch;
    // print('Time: ${et - st}micros');
  }

  void _praiseTheSun() {
    final width = hConstraints.$2 - hConstraints.$1 + sunAngle.abs();
    final raySpacing = unit / rayDensity;

    final st = DateTime.now().microsecondsSinceEpoch;
    final nRays = (width * unit * rayDensity).ceil();
    // print('nRays: $nRays, width: $width, $hConstraints');
    final xPoints = List.generate(
        nRays, (i) => (i - nRays / 2) * raySpacing + hConstraints.$1);
    final results = xPoints
        .map((e) => _castRay(
              Vector2(e, -sunHeight),
              Vector2(e + sunAngle, sunHeight),
            ))
        .expand((e) => e)
        .toList();
    light = results.map((e) => e.$1).toList();
    heatables = results
        .where((e) => e.$1.$3 >= lightHeatThresold)
        .map((e) => e.$2)
        .whereType<Heatable>()
        .toSet();

    final et = DateTime.now().microsecondsSinceEpoch;
    // print('Time: ${et - st}micros');
  }

  List<((Vector2, Vector2, double), Object?)> _castRay(
    Vector2 start,
    Vector2 end, [
    double level = 1.0,
  ]) {
    final output = NearestBoxRayCastCallback();
    world.raycast(output, start, end);
    if (output.nearestPoint == null) {
      return [];
    }
    if (output.data is Reflective && level > lightReflectionCutoff) {
      final reflection = end - start;
      reflection.reflect(output.normalAtInter!);
      return [
        ((start, output.nearestPoint!, level), output.data),
        ..._castRay(output.nearestPoint!, output.nearestPoint! + reflection,
            level * (output.data as Reflective).specularity),
      ];
    }
    return [((start, output.nearestPoint!, level), output.data)];
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
    // if (!fixture.isSensor) {
    nearestPoint = point.clone();
    normalAtInter = normal.clone();
    data = fixture.userData;
    // }

    // Returning fraction implies that we care only about
    // fixtures that are closer to ray start point than
    // the current fixture
    return fraction;
  }
}
