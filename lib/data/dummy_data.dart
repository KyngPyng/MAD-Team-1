import '../models/project_model.dart';
import '../models/task_model.dart';

const List<ProjectModel> projects = [
  ProjectModel(
    title: 'E-commerce App',
    description: 'Develop features, landing page and improve payment gateway.',
    image: 'assets/images/project1.png',
    status: 'In Progress',
    progress: .65,
    teamMembers: ['AM', 'JK', 'SL'],
    dueDate: 'Jun 20',
    tasks: [
      TaskModel(title: 'Finish UI wireframes for module', dueDate: 'Today'),
      TaskModel(title: 'Review checkout implementation', dueDate: 'Tomorrow'),
    ],
  ),
  ProjectModel(
    title: 'Team Dashboard',
    description: 'Fix sidebar navigation bugs and update user permissions.',
    image: 'assets/images/project2.png',
    status: 'In Review',
    progress: .82,
    teamMembers: ['AM', 'RK', 'TJ'],
    dueDate: 'Jun 24',
    tasks: [TaskModel(title: 'Review pull request #1023', dueDate: 'Jun 20')],
  ),
  ProjectModel(
    title: 'Fitness Tracker',
    description: 'Implement chart logs for daily calorie tracking.',
    image: 'assets/images/project3.png',
    status: 'Completed',
    progress: 1,
    teamMembers: ['AM', 'CD'],
    dueDate: 'Jul 2',
    tasks: [
      TaskModel(title: 'Plan calorie tracking milestones', dueDate: 'Jun 28'),
    ],
  ),
];
