import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _iconButton(Icons.menu_rounded),

        const Spacer(),

        const Text(
          "teamSync",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),

        const Spacer(),

        Stack(
          children: [
            _iconButton(Icons.notifications_none_rounded),

            Positioned(
              right: 14,
              top: 12,
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(width: 12),

        const CircleAvatar(radius: 23, child: Icon(Icons.person_rounded)),
      ],
    );
  }

  Widget _iconButton(IconData icon) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .08),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Icon(icon, color: AppColors.textPrimary),
    );
  }
}
