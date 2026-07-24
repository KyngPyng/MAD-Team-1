class ProgramModel {
  final String id;
  final String title;
  final String category;
  final String level;
  final String duration;
  final double rating;
  final int students;
  final double progress;
  final String image;
  final String mentor;
  final List<String> modules;
  final bool isEnrolled;
  final String description;

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
    required this.mentor,
    required this.modules,
    required this.isEnrolled,
    required this.description,
  });

  factory ProgramModel.fromJson(Map<String, dynamic> json) {
    final modulesJson = json['topics'] ?? json['modules'] ?? const [];
    final rawImage = json['imageUrl'] ?? json['image'] ?? '';
    final rawMentor = json['instructor'] ?? json['mentor'] ?? 'TeamSync Mentor';

    return ProgramModel(
      id: (json['id'] as String?) ?? '',
      title: (json['title'] as String?) ?? '',
      category: (json['category'] as String?) ?? '',
      level: (json['level'] as String?) ?? 'Beginner',
      duration: (json['duration'] as String?) ?? '',
      rating: ((json['rating'] as num?) ?? 0.0).toDouble(),
      students: ((json['students'] as num?) ?? 0).toInt(),
      progress: ((json['progress'] as num?) ?? 0.0).toDouble(),
      image: rawImage.toString(),
      mentor: rawMentor.toString(),
      modules: (modulesJson as List<dynamic>)
          .map((entry) => entry.toString())
          .toList(growable: false),
      isEnrolled: (json['isEnrolled'] as bool?) ?? false,
      description: (json['description'] as String?) ?? '',
    );
  }
}
