import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class BackgroundWave extends StatelessWidget {
  const BackgroundWave({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          height: 180,
          width: double.infinity,
          child: CustomPaint(painter: _WavePainter()),
        ),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = AppColors.gradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    final path = Path();

    path.moveTo(0, 70);

    path.quadraticBezierTo(size.width * .25, 10, size.width * .5, 60);

    path.quadraticBezierTo(size.width * .75, 120, size.width, 40);

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}
