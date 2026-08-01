import 'package:flutter/material.dart';
import '../core/di/service_locator.dart';
import '../models/feedback_model.dart';
import '../services/program_service.dart';

enum FeedbackStatus { initial, loading, success, error }

class FeedbackNotifier extends ChangeNotifier {
  final ProgramService _programService = getIt<ProgramService>();

  FeedbackStatus _status = FeedbackStatus.initial;
  String? _errorMessage;

  FeedbackStatus get status => _status;
  bool get isLoading => _status == FeedbackStatus.loading;
  String? get errorMessage => _errorMessage;

  Future<bool> submitFeedback({
    required String name,
    required String email,
    required int rating,
    required String message,
  }) async {
    _status = FeedbackStatus.loading;
    _errorMessage = null;
    notifyListeners(); // 1. Tells UI to render TeamSyncLoader

    final feedback = FeedbackModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: 'General Experience',
      rating: rating,
      comments: message,
    );

    final success = await _programService.submitFeedback(feedback);

    if (success) {
      _status = FeedbackStatus.success;
      notifyListeners(); // 2. Tells UI submission succeeded
      return true;
    } else {
      _status = FeedbackStatus.error;
      _errorMessage = 'Failed to submit feedback. Please try again.';
      notifyListeners(); // 3. Tells UI submission failed
      return false;
    }
  }

  void resetStatus() {
    _status = FeedbackStatus.initial;
    _errorMessage = null;
    notifyListeners();
  }
}