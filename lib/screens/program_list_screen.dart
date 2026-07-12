import 'package:flutter/material.dart';

class ProgramListScreen extends StatefulWidget {
  const ProgramListScreen({super.key});

  @override
  State<ProgramListScreen> createState() => _ProgramListScreenState();
}

class _ProgramListScreenState extends State<ProgramListScreen> {
  String selectedFilter = 'All';

  // Mock data representing program tracks and status metrics
  final List<Map<String, dynamic>> tracks = [
    {
      'title': 'Project Management Track',
      'tasks': 'WBS Setup & Milestone Mapping',
      'status': 'In Progress',
      'progress': 0.75,
      'color': Colors.orange,
    },
    {
      'title': 'Frontend Development (Flutter)',
      'tasks': 'UI Scaffolding & Core Screen Routing',
      'status': 'Completed',
      'progress': 1.0,
      'color': Colors.green,
    },
    {
      'title': 'Backend Systems Architecture',
      'tasks': 'Database Schema & Auth API Endpoints',
      'status': 'Planning',
      'progress': 0.20,
      'color': Colors.blue,
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Filter tracks based on dropdown selection
    final filteredTracks = selectedFilter == 'All'
        ? tracks
        : tracks.where((track) => track['status'] == selectedFilter).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('teamSync - Program Tracks'),
        backgroundColor: Colors.deepPurple.shade50,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter Controls Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Track Deliverables',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: selectedFilter,
                  items: const [
                    DropdownMenuItem(value: 'All', child: Text('All Tracks')),
                    DropdownMenuItem(value: 'Completed', child: Text('Completed')),
                    DropdownMenuItem(value: 'In Progress', child: Text('In Progress')),
                    DropdownMenuItem(value: 'Planning', child: Text('Planning')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedFilter = value!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Dynamic List of Tracks
            Expanded(
              child: ListView.builder(
                itemCount: filteredTracks.length,
                itemBuilder: (context, index) {
                  final track = filteredTracks[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                track['title'],
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Chip(
                                label: Text(
                                  track['status'],
                                  style: const TextStyle(color: Colors.white, fontSize: 12),
                                ),
                                backgroundColor: track['color'],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Current Focus: ${track['tasks']}',
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          const SizedBox(height: 16),
                          
                          // Track Progress Indicator
                          Row(
                            children: [
                              Expanded(
                                child: LinearProgressIndicator(
                                  value: track['progress'],
                                  backgroundColor: Colors.grey.shade200,
                                  color: track['color'],
                                  minHeight: 8,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text('${(track['progress'] * 100).toInt()}%'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}