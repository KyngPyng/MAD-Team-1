import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class GoogleButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GoogleButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(58),
        backgroundColor: Colors.white.withValues(alpha: .36),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        side: BorderSide(color: Colors.white.withValues(alpha: .78)),
      ),
      onPressed: onPressed,
      icon: const Icon(
        Icons.g_mobiledata,
        color: AppColors.googleRed,
        size: 32,
      ),
      label: const Text(
        "Continue with Google",
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
