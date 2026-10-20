import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:prac_mob4/models/student.dart';
import 'package:prac_mob4/utils/data_processor.dart';

Future<void> main() async {
  print('=== Dart Async Programming Demo ===');
  await demonstrateFutures();
  await demonstrateStreams();
  await demonstrateFileOperations();
}

Future<String> fetchStudentData(String studentId) async {
  await Future<void>.delayed(const Duration(milliseconds: 30));
  return jsonEncode({'id': studentId, 'status': 'loaded'});
}

Future<List<Student>> loadStudentsFromFile(String filename) async {
  final decoded =
      jsonDecode(await File(filename).readAsString()) as List<dynamic>;
  return decoded
      .map((item) => Student.fromJson(item as Map<String, dynamic>))
      .toList();
}

Future<void> saveReportToFile(String filename, Object report) async {
  await File(filename)
      .writeAsString(const JsonEncoder.withIndent('  ').convert(report));
}

Stream<Student> studentStream() async* {
  for (final filename in const [
    'data/students_part1.json',
    'data/students_part2.json',
    'data/students_part3.json',
  ]) {
    for (final student in await loadStudentsFromFile(filename)) {
      yield student;
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
  }
}

Future<void> demonstrateFutures() async {
  final ids = ['s-001', 's-002', 's-003'];
  final results = await Future.wait(ids.map(fetchStudentData));
  print('\nFutures (parallel requests): $results');
  try {
    await Future<String>.error(StateError('simulated network issue'))
        .timeout(const Duration(seconds: 1));
  } on Object catch (error) {
    print('Handled async error: $error');
  }
}

Future<void> demonstrateStreams() async {
  final names =
      await studentStream().map((student) => student.fullName).toList();
  print('\nStream loaded ${names.length} students: $names');
}

Future<void> demonstrateFileOperations() async {
  const files = [
    'data/students_part1.json',
    'data/students_part2.json',
    'data/students_part3.json',
  ];
  final watch = Stopwatch()..start();
  final sequential = <Student>[];
  for (final filename in files) {
    sequential.addAll(await loadStudentsFromFile(filename));
  }
  watch.stop();
  final sequentialMicros = watch.elapsedMicroseconds;

  watch
    ..reset()
    ..start();
  final groups = await Future.wait(files.map(loadStudentsFromFile));
  watch.stop();
  final parallelMicros = watch.elapsedMicroseconds;
  final students = groups.expand((group) => group).toList();
  final sequentialById = {
    for (final student in sequential) student.id: jsonEncode(student.toJson()),
  };
  final parallelById = {
    for (final student in students) student.id: jsonEncode(student.toJson()),
  };

  final report = {
    'studentCount': students.length,
    'averageGpa': students.isEmpty
        ? 0.0
        : students.map((student) => student.gpa).reduce((a, b) => a + b) /
            students.length,
    'topStudents': DataProcessor.sortStudentsByGPA(students).take(3).toList(),
    'timingsMicroseconds': {
      'sequential': sequentialMicros,
      'parallel': parallelMicros,
    },
    'timingNote':
        'Small local files may be faster either way; timings are machine-dependent.',
  };
  await saveReportToFile('data/async_report.json', report);
  print(
    '\nFile I/O: read ${students.length} records from ${files.length} JSON files.',
  );
  print(
      'Sequential read: $sequentialMicrosµs; parallel read: $parallelMicrosµs.');
  print(
    'Sequential and parallel results match: ${mapEquals(sequentialById, parallelById)}',
  );
  print('Saved data/async_report.json');
  await _demonstrateStreamTransform();
}

bool mapEquals(Map<String, String> first, Map<String, String> second) {
  if (first.length != second.length) return false;
  return first.entries.every((entry) => second[entry.key] == entry.value);
}

Future<void> _demonstrateStreamTransform() async {
  final random = Random(4);
  final sample = Stream<int>.fromIterable(
    List.generate(8, (_) => random.nextInt(100)),
  );
  final highValues = await sample.where((value) => value >= 50).toList();
  print('Stream transform (sample values >= 50): $highValues');
}
