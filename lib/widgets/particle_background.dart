import 'package:flutter/material.dart';

class ParticleBackground extends StatelessWidget {
  const ParticleBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: const [
          _Particle(top: 70, left: 35, size: 12),
          _Particle(top: 110, right: 50, size: 18),
          _Particle(top: 250, left: 20, size: 10),
          _Particle(top: 320, right: 30, size: 16),
          _Particle(bottom: 180, left: 50, size: 14),
          _Particle(bottom: 230, right: 40, size: 20),
        ],
      ),
    );
  }
}

class _Particle extends StatelessWidget {
  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
  final double size;

  const _Particle({
    this.top,
    this.left,
    this.right,
    this.bottom,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .55),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
