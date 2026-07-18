class ProgramModel {
  final String title;
  final String category;
  final String level;
  final String duration;
  final double rating;
  final int students;
  final double progress;
  final String image;
  final String mentor;
  final String description;
  final List<String> modules;
  final bool isEnrolled;

  const ProgramModel({
    required this.title,
    required this.category,
    required this.level,
    required this.duration,
    required this.rating,
    required this.students,
    required this.progress,
    required this.image,
    this.mentor = 'TeamSync Mentor',
    this.description = '',
    this.modules = const [],
    this.isEnrolled = false,
  });
}
