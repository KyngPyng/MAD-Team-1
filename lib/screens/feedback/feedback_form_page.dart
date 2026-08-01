import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/di/service_locator.dart';
import '../../notifiers/feedback_notifier.dart';
import '../../widgets/team_sync_loader.dart';

class FeedbackFormPage extends StatelessWidget {
  const FeedbackFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject FeedbackNotifier into this subtree using GetIt + ChangeNotifierProvider
    return ChangeNotifierProvider<FeedbackNotifier>(
      create: (_) => getIt<FeedbackNotifier>(),
      child: const _FeedbackFormBody(),
    );
  }
}

class _FeedbackFormBody extends StatefulWidget {
  const _FeedbackFormBody();

  @override
  State<_FeedbackFormBody> createState() => _FeedbackFormBodyState();
}

class _FeedbackFormBodyState extends State<_FeedbackFormBody> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  int _rating = 4;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final notifier = context.read<FeedbackNotifier>();

    final success = await notifier.submitFeedback(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      rating: _rating,
      message: _messageController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Feedback submitted successfully.')),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            notifier.errorMessage ?? 'Failed to submit feedback.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the notifier state so UI automatically updates when status changes
    final notifier = context.watch<FeedbackNotifier>();

    return Scaffold(
      appBar: AppBar(title: const Text('Feedback')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Share your experience',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Tell us what is working and what should improve.',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                enabled: !notifier.isLoading,
                decoration: const InputDecoration(
                  labelText: 'Your name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                enabled: !notifier.isLoading,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email is required';
                  }
                  if (!value.contains('@')) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                initialValue: _rating,
                decoration: const InputDecoration(
                  labelText: 'Rating',
                  border: OutlineInputBorder(),
                ),
                items: List.generate(
                  5,
                  (index) => DropdownMenuItem(
                    value: index + 1,
                    child: Text('${index + 1} star${index == 0 ? '' : 's'}'),
                  ),
                ),
                onChanged: notifier.isLoading
                    ? null
                    : (value) {
                        if (value != null) {
                          setState(() => _rating = value);
                        }
                      },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _messageController,
                enabled: !notifier.isLoading,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Feedback',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Feedback message is required';
                  }
                  if (value.trim().length < 10) {
                    return 'Please add a little more detail';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: notifier.isLoading ? null : () => _submit(context),
                  icon: notifier.isLoading
                      ? const TeamSyncLoader(
                          size: 20,
                          strokeWidth: 2.2,
                          color: Colors.white,
                        )
                      : const Icon(Icons.send_rounded),
                  label: Text(
                    notifier.isLoading ? 'Submitting...' : 'Submit Feedback',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}