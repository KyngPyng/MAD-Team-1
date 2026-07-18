import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../models/program_model.dart';

class ProgramCard extends StatelessWidget {
  final ProgramModel program;
  final VoidCallback? onTap;

  const ProgramCard({super.key, required this.program, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .06),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              child: Image.asset(
                program.image,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  height: 180,
                  color: AppColors.primary.withValues(alpha: .12),
                  alignment: Alignment.center,
                  child: const Icon(Icons.menu_book_rounded, size: 56),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    program.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "${program.level} • ${program.duration}",
                    style: TextStyle(color: Colors.grey.shade700),
                  ),

                  const SizedBox(height: 16),

                  if (program.isEnrolled) ...[
                    LinearProgressIndicator(
                      value: program.progress,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(30),
                      backgroundColor: Colors.grey.shade200,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${(program.progress * 100).round()}% Completed",
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ] else
                    Text(
                      'Open for enrollment',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),

                      const SizedBox(width: 4),

                      Text(program.rating.toString()),

                      const Spacer(),

                      const Icon(Icons.people_alt_outlined, size: 20),

                      const SizedBox(width: 6),

                      Text("${program.students}"),
                    ],
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: onTap,
                      child: Text(
                        program.isEnrolled ? 'Continue Learning' : 'Enroll Now',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
