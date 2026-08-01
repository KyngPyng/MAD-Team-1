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
      mentor: (json['instructor'] as String?) ??
          (json['mentor'] as String?) ??
          'TeamSync Mentor',
      description: (json['description'] as String?) ?? '',
      modules:
          (json['topics'] as List<dynamic>? ?? json['modules'] as List<dynamic>? ?? [])
              .map((e) => e.toString())
              .toList(),
      isEnrolled: (json['isEnrolled'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'level': level,
      'duration': duration,
      'rating': rating,
      'students': students,
      'progress': progress,
      'imageUrl': image,
      'instructor': mentor,
      'description': description,
      'topics': modules,
      'isEnrolled': isEnrolled,
    };
  }
}