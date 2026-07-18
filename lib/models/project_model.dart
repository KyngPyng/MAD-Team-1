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
}
