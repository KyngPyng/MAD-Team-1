import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../models/program_model.dart';
import '../../data/dummy_data.dart';
import '../../widgets/task_tile.dart';

class TeamDashboardPage extends StatelessWidget {
  final ProgramModel program;

  const TeamDashboardPage({super.key, required this.program});

  @override
  Widget build(BuildContext context) {
    final activeProjects = projects.where((p) => p.progress < 1).toList();
    final upcomingTasks = activeProjects.expand((p) => p.tasks).take(4);

    final teamMembers = [
      {'name': 'Alex Rivera', 'role': 'UI/UX Designer', 'initials': 'AR'},
      {'name': 'Anil', 'role': 'Team Lead / Project Manager', 'initials': 'A'},
      {'name': 'Sarah Chen', 'role': 'Frontend Developer', 'initials': 'SC'},
      {'name': 'Marcus Johnson', 'role': 'Backend Developer', 'initials': 'MJ'},
    ];

    // Placeholder messages data structure for the Chat tab
    final chatMessages = [
      {'sender': 'Alex Rivera', 'msg': 'Hey team, just uploaded the updated UI wireframes to the shared drive.', 'time': '10:24 AM', 'isMe': false},
      {'sender': 'Anil', 'msg': 'Awesome, thanks Alex! I will review the sidebar changes before the sync meeting.', 'time': '10:26 AM', 'isMe': true},
      {'sender': 'Sarah Chen', 'msg': 'Perfect. I can start working on frontend components right after.', 'time': '11:02 AM', 'isMe': false},
    ];

    return DefaultTabController(
      length: 3, // Increased tab count to 3
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            program.title,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  labelColor: const Color(0xFF7B7BFF),
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: const Color(0xFF7B7BFF),
                  indicatorWeight: 3,
                  labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  tabs: const [
                    Tab(text: "Upcoming Tasks"),
                    Tab(text: "Team Members"),
                    Tab(text: "Chat"), // New Chat Tab
                  ],
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Tasks View
            ListView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
              children: [
                ...upcomingTasks.map((task) => TaskTile(task: task)),
              ],
            ),

            // Tab 2: Team Members View
            ListView.separated(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
              itemCount: teamMembers.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final member = teamMembers[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F2F9),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF7B7BFF),
                      child: Text(
                        member['initials']!,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      member['name']!,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    subtitle: Text(
                      member['role']!,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                  ),
                );
              },
            ),

            // Tab 3: Workspace Chat View
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    itemCount: chatMessages.length,
                    itemBuilder: (context, index) {
                      final chat = chatMessages[index];
                      final isMe = chat['isMe'] as bool;

                      return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75,
                          ),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isMe ? const Color(0xFF7B7BFF) : const Color(0xFFF1F2F9),
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16),
                              topRight: const Radius.circular(16),
                              bottomLeft: Radius.circular(isMe ? 16 : 0),
                              bottomRight: Radius.circular(isMe ? 0 : 16),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!isMe) ...[
                                Text(
                                  chat['sender'] as String,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF7B7BFF),
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 4),
                              ],
                              Text(
                                chat['msg'] as String,
                                style: TextStyle(
                                  color: isMe ? Colors.white : Colors.black87,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  chat['time'] as String,
                                  style: TextStyle(
                                    color: isMe ? Colors.white70 : Colors.black38,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                // Bottom Input Message Field
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Type your message...',
                            hintStyle: const TextStyle(color: Colors.grey),
                            fillColor: const Color(0xFFF1F2F9),
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: const Color(0xFF7B7BFF),
                        child: IconButton(
                          icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                          onPressed: () {
                            // Action handle for sending a message
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}