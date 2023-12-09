import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/material.dart';

class WaterComponent extends RectangleComponent {
  WaterComponent(Vector2 size)
      : super(
          size: size,
          anchor: Anchor.center,
          paint: Paint()..color = Colors.lightBlue,
        );
}
