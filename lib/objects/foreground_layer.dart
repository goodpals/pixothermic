import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:hot_cold/models/constants.dart';
import 'package:hot_cold/models/entities.dart';
import 'package:hot_cold/models/level_data.dart';
import 'package:hot_cold/models/types.dart';
import 'package:hot_cold/objects/ice_block.dart';
import 'package:hot_cold/objects/light_crate.dart';
import 'package:hot_cold/objects/static_block.dart';
import 'package:hot_cold/utils/long_tick.dart';

class ForegroundLayer extends PositionComponent with LongTick {
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
        StaticBlock(
          position: Vector2(e.key.$1 * unit, e.key.$2 * unit),
          spritePath: e.value,
        ),
      );
    }
    for (final e in level.entities.entries) {
      final entity = switch (e.value) {
        EntityType.lightCrate =>
          LightCrate(position: Vector2(e.key.$1 * unit, e.key.$2 * unit)),
        EntityType.iceBlock =>
          IceBlock(position: Vector2(e.key.$1 * unit, e.key.$2 * unit)),
        _ => throw ('ope'),
      };
      add(entity);
    }
    return super.onLoad();
  }

  // @override
  // void update(double dt) {
  //   super.update(dt);

  // }

  @override
  void onLongTick() {
    _recalculateWater();
  }

  void _recalculateWater() {
    final newWater = {...water};
    for (final w in water.entries) {
      final here = w.key;
      final below = w.key.down;
      if (!hasBlock(below)) {
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

    newWater.removeWhere((_, v) => v <= 0);
    water = newWater;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    for (final e in water.entries) {
      final rect = Rect.fromLTRB(
        e.key.$1 * unit - unit / 2,
        (e.key.$2 - e.value + 0.5) * unit,
        e.key.$1 * unit + unit / 2,
        e.key.$2 * unit + unit / 2,
      );
      canvas.drawRect(rect, _waterPaint);
    }
  }

  final _waterPaint = Paint()..color = Colors.lightBlue;
}
