import 'dart:ui'; // Required for ImageFilter
import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class FloatingBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const FloatingBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _items = [
    (Icons.home_rounded, "Home"),
    (Icons.menu_book_rounded, "Programs"),
    (Icons.folder_rounded, "Projects"),
    (Icons.person_outline_rounded, "Profile"),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
        child: SizedBox(
          height: 82,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final totalWidth = constraints.maxWidth;
              final itemWidth = totalWidth / _items.length;

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(34),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                      child: Container(
                        height: 82,
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF1E1E1E,
                          ).withValues(alpha: 0.84),
                          borderRadius: BorderRadius.circular(34),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.08),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.24),
                              blurRadius: 30,
                              offset: const Offset(0, 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: List.generate(_items.length, (index) {
                      final selected = currentIndex == index;
                      final item = _items[index];

                      return Expanded(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(34),
                          onTap: () => onTap(index),
                          child: SizedBox(
                            height: 82,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  item.$1,
                                  color: selected
                                      ? const Color(0xFF7FB3FF)
                                      : Colors.white.withValues(alpha: 0.92),
                                  size: 30,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  item.$2,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: selected
                                        ? const Color(0xFF7FB3FF)
                                        : Colors.white.withValues(alpha: 0.92),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOutCubic,
                    left: currentIndex * itemWidth + 8,
                    top: 8,
                    bottom: 8,
                    width: itemWidth - 16,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF2D4B78,
                            ).withValues(alpha: 0.38),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: const Color(
                                0xFF7FB3FF,
                              ).withValues(alpha: 0.32),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF0B1320,
                                ).withValues(alpha: 0.22),
                                blurRadius: 18,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
