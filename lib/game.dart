import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:hot_cold/actors/player.dart';
import 'package:hot_cold/objects/foreground_layer.dart';
import 'package:hot_cold/objects/light_crate.dart';
import 'package:hot_cold/objects/static_block.dart';

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
    await images.loadAll(['blocks/brick.png', 'blocks/crate.png']);
    super.onLoad();

    final visibleRect = camera.visibleWorldRect;
    final topLeft = visibleRect.topLeft.toVector2();
    final topRight = visibleRect.topRight.toVector2();
    final bottomRight = visibleRect.bottomRight.toVector2();
    final bottomLeft = visibleRect.bottomLeft.toVector2();
    print(
        'topLeft: $topLeft, topRight: $topRight, bottomRight: $bottomRight, bottomLeft: $bottomLeft');

    // cam = CameraComponent(world: world)..viewfinder.anchor = Anchor.topLeft;
    // addAll([cam, world]);
    camera.viewfinder.zoom = 5;
    player = Player(position: Vector2(8, 12));
    final blocks = [
      (0, 0),
      (-7, 4),
      ...List.generate(10, (i) => (i - 5, 4)),
      (4, 6),
      (2, 3),
    ];
    foregroundLayer = ForegroundLayer(position: Vector2(8, 8), blocks: blocks);
    // world.add(foregroundLayer);
    for (final b in blocks) {
      world.add(StaticBlock(position: Vector2(b.$1 * 8, b.$2 * 8)));
    }
    world.add(player);
    world.add(LightCrate(position: Vector2(0, 12)));
  }
}
