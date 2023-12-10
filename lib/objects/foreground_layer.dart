import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:hot_cold/game.dart';
import 'package:hot_cold/models/constants.dart';
import 'package:hot_cold/models/entities.dart';
import 'package:hot_cold/models/level_data.dart';
import 'package:hot_cold/models/sprites.dart';
import 'package:hot_cold/models/types.dart';
import 'package:hot_cold/objects/heatable_static_block.dart';
import 'package:hot_cold/objects/steam_particles.dart';
import 'package:hot_cold/utils/buoyant.dart';
import 'package:hot_cold/objects/heavy_crate.dart';
import 'package:hot_cold/objects/ice_block.dart';
import 'package:hot_cold/objects/light_crate.dart';
import 'package:hot_cold/objects/metal_crate.dart';
import 'package:hot_cold/objects/mirror.dart';
import 'package:hot_cold/objects/static_block.dart';
import 'package:hot_cold/utils/heatable.dart';
import 'package:hot_cold/utils/long_tick.dart';

class ForegroundLayer extends PositionComponent
    with LongTick, HasGameRef<GameClass> {
  final LevelData level;

  Map<IntVec, String> blocks;
  Map<IntVec, double> water;

  bool hasBlock(IntVec pos) => blocks.containsKey(pos);

  ForegroundLayer({
    Vector2? position,
    required this.level,
  })  : blocks = {...level.foreground},
        water = {...level.water},
        super(
          position: position,
          anchor: Anchor.bottomLeft,
        );

  @override
  FutureOr<void> onLoad() {
    for (final e in blocks.entries) {
      add(
        switch (e.value) {
          SpritePaths.metalFloor => HeatableStaticBlock(
              position: Vector2(e.key.$1 * unit, e.key.$2 * unit),
            ),
          String sprite => StaticBlock(
              position: Vector2(e.key.$1 * unit, e.key.$2 * unit),
              spritePath: sprite,
            ),
        },
      );
    }
    for (final e in level.entities.entries) {
      final pos = Vector2(e.key.$1 * unit, e.key.$2 * unit);
      final entity = switch (e.value) {
        EntityType.lightCrate => LightCrate(position: pos),
        EntityType.heavyCrate => HeavyCrate(position: pos),
        EntityType.metalCrate => MetalCrate(position: pos),
        EntityType.iceBlock => IceBlock(position: pos, onMelt: meltIce),
        EntityType.mirror => Mirror(position: pos),
        _ => throw UnimplementedError(),
      };
      add(entity);
    }
    return super.onLoad();
  }

  void meltIce(IceBlock ice) {
    add(SteamParticles(position: ice.body.position));
    remove(ice);
    final pos = (
      (ice.body.position.x / unit).round(),
      (ice.body.position.y / unit).round()
    );
    water[pos] = (water[pos] ?? 0) + 1;
  }

  // @override
  // void update(double dt) {
  //   super.update(dt);

  // }

  @override
  void onLongTick() {
    final crates = children.whereType<Buoyant>();
    final hotBlocks = children
        .whereType<HeatableBody>()
        .where((e) => e.temperature > 0 && e.body.gravityOverride == null);
    _buoyCrates(crates);
    _recalculateWater(hotBlocks);
  }

  void _buoyCrates(Iterable<Buoyant> crates) {
    for (final crate in crates) {
      final pos = (
        (crate.body.position.x / unit).round(),
        (crate.body.position.y / unit).round()
      );

      final fraction = crate.body.position.y % unit;

      if (water[pos] != null && fraction < water[pos]! * unit) {
        crate.body.gravityScale = Vector2(0, 1);
        if (crate.body.linearVelocity.y > -1) {
          crate.body.applyForce(Vector2(0, -20000));
        }
      } else {
        crate.body.gravityScale = Vector2(0, 1);
      }
    }
  }

  void _recalculateWater(Iterable<HeatableBody> hotBlocks) {
    final newWater = {...water};
    for (final w in water.entries) {
      final here = w.key;
      final below = w.key.down;
      if ((!hasBlock(below) || SpritePaths.isPermeable(blocks[below]!))) {
        final belowAmt = newWater[below] ?? 0;
        if (belowAmt < 1) {
          newWater[below] = min(belowAmt + w.value, 1);
          newWater[here] = max(w.value - (newWater[below]! - belowAmt), 0);
          continue;
        }
      }
      final clearLeft = !hasBlock(here.left);
      final clearRight = !hasBlock(here.right);
      if (clearLeft) {
        final leftAmt = newWater[here.left] ?? 0;
        if (newWater[here]! > waterSubdivision &&
            (newWater[here]! - leftAmt) >= waterSubdivision) {
          newWater[here.left] = leftAmt + waterSubdivision;
          newWater[here] = newWater[here]! - waterSubdivision;
        }
      }
      if (clearRight) {
        final rightAmt = newWater[here.right] ?? 0;
        if (newWater[here]! > waterSubdivision &&
            (newWater[here]! - rightAmt) >= waterSubdivision) {
          newWater[here.right] = rightAmt + waterSubdivision;
          newWater[here] = newWater[here]! - waterSubdivision;
        }
      }
    }

    for (final h in hotBlocks) {
      final pos = (
        (h.body.position.x / unit).round(),
        (h.body.position.y / unit).round()
      );
      if (newWater[pos] != null) {
        newWater[pos] = (newWater[pos]! - waterSubdivision).clamp(0, 2);
        h.cool(waterSubdivision, lock: false);
        add(SteamParticles(position: h.body.position));
      }
      // heat block above
      final up = pos.up;
      if (newWater[up] != null) {
        newWater[up] = (newWater[up]! - waterSubdivision).clamp(0, 2);
        h.cool(waterSubdivision, lock: false);
        add(SteamParticles(position: h.body.position));
      }
    }

    newWater.removeWhere((_, v) => v <= 0);
    water = newWater;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    for (final e in water.entries) {
      final depth = e.value.clamp(0, 1);
      final rect = Rect.fromLTRB(
        e.key.$1 * unit - unit / 2,
        (e.key.$2 - depth + 0.5) * unit,
        e.key.$1 * unit + unit / 2,
        e.key.$2 * unit + unit / 2,
      );
      canvas.drawRect(rect, _waterPaint);
    }
  }

  late final _waterPaint = Paint()..color = level.waterColour;
}
