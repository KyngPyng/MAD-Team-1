import 'package:flutter/material.dart';

import '../core/theme/text_styles.dart';

class GreetingSection extends StatelessWidget {
  final String name;

  const GreetingSection({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Hello, $name 👋",
          style: AppTextStyles.heading.copyWith(fontSize: 30),
        ),

        const SizedBox(height: 8),

        Text(
          "Welcome back to teamSync.\nLet's make today productive.",
          style: AppTextStyles.subtitle.copyWith(height: 1.5),
        ),
      ],
    );
  }
}
