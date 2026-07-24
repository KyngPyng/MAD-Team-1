import '../models/program_model.dart';

const List<ProgramModel> programs = [
  ProgramModel(
    id: "p1",
    title: "Flutter Development",
    category: "Flutter",
    level: "Beginner",
    duration: "8 Weeks",
    rating: 4.8,
    students: 1200,
    progress: .70,
    image: "assets/images/flutter.png",
    mentor: 'Priya Shah',
    isEnrolled: true,
    description:
        'Build polished, production-ready Flutter apps from responsive UI to release.',
    modules: ['Flutter foundations', 'State and navigation', 'Production UI'],
  ),

  ProgramModel(
    id: "p2",
    title: "UI/UX Design",
    category: "Design",
    level: "Intermediate",
    duration: "6 Weeks",
    rating: 4.7,
    students: 860,
    progress: .35,
    image: "assets/images/uiux.png",
    mentor: 'Daniel Kim',
    isEnrolled: true,
    description:
        'Learn a practical user-centred design process and turn research into useful interfaces.',
    modules: ['Design research', 'Wireframing', 'Prototyping and handoff'],
  ),

  ProgramModel(
    id: "p3",
    title: "Artificial Intelligence",
    category: "AI",
    level: "Advanced",
    duration: "10 Weeks",
    rating: 4.9,
    students: 2100,
    progress: 0,
    image: "assets/images/ai.png",
    mentor: 'Amina Yusuf',
    description:
        'Explore core artificial intelligence concepts, model development, and responsible deployment.',
    modules: ['AI foundations', 'Machine learning workflows', 'Responsible AI'],
  ),
];
