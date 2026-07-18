import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../data/program_dummy_data.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/program_card.dart';
import 'program_details_page.dart';

class ProgramsPage extends StatefulWidget {
  const ProgramsPage({super.key});

  @override
  State<ProgramsPage> createState() => _ProgramsPageState();
}

class _ProgramsPageState extends State<ProgramsPage> {
  int selectedCategory = 0;
  String query = '';

  final List<String> categories = const [
    "All",
    "Flutter",
    "AI",
    "Design",
    "Cloud",
  ];

  @override
  Widget build(BuildContext context) {
    final visiblePrograms = programs.where((program) {
      final matchesCategory =
          selectedCategory == 0 ||
          program.category == categories[selectedCategory];
      final normalizedQuery = query.toLowerCase();
      final matchesQuery =
          normalizedQuery.isEmpty ||
          program.title.toLowerCase().contains(normalizedQuery) ||
          program.category.toLowerCase().contains(normalizedQuery);
      return matchesCategory && matchesQuery;
    });

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Programs",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
          ),
        ],
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 10, 24, 30),
          children: [
            Text(
              "Find Your Next Program",
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            Text(
              "Continue learning and improve your skills.",
              style: TextStyle(color: Colors.grey.shade600),
            ),

            const SizedBox(height: 24),

            SearchBar(
              hintText: "Search Programs",
              leading: const Icon(Icons.search),
              elevation: const WidgetStatePropertyAll(0),
              backgroundColor: const WidgetStatePropertyAll(Colors.white),
              onChanged: (value) => setState(() => query = value),
            ),

            const SizedBox(height: 24),

            SizedBox(
              height: 45,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (_, index) {
                  return CategoryChip(
                    title: categories[index],
                    selected: selectedCategory == index,
                    onTap: () {
                      setState(() {
                        selectedCategory = index;
                      });
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 30),

            ...visiblePrograms.map(
              (program) => ProgramCard(
                program: program,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProgramDetailsPage(program: program),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
