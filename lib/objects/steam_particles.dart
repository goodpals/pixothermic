import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/particles.dart' as pt;
import 'package:flutter/material.dart';
import 'package:hot_cold/models/constants.dart';

Random rnd = Random();
Vector2 randomVector2() => (Vector2.random(rnd) - Vector2.random(rnd)) * 200;
Vector2 randomUpwardsVector2() =>
    Vector2((rnd.nextDouble() - .5) * 10, rnd.nextDouble() * -30);

class SteamParticles extends ParticleSystemComponent {
  SteamParticles({Vector2? position})
      : super(
          position: (position ?? Vector2.zero()),
          particle: pt.Particle.generate(
            count: 50,
            generator: (i) => pt.AcceleratedParticle(
              position: (Vector2.random() - Vector2(.5, .5)) * unit,
              child: pt.CircleParticle(
                paint: Paint()..color = Colors.white24,
                radius: 0.2,
                lifespan: 2,
              ),
              acceleration: randomUpwardsVector2(),
            ),
          ),
        );
}
