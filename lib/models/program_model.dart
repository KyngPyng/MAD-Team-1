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

  factory ProgramModel.fromJson(Map<String, dynamic> json) {
    return ProgramModel(
      title: json['title'] as String,
      category: json['category'] as String,
      level: json['level'] as String,
      duration: json['duration'] as String,
      rating: (json['rating'] as num).toDouble(),
      students: (json['students'] as num).toInt(),
      progress: (json['progress'] as num).toDouble(),
      image: json['image'] as String,
      mentor: (json['mentor'] as String?) ?? 'TeamSync Mentor',
      description: (json['description'] as String?) ?? '',
      modules: (json['modules'] as List<dynamic>? ?? const []).cast<String>(),
      isEnrolled: (json['isEnrolled'] as bool?) ?? false,
    );
  }
}
