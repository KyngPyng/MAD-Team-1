import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/program_model.dart'; // Ensure this matches your file name

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
}