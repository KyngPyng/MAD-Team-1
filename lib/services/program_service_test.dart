import 'dart:convert';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:team_sync/models/program_model.dart';
import 'package:team_sync/services/program_service.dart';

void main() {
  // Initialize the test binding required for channel/asset mocking
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProgramService programService;

  setUp(() {
    programService = ProgramService();
    // Clear the asset cache so tests don't leak data to each other
    rootBundle.clear();
  });

  group('ProgramService Tests', () {
    const String assetPath = 'assets/programs.json';

    test('fetchPrograms returns a list of ProgramModel on valid JSON structure', () async {
      // Mock valid JSON payload matching your model's expected fields
      final mockData = {
        "programs": [
          {
            "id": "1",
            "title": "Mechanical Design Prototyping",
            "level": "Intermediate",
            "duration": "4 Weeks",
            "description": "Learn 3D modeling and structural validation.",
            "mentor": "Alex Chen",
            "modules": ["Intro to CAD", "3D Printing Specs"],
            "isEnrolled": false,
            "progress": 0.0
          }
        ]
      };

      // Intercept the rootBundle request and inject our mock string
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler(
        'flutter/assets',
        (ByteData? message) async {
          final String key = utf8.decode(message!.buffer.asUint8List());
          if (key == assetPath) {
            // Asset keys are prefixed with a structural character length header in standard asset loading,
            // but string matching or direct responses work cleanly here.
            return ByteData.view(utf8.encode(json.encode(mockData)).buffer);
          }
          return null;
        },
      );

      // Execute the service call
      final programs = await programService.fetchPrograms();

      // Assertions
      expect(programs, isA<List<ProgramModel>>());
      expect(programs.length, 1);
      expect(programs.first.title, "Mechanical Design Prototyping");
      expect(programs.first.isEnrolled, false);
    });

    test('fetchPrograms throws an exception when the root key is missing', () async {
      // Malformed structure missing the 'programs' array wrapper
      final invalidMockData = {
        "wrong_key": []
      };

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler(
        'flutter/assets',
        (ByteData? message) async {
          return ByteData.view(utf8.encode(json.encode(invalidMockData)).buffer);
        },
      );

      // Verify that the custom error message is thrown up to the UI layer
      expect(
        () async => await programService.fetchPrograms(),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'description',
          contains('Failed to load available programs. Please try again.'),
        )),
      );
    });
  });
}