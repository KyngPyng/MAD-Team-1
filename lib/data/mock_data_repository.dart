import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/program_model.dart';
import '../models/project_model.dart';

class MockDataRepository {
  MockDataRepository._();

  static final MockDataRepository instance = MockDataRepository._();

  List<ProgramModel> _programs = const [];
  List<ProjectModel> _projects = const [];
  String? _loadError;

  Future<void> load() async {
    try {
      final rawJson = await rootBundle.loadString('assets/data/mock_data.json');
      final decoded = jsonDecode(rawJson) as Map<String, dynamic>;

      _programs = (decoded['programs'] as List<dynamic>)
          .map((entry) => ProgramModel.fromJson(entry as Map<String, dynamic>))
          .toList(growable: false);

      _projects = (decoded['projects'] as List<dynamic>)
          .map((entry) => ProjectModel.fromJson(entry as Map<String, dynamic>))
          .toList(growable: false);
      _loadError = null;
    } catch (error) {
      _programs = const [];
      _projects = const [];
      _loadError = 'Mock data could not be loaded.';
      // Keep the app usable with empty states if the JSON asset fails to load.
      // ignore: avoid_print
      print('MockDataRepository.load failed: $error');
    }
  }

  List<ProgramModel> get programs => List.unmodifiable(_programs);

  List<ProjectModel> get projects => List.unmodifiable(_projects);

  String? get loadError => _loadError;

  ProgramModel? programByTitle(String title) {
    for (final program in _programs) {
      if (program.title == title) return program;
    }
    return null;
  }
}
