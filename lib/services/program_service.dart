import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/program_model.dart';
import '../models/feedback_model.dart'; // 1. Added import for feedback model

class ProgramService {
  // Fetches programs from the local JSON asset with simulated latency
  Future<List<ProgramModel>> fetchPrograms() async {
    try {
      // Simulate 2 seconds of network delay to test loading spinners
      await Future.delayed(const Duration(seconds: 2));

      // Load the raw JSON string from the asset bundle
      final String response = await rootBundle.loadString('assets/programs.json');
      final Map<String, dynamic> data = json.decode(response);

      if (data.containsKey('programs')) {
        final List<dynamic> programList = data['programs'];
        
        // Map each JSON object using your factory constructor
        return programList.map((json) => ProgramModel.fromJson(json)).toList();
      } else {
        throw Exception("Invalid data format: 'programs' key missing.");
      }
    } catch (e) {
      // Pass a clean error message up to the UI layer
      throw Exception("Failed to load available programs. Please try again.");
    }
  }

  // 2. Added new submitFeedback method
  Future<bool> submitFeedback(FeedbackModel feedback) async {
    try {
      // Simulate 1 second of network latency
      await Future.delayed(const Duration(seconds: 1));

      // Log the payload to the console so you can verify it in developer tools
      print('[Mock API Response] Feedback Received Successfully:');
      print(jsonEncode(feedback.toJson()));

      return true; // Returns true to signify successful submission
    } catch (e) {
      return false;
    }
  }
}