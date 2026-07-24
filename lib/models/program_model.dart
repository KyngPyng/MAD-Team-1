class ProgramModel {
  final String id; // Added to differentiate programs cleanly
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
    required this.id,
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

  // Factory constructor to safely parse JSON data
  factory ProgramModel.fromJson(Map<String, dynamic> json) {
    return ProgramModel(
      id: (json['id'] as String?) ?? '',
      title: (json['title'] as String?) ?? '',
      category: (json['category'] as String?) ?? '',
      level: (json['level'] as String?) ?? 'Beginner',
      duration: (json['duration'] as String?) ?? '',
      rating: ((json['rating'] as num?) ?? 0.0).toDouble(),
      students: ((json['students'] as num?) ?? 0).toInt(),
      progress: ((json['progress'] as num?) ?? 0.0).toDouble(),
      image: (json['imageUrl'] as String?) ?? (json['image'] as String?) ?? '',
      mentor: (json['instructor'] as String?) ?? (json['mentor'] as String?) ?? 'TeamSync Mentor',
      description: (json['description'] as String?) ?? '',
      modules: (json['topics'] as List<dynamic>? ?? json['modules'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      isEnrolled: (json['isEnrolled'] as bool?) ?? false,
    );
  }
}