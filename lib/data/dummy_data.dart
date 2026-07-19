// Inside your project data file (e.g., lib/data/project_dummy_data.dart)
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
    title: 'Nexus Mobile App',
    description: 'Set up global state management, design scalable UI components, and integrate foundational app features.',
    image: 'assets/images/project2.png',
    status: 'In Progress',
    progress: .35,
    teamMembers: ['AM', 'RK', 'TJ', 'OS'], // Represents Sub Group members
    dueDate: 'Jul 15',
    tasks: [
      TaskModel(title: 'Initialize repository layout and basic routing', dueDate: 'Today'),
      TaskModel(title: 'Review initial sprint layout with sub team', dueDate: 'Tomorrow'),
    ],
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