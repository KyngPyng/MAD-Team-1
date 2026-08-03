import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../models/program_model.dart';
import '../../widgets/success_tick_widget.dart';
// Replace with your actual loader package/import path
import '../../widgets/team_sync_loader.dart';

class SubmitDeliverableScreen extends StatefulWidget {
  final ProgramModel selectedProgram;

  const SubmitDeliverableScreen({
    super.key,
    required this.selectedProgram,
  });

  @override
  State<SubmitDeliverableScreen> createState() =>
      _SubmitDeliverableScreenState();
}

enum SubmissionState { idle, loading, success }

class _SubmitDeliverableScreenState extends State<SubmitDeliverableScreen> {
  final TextEditingController _notesController = TextEditingController();
  final List<PlatformFile> _selectedFiles = [];
  SubmissionState _state = SubmissionState.idle;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: true,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFiles.addAll(result.files);
      });
    }
  }

  void _removeFile(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
    });
  }

  Future<void> _handleSubmit() async {
    if (_selectedFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one PDF file.')),
      );
      return;
    }

    setState(() {
      _state = SubmissionState.loading;
    });

    // Simulate 3-second network upload using your TeamSyncLoader
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    setState(() {
      _state = SubmissionState.success;
    });

    // Display success tick animation for 2 seconds, then pop back to HomePage
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit - ${widget.selectedProgram.title}'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (_state) {
      case SubmissionState.loading:
        return const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TeamSyncLoader(), // Your existing custom loader widget
              SizedBox(height: 16),
              Text('Uploading deliverables...'),
            ],
          ),
        );

      case SubmissionState.success:
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: SuccessTickWidget(),
          ),
        );

      case SubmissionState.idle:
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Program Badge
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.school, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      widget.selectedProgram.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Notes Input Field
              const Text(
                'Notes / Deliverable Description',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _notesController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText:
                      'Type a short note about this submission (optional)...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // File Drop / Selection Box
              const Text(
                'Attach PDF Deliverables',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickFiles,
                borderRadius: BorderRadius.circular(12.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 28.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade400,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.grey.shade50,
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.picture_as_pdf_rounded,
                        size: 40,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Tap to browse PDF files from your device',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Supports multiple .pdf files',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Selected Files List
              if (_selectedFiles.isNotEmpty) ...[
                const Text(
                  'Selected Files:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _selectedFiles.length,
                  itemBuilder: (context, index) {
                    final file = _selectedFiles[index];
                    final sizeInMb = (file.size / (1024 * 1024)).toStringAsFixed(2);
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8.0),
                      child: ListTile(
                        leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                        title: Text(
                          file.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text('$sizeInMb MB'),
                        trailing: IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: () => _removeFile(index),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],

              // Submit Action Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text(
                    'Submit Deliverables',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
    }
  }
}