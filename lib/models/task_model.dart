class TaskModel {
  final String title;
  final String dueDate;
  final bool completed;

  const TaskModel({
    required this.title,
    required this.dueDate,
    this.completed = false,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      title: json['title'] as String,
      dueDate: json['dueDate'] as String,
      completed: (json['completed'] as bool?) ?? false,
    );
  }
}
