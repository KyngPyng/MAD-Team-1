import 'package:flutter/material.dart';

class LogoCard extends StatelessWidget {
  final double size;
  final EdgeInsets padding;

  const LogoCard({
    super.key,
    this.size = 110,
    this.padding = const EdgeInsets.all(18),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .66),
        borderRadius: BorderRadius.circular(size * 0.25),
        border: Border.all(color: Colors.white.withValues(alpha: .85)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: padding,
        child: Image.asset(
          "assets/images/teamsync_logo.png",
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
