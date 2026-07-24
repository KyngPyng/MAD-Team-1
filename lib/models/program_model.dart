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
  final String mentor; // Keep the field name your app expects
  final List<String> modules; // Keep the field name your app expects
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
<<<<<<< HEAD
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
=======
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      level: json['level'] ?? '',
      duration: json['duration'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      students: json['students'] as int? ?? 0,
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      image: json['imageUrl'] ?? json['image'] ?? '',
      // Map the JSON 'instructor' key to your app's 'mentor' field
      mentor: json['instructor'] ?? json['mentor'] ?? '',
      // Map the JSON 'topics' key to your app's 'modules' field
      modules: List<String>.from(json['topics'] ?? json['modules'] ?? []),
      isEnrolled: json['isEnrolled'] as bool? ?? false,
      description: json['description'] ?? '',
>>>>>>> 381a4bb (Refactor HomePage UI: replace Active Projects list with Daily Progress and Quick Actions)
    );
  }
}