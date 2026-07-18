import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final String hintText;

  const SearchBarWidget({
    super.key,
    this.hintText = 'Search programs and projects...',
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
