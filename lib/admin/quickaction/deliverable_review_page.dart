import 'dart:ui';
import 'package:flutter/material.dart';

class DeliverableReviewPage extends StatefulWidget {
  const DeliverableReviewPage({super.key});

  @override
  State<DeliverableReviewPage> createState() => _DeliverableReviewPageState();
}

class _DeliverableReviewPageState extends State<DeliverableReviewPage> {
  final List<Map<String, dynamic>> _pendingReviews = [
    {
      'id': 'SUB-101',
      'studentName': 'Kofi Mensah',
      'program': 'AI Productivity Masterclass',
      'taskTitle': 'Module 2: Custom Prompt Engineering Workflow',
      'submittedAt': '2 hours ago',
      'submissionText': 'Here is my submission for the prompt engineering template along with the API integration notes.',
      'link': 'https://github.com/example/prompt-workflow',
    },
    {
      'id': 'SUB-102',
      'studentName': 'Ama Serwaa',
      'program': 'Mobile App Dev (Flutter)',
      'taskTitle': 'Module 4: Navigation & Auth Session Flow',
      'submittedAt': '5 hours ago',
      'submissionText': 'Implemented local authentication using AppSessionService and connected state listeners.',
      'link': 'https://github.com/example/flutter-auth-module',
    },
    {
      'id': 'SUB-103',
      'studentName': 'Kwame Owusu',
      'program': 'Project Management Associate',
      'taskTitle': 'Module 1: Team Charter & Stakeholder Matrix',
      'submittedAt': '1 day ago',
      'submissionText': 'Attached is the completed team charter PDF including responsibilities and risk assessment.',
      'link': 'https://docs.google.com/document/d/example',
    },
  ];

  void _openGradingModal(Map<String, dynamic> item, int index) {
    final feedbackController = TextEditingController();
    String status = 'Approved';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
          return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                top: 16,
                left: 20,
                right: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFCBD5E1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    item['taskTitle'],
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Submitted by ${item['studentName']} • ${item['submittedAt']}',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Student Notes:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                        const SizedBox(height: 4),
                        Text(item['submissionText'], style: const TextStyle(fontSize: 13, color: Color(0xFF334155))),
                        if (item['link'] != null) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.link_rounded, size: 16, color: Color(0xFF6366F1)),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  item['link'],
                                  style: const TextStyle(fontSize: 12, color: Color(0xFF6366F1), textBaseline: TextBaseline.alphabetic),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ]
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Evaluation Status', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ChoiceChip(
                        label: const Text('Approve'),
                        selected: status == 'Approved',
                        selectedColor: const Color(0xFFD1FAE5),
                        labelStyle: TextStyle(color: status == 'Approved' ? const Color(0xFF065F46) : const Color(0xFF64748B), fontWeight: FontWeight.bold),
                        onSelected: (_) => setModalState(() => status = 'Approved'),
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('Request Revision'),
                        selected: status == 'Revision Needed',
                        selectedColor: const Color(0xFFFEF3C7),
                        labelStyle: TextStyle(color: status == 'Revision Needed' ? const Color(0xFF92400E) : const Color(0xFF64748B), fontWeight: FontWeight.bold),
                        onSelected: (_) => setModalState(() => status = 'Revision Needed'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: feedbackController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: 'Add feedback or notes for the student...',
                      hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _pendingReviews.removeAt(index);
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Submission marked as $status'),
                            backgroundColor: status == 'Approved' ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Submit Grade & Feedback', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Pending Deliverables',
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B), fontSize: 18),
        ),
      ),
      body: _pendingReviews.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.check_circle_outline_rounded, size: 48, color: Color(0xFF10B981)),
                  SizedBox(height: 12),
                  Text('All reviews completed!', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _pendingReviews.length,
              itemBuilder: (context, index) {
                final item = _pendingReviews[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(item['taskTitle'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B))),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text('${item['studentName']} • ${item['program']}', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                        const SizedBox(height: 2),
                        Text('Submitted ${item['submittedAt']}', style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () => _openGradingModal(item, index),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEEF2FF),
                        foregroundColor: const Color(0xFF4F46E5),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Review', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ),
                );
              },
            ),
    );
  }
}