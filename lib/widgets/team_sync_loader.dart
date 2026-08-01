import 'dart:math' as math;
import 'package:flutter/material.dart';

class TeamSyncLoader extends StatefulWidget {
  final double size;
  final Color? color;
  final double strokeWidth;

  const TeamSyncLoader({
    super.key,
    this.size = 24.0,
    this.color,
    this.strokeWidth = 2.5,
  });

  @override
  State<TeamSyncLoader> createState() => _TeamSyncLoaderState();
}

class _TeamSyncLoaderState extends State<TeamSyncLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000), // Time for full shape cycle
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = widget.color ?? Colors.white;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.rotate(
            // Smooth slow spin while shape morphs
            angle: _controller.value * 2 * math.pi,
            child: CustomPaint(
              painter: _ShapeMorphPainter(
                progress: _controller.value,
                color: activeColor,
                strokeWidth: widget.strokeWidth,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ShapeMorphPainter extends CustomPainter {
  final double progress; // 0.0 to 1.0
  final Color color;
  final double strokeWidth;

  _ShapeMorphPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.width - strokeWidth) / 2;

    // Standardize to 6 points so all 3 shapes interpolate cleanly point-by-point
    final List<Offset> points = [];

    // Stage breakdown:
    // 0.0 - 0.33 : Hexagon -> Circle
    // 0.33 - 0.66: Circle -> Triangle
    // 0.66 - 1.0 : Triangle -> Hexagon

    for (int i = 0; i < 6; i++) {
      final angle = (i * 60) * (math.pi / 180) - (math.pi / 2);

      // 1. Hexagon point location
      final hexPos = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );

      // 2. Circle point location
      final circlePos = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );

      // 3. Triangle point location (maps 6 points to 3 sharp vertices)
      final triVertexIndex = (i / 2).floor(); // 0, 1, or 2
      final triAngle = (triVertexIndex * 120) * (math.pi / 180) - (math.pi / 2);
      final triPos = Offset(
        center.dx + radius * math.cos(triAngle),
        center.dy + radius * math.sin(triAngle),
      );

      Offset currentPoint;

      if (progress < 0.333) {
        // Morph Hexagon -> Circle
        final t = progress / 0.333;
        currentPoint = Offset.lerp(hexPos, circlePos, t)!;
      } else if (progress < 0.666) {
        // Morph Circle -> Triangle
        final t = (progress - 0.333) / 0.333;
        currentPoint = Offset.lerp(circlePos, triPos, t)!;
      } else {
        // Morph Triangle -> Hexagon
        final t = (progress - 0.666) / 0.333;
        currentPoint = Offset.lerp(triPos, hexPos, t)!;
      }

      points.add(currentPoint);
    }

    final path = Path()..moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    path.close();

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ShapeMorphPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}