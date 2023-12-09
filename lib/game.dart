import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:hot_cold/actors/player.dart';
import 'package:hot_cold/models/constants.dart';
import 'package:hot_cold/models/level_data.dart';
import 'package:hot_cold/models/sprites.dart';
import 'package:hot_cold/objects/foreground_layer.dart';

class GameClass extends Forge2DGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  late final RouterComponent router;

  @override
  Color backgroundColor() => Colors.blueGrey;
  late final CameraComponent cam;
  late Player player;
  late ForegroundLayer foregroundLayer;

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
  }
}
