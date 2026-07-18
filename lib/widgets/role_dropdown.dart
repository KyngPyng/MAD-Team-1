import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class RoleDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;

  const RoleDropdown({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .38),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: .75)),
      ),
      child: DropdownButtonFormField<String>(
        initialValue: value,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.person_outline, color: AppColors.primary),
          fillColor: Colors.transparent,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        borderRadius: BorderRadius.circular(18),
        items: const [
          DropdownMenuItem(value: "Student", child: Text("Student")),
          DropdownMenuItem(value: "Mentor", child: Text("Mentor")),
          DropdownMenuItem(value: "Admin", child: Text("Admin")),
        ],
        onChanged: onChanged,
      ),
    );
  }
}
