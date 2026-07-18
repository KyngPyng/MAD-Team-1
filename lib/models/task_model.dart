class TaskModel {
  final String title;
  final String dueDate;
  final bool completed;

  const TaskModel({
    required this.title,
    required this.dueDate,
    this.completed = false,
  });
}
