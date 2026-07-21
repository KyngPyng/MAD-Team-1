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
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
        child: Container(
          height: 76,
          decoration: BoxDecoration(
            // Semi-transparent white background
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 25,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          // ClipRRect ensures the blur effect stays contained within the rounded corners
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final totalWidth = constraints.maxWidth;
                  final itemWidth = totalWidth / _items.length;

                  return Stack(
                    children: [
                      // The Sliding Purple Pill Background
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOutCubic,
                        left: currentIndex * itemWidth + 8,
                        top: 8,
                        bottom: 8,
                        width: itemWidth - 16,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: AppColors.gradient,
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),

                      // The Interactive Text and Icons
                      Row(
                        children: List.generate(_items.length, (index) {
                          final selected = currentIndex == index;
                          final item = _items[index];

                          return Expanded(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(40),
                              onTap: () => onTap(index),
                              child: Container(
                                margin: const EdgeInsets.all(8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AnimatedDefaultTextStyle(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      style: TextStyle(
                                        color: selected
                                            ? Colors.white
                                            : Colors.grey,
                                      ),
                                      child: Icon(
                                        item.$1,
                                        color: selected
                                            ? Colors.white
                                            : Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.$2,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: selected
                                            ? Colors.white
                                            : Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
