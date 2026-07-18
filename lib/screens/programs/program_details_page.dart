import 'package:flutter/material.dart';

import '../../models/program_model.dart';

class ProgramDetailsPage extends StatefulWidget {
  final ProgramModel program;

  const ProgramDetailsPage({super.key, required this.program});

  @override
  State<ProgramDetailsPage> createState() => _ProgramDetailsPageState();
}

class _ProgramDetailsPageState extends State<ProgramDetailsPage> {
  late bool _isEnrolled;

  @override
  void initState() {
    super.initState();
    _isEnrolled = widget.program.isEnrolled;
  }

  @override
  Widget build(BuildContext context) {
    final program = widget.program;

    return Scaffold(
      appBar: AppBar(title: Text(program.title)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(program.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text('${program.level} • ${program.duration}'),
          const SizedBox(height: 20),
          Text(
            program.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const CircleAvatar(child: Icon(Icons.person_outline)),
            title: const Text('Mentor'),
            subtitle: Text(program.mentor),
          ),
          const SizedBox(height: 16),
          Text(
            'What you will learn',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ...program.modules.map(
            (module) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.check_circle_outline),
              title: Text(module),
            ),
          ),
          const SizedBox(height: 16),
          if (_isEnrolled) ...[
            Text(
              'Your progress',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(value: program.progress),
            const SizedBox(height: 8),
            Text('${(program.progress * 100).round()}% completed'),
          ] else
            Text(
              'You are not enrolled in this program yet.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () {
              if (_isEnrolled) return;
              setState(() => _isEnrolled = true);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('You are enrolled. Start learning!'),
                ),
              );
            },
            icon: Icon(
              _isEnrolled ? Icons.play_arrow_rounded : Icons.add_circle_outline,
            ),
            label: Text(_isEnrolled ? 'Continue Learning' : 'Enroll Now'),
          ),
        ],
      ),
    );
  }
}
