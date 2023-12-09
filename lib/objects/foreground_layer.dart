import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:hot_cold/models/constants.dart';
import 'package:hot_cold/models/types.dart';
import 'package:hot_cold/objects/static_block.dart';

class ForegroundLayer extends PositionComponent {
  final Map<IntVec, String> blocks;
  Map<IntVec, double> water;

  double accTime = 0;

  bool hasBlock(IntVec pos) => blocks.containsKey(pos);

  ForegroundLayer({
    Vector2? position,
    required this.blocks,
    this.water = const {},
  }) : super(
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
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    accTime += dt;
    while (accTime > longTick) {
      _recalculateWater();
      accTime -= longTick;
    }
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
          newWater[here] = max(w.value - newWater[below]!, 0);
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
        (e.key.$2 - e.value) * unit,
        e.key.$1 * unit + unit / 2,
        e.key.$2 * unit + unit / 2,
      );
      canvas.drawRect(rect, _waterPaint);
    }
  }

  final _waterPaint = Paint()..color = Colors.lightBlue;
}
