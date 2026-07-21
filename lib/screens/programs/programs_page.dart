import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../data/mock_data_repository.dart';
import '../../models/program_model.dart';
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
  final TextEditingController _searchController = TextEditingController();

  final List<String> categories = const [
    "All",
    "Flutter",
    "AI",
    "Design",
    "Cloud",
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearFilters() {
    setState(() {
      query = '';
      selectedCategory = 0;
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final programs = MockDataRepository.instance.programs;
    final loadError = MockDataRepository.instance.loadError;
    final filteredPrograms = programs.where((program) {
      final matchesCategory =
          selectedCategory == 0 ||
          program.category == categories[selectedCategory];
      final normalizedQuery = query.toLowerCase();
      final matchesQuery =
          normalizedQuery.isEmpty ||
          program.title.toLowerCase().contains(normalizedQuery) ||
          program.category.toLowerCase().contains(normalizedQuery);
      return matchesCategory && matchesQuery;
    }).toList();

    final enrolledPrograms = filteredPrograms
        .where((p) => p.isEnrolled)
        .toList();
    final discoverPrograms = filteredPrograms
        .where((p) => !p.isEnrolled)
        .toList();

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
            if (loadError != null) ...[
              MaterialBanner(
                backgroundColor: Colors.red.withValues(alpha: 0.08),
                content: Text(loadError),
                actions: [
                  TextButton(onPressed: () {}, child: const Text('OK')),
                ],
              ),
              const SizedBox(height: 16),
            ],
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

            // Search Bar
            SearchBar(
              controller: _searchController,
              hintText: "Search Programs",
              leading: const Icon(Icons.search),
              trailing: query.isNotEmpty
                  ? [
                      IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: _clearFilters,
                      ),
                    ]
                  : null,
              elevation: const WidgetStatePropertyAll(0),
              backgroundColor: const WidgetStatePropertyAll(Colors.white),
              onChanged: (value) => setState(() => query = value),
            ),
            const SizedBox(height: 24),

            // Category Horizontal Filters
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

            // --- MAIN LIST CONTENT / EMPTY STATE CHECK ---
            if (filteredPrograms.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 60),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "No Results Found",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "We couldn't find matches for '$query'.\nTry checking your spelling or changing filters.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextButton.icon(
                      onPressed: _clearFilters,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text("Reset Search Filters"),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else ...[
              // --- SECTION 1: MY ENROLLED PROGRAMS (Horizontal Slider) ---
              if (enrolledPrograms.isNotEmpty) ...[
                Text(
                  "My Enrolled Programs",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 540,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: enrolledPrograms.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      final program = enrolledPrograms[index];
                      return SizedBox(
                        width: 280,
                        child: ProgramCard(
                          program: program,
                          onTap: () => _navigateToDetails(context, program),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 35),
              ],

              // --- SECTION 2: DISCOVER PROGRAMS (Vertical Stream) ---
              if (discoverPrograms.isNotEmpty) ...[
                Text(
                  "Discover Programs",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 14),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: discoverPrograms.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final program = discoverPrograms[index];
                    return ProgramCard(
                      program: program,
                      onTap: () => _navigateToDetails(context, program),
                    );
                  },
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  void _navigateToDetails(BuildContext context, ProgramModel program) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProgramDetailsPage(program: program)),
    );
  }
}
