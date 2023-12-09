import 'dart:async';

import 'package:flame/components.dart';
import 'package:hot_cold/objects/static_block.dart';

class ForegroundLayer extends PositionComponent {
  final List<(int, int)> blocks;
  ForegroundLayer({required Vector2 position, required this.blocks})
      : super(
          position: position,
          anchor: Anchor.bottomLeft,
        );

  @override
  FutureOr<void> onLoad() {
    for (final b in blocks) {
      add(StaticBlock(position: Vector2(b.$1 * 64, b.$2 * 64)));
    }
    return super.onLoad();
  }
}
