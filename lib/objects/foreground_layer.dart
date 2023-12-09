import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:hot_cold/models/constants.dart';
import 'package:hot_cold/models/types.dart';
import 'package:hot_cold/objects/static_block.dart';

class ForegroundLayer extends PositionComponent {
  final Map<IntVec, String> blocks;
  ForegroundLayer({Vector2? position, required this.blocks})
      : super(
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
  void render(Canvas canvas) {
    super.render(canvas);
  }
}
