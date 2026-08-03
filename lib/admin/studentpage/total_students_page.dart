import 'package:flutter/material.dart';

class TotalStudentsPage extends StatefulWidget {
  const TotalStudentsPage({super.key});

  @override
  State<TotalStudentsPage> createState() => _TotalStudentsPageState();
}

class _TotalStudentsPageState extends State<TotalStudentsPage> {
  String _searchQuery = '';
  String _selectedProgram = 'All';

  final List<String> _programFilters = [
    'All',
    'AI Productivity Masterclass',
    'Mobile App Dev (Flutter)',
    'Project Management Associate',
  ];

  // Mock Subgroups Data
  final List<Map<String, dynamic>> _subgroups = [
    {
      'id': 'sg_alpha',
      'name': 'Subgroup Alpha',
      'program': 'AI Productivity Masterclass',
      'memberCount': 12,
      'atRiskCount': 1,
      'members': [
        {
          'name': 'Kofi Mensah',
          'email': 'kofi.mensah@example.com',
          'role': 'Team Lead',
          'progress': 0.85,
          'status': 'Active',
        },
        {
          'name': 'Abena Osei',
          'email': 'abena.osei@example.com',
          'role': 'Member',
          'progress': 0.40,
          'status': 'At Risk',
        },
        {
          'name': 'Yaw Mensah',
          'email': 'yaw.m@example.com',
          'role': 'Member',
          'progress': 0.90,
          'status': 'Active',
        },
      ],
    },
    {
      'id': 'sg_beta',
      'name': 'Subgroup Beta',
      'program': 'Mobile App Dev (Flutter)',
      'memberCount': 10,
      'atRiskCount': 1,
      'members': [
        {
          'name': 'Ama Serwaa',
          'email': 'ama.serwaa@example.com',
          'role': 'Team Lead',
          'progress': 0.62,
          'status': 'Active',
        },
        {
          'name': 'Yaw Addo',
          'email': 'yaw.addo@example.com',
          'role': 'Member',
          'progress': 0.15,
          'status': 'At Risk',
        },
      ],
    },
    {
      'id': 'sg_gamma',
      'name': 'Subgroup Gamma',
      'program': 'Project Management Associate',
      'memberCount': 15,
      'atRiskCount': 0,
      'members': [
        {
          'name': 'Kwame Owusu',
          'email': 'kwame.owusu@example.com',
          'role': 'Team Lead',
          'progress': 0.95,
          'status': 'Active',
        },
      ],
    },
  ];

  List<Map<String, dynamic>> get _filteredSubgroups {
    return _subgroups.where((group) {
      final matchesSearch = group['name']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          group['program']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());

      final matchesProgram = _selectedProgram == 'All' ||
          group['program'] == _selectedProgram;

      return matchesSearch && matchesProgram;
    }).toList();
  }

  void _openDirectChat(Map<String, dynamic> group) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SubgroupDirectChatScreen(subgroup: group),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredGroups = _filteredSubgroups;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Subgroups & Roster',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search & Filters
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: 'Search subgroup or program...',
                    hintStyle: const TextStyle(
                        fontSize: 13, color: Color(0xFF94A3B8)),
                    prefixIcon: const Icon(Icons.search_rounded,
                        color: Color(0xFF64748B)),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _programFilters.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final program = _programFilters[index];
                      final isSelected = _selectedProgram == program;

                      return FilterChip(
                        selected: isSelected,
                        label: Text(program),
                        labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF475569),
                        ),
                        selectedColor: const Color(0xFF6366F1),
                        backgroundColor: Colors.white,
                        side: BorderSide(
                          color: isSelected
                              ? const Color(0xFF6366F1)
                              : const Color(0xFFE2E8F0),
                        ),
                        onSelected: (_) {
                          setState(() => _selectedProgram = program);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${filteredGroups.length} Subgroups Active',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF64748B),
                  ),
                ),
                const Icon(Icons.grid_view_rounded,
                    size: 18, color: Color(0xFF64748B)),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Subgroups List
          Expanded(
            child: filteredGroups.isEmpty
                ? const Center(
                    child: Text(
                      'No subgroups match your criteria.',
                      style: TextStyle(color: Color(0xFF94A3B8)),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: filteredGroups.length,
                    itemBuilder: (context, index) {
                      final group = filteredGroups[index];
                      final atRisk = (group['atRiskCount'] as int) > 0;

                      return GestureDetector(
                        onTap: () => _openDirectChat(group),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: const Color(0xFFEEF2FF),
                                    child: const Icon(
                                      Icons.groups_rounded,
                                      color: Color(0xFF6366F1),
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          group['name'] as String,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Color(0xFF0F172A),
                                          ),
                                        ),
                                        Text(
                                          group['program'] as String,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Color(0xFF64748B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.forum_outlined,
                                    size: 18,
                                    color: Color(0xFF6366F1),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              const Divider(height: 1, color: Color(0xFFF1F5F9)),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.people_outline_rounded,
                                          size: 15, color: Color(0xFF475569)),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${group['memberCount']} Members',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF475569),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (atRisk)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFEF2F2),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        '${group['atRiskCount']} At Risk',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFDC2626),
                                        ),
                                      ),
                                    ),
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
    );
  }
}

// --- WhatsApp-style Direct Chat Screen ---
class SubgroupDirectChatScreen extends StatefulWidget {
  final Map<String, dynamic> subgroup;

  const SubgroupDirectChatScreen({super.key, required this.subgroup});

  @override
  State<SubgroupDirectChatScreen> createState() =>
      _SubgroupDirectChatScreenState();
}

class _SubgroupDirectChatScreenState extends State<SubgroupDirectChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  void _showGroupMembersSheet() {
    final List<Map<String, dynamic>> members =
        List<Map<String, dynamic>>.from(widget.subgroup['members'] as List);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: const Color(0xFFEEF2FF),
                  child: const Icon(Icons.groups_rounded,
                      color: Color(0xFF6366F1), size: 22),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.subgroup['name'] as String,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      '${members.length} group participants',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 28),
            const Text(
              'Group Members',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF475569),
              ),
            ),
            const SizedBox(height: 12),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.45,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: members.length,
                itemBuilder: (context, index) {
                  final member = members[index];
                  final isAtRisk = member['status'] == 'At Risk';
                  final isLead = member['role'] == 'Team Lead';

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: isAtRisk
                              ? const Color(0xFFFEE2E2)
                              : const Color(0xFFEEF2FF),
                          child: Text(
                            member['name'][0],
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isAtRisk
                                  ? const Color(0xFFEF4444)
                                  : const Color(0xFF6366F1),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    member['name'] as String,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                  if (isLead) ...[
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFEF3C7),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Text(
                                        'LEAD',
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFD97706),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              Text(
                                member['email'] as String,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isAtRisk)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF2F2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'At Risk',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFDC2626),
                              ),
                            ),
                          ),
                      ],
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

  @override
  Widget build(BuildContext context) {
    final groupName = widget.subgroup['name'] as String;
    final memberCount = widget.subgroup['memberCount'];

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        // WhatsApp-style Interactive Header
        title: InkWell(
          onTap: _showGroupMembersSheet,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: const Color(0xFFEEF2FF),
                  child: const Icon(Icons.groups_rounded,
                      color: Color(0xFF6366F1), size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        groupName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        '$memberCount members • Tap for group info',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded,
                color: Color(0xFF64748B)),
            onPressed: _showGroupMembersSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat Messages
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Text(
                      'Admin connected to $groupName',
                      style: const TextStyle(
                          fontSize: 11, color: Color(0xFF64748B)),
                    ),
                  ),
                ),
                _buildChatBubble(
                  sender: 'Kofi Mensah (Team Lead)',
                  message:
                      'Hello team! Welcome to our subgroup chat. Please submit your module 1 reviews by tomorrow.',
                  isMe: false,
                  time: '10:14 AM',
                ),
                _buildChatBubble(
                  sender: 'You (Admin)',
                  message:
                      'Good morning team! Let me know if anyone needs assistance with their current deliverables.',
                  isMe: true,
                  time: '10:18 AM',
                ),
              ],
            ),
          ),

          // Message Input Field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: Colors.white,
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type an announcement or message...',
                        hintStyle: const TextStyle(
                            fontSize: 13, color: Color(0xFF94A3B8)),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: const Color(0xFF6366F1),
                    radius: 20,
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded,
                          size: 18, color: Colors.white),
                      onPressed: () {
                        _messageController.clear();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble({
    required String sender,
    required String message,
    required bool isMe,
    required String time,
  }) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFF6366F1) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 16),
          ),
          border: isMe ? null : Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              sender,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isMe ? const Color(0xFFE0E7FF) : const Color(0xFF6366F1),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message,
              style: TextStyle(
                fontSize: 13,
                color: isMe ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(
                fontSize: 9,
                color: isMe ? const Color(0xFFC7D2FE) : const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}