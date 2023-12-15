import 'package:flame/components.dart';
import 'package:flame/particles.dart' as pt;
// ignore: implementation_imports
import 'package:flame/src/particles/scaling_particle.dart';
import 'package:flutter/material.dart';
import 'package:hot_cold/models/constants.dart';
import 'package:hot_cold/objects/steam_particles.dart';

import 'dart:math';

final _portalPaints = [
  Paint()..color = Colors.yellow.withOpacity(0.5),
  Paint()..color = Colors.red.withOpacity(0.5),
  Paint()..color = Colors.blue.withOpacity(0.5),
  Paint()..color = Colors.green.withOpacity(0.5),
];

Vector2 randomCircleVector2(double radius) {
  final angle = rnd.nextDouble() * 2 * pi;
  return Vector2(cos(angle), sin(angle)) * radius;
}

class PortalParticles extends ParticleSystemComponent {
  PortalParticles({Vector2? position})
      : super(
          position: (position ?? Vector2.zero()),
          particle: pt.Particle.generate(
              count: 50,
              generator: (i) {
                final vec = randomCircleVector2(unit / 2);
                return ScalingParticle(
                  child: pt.AcceleratedParticle(
                    position: vec,
                    child: pt.CircleParticle(
                      paint: _portalPaints[i % _portalPaints.length],
                      radius: 0.5,
                      lifespan: 50,
                    ),
                    lifespan: 50,
                    acceleration: vec * 4,
                  ),
                  lifespan: 2,
                  to: 0,
                );
              },),
        );
}
