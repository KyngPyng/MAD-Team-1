import 'task_model.dart';

class ProjectModel {
  final String title;
  final String description;
  final String image;
  final String status;
  final double progress;
  final List<String> teamMembers;
  final List<TaskModel> tasks;
  final String dueDate;

  const ProjectModel({
    required this.title,
    required this.description,
    required this.image,
    required this.status,
    this.progress = 0,
    this.teamMembers = const [],
    this.tasks = const [],
    this.dueDate = '',
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      title: json['title'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
      status: json['status'] as String,
      progress: (json['progress'] as num).toDouble(),
      teamMembers: (json['teamMembers'] as List<dynamic>? ?? const [])
          .cast<String>(),
      tasks: (json['tasks'] as List<dynamic>? ?? const [])
          .map((task) => TaskModel.fromJson(task as Map<String, dynamic>))
          .toList(growable: false),
      dueDate: (json['dueDate'] as String?) ?? '',
    );
  }
}
