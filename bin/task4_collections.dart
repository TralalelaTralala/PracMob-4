import 'dart:convert';
import 'dart:io';

import 'package:prac_mob4/models/student.dart';
import 'package:prac_mob4/utils/csv_student_processor.dart';
import 'package:prac_mob4/utils/data_processor.dart';

void main() {
  print('=== Dart Collections & Data Processing Demo ===');
  demonstrateLists();
  demonstrateSets();
  demonstrateMaps();
  demonstrateAdvancedOperations();
  final students = CsvStudentProcessor().parse(
    File('data/students.csv').readAsStringSync(),
  );
  final report = CsvStudentProcessor().analyze(students);
  File('data/analysis_report.json')
      .writeAsStringSync(const JsonEncoder.withIndent('  ').convert(report));
  print('\nCSV report (${students.length} students): ${jsonEncode(report)}');
  print('Saved data/analysis_report.json');
}

void demonstrateLists() {
  final scores = [73, 91, 85, 64, 98];
  final sorted = [...scores]..sort();
  final transformed = scores.map((score) => score + 2).toList();
  final total = scores.fold<int>(0, (sum, score) => sum + score);
  print(
    '\nList: sorted=$sorted, >=80=${scores.where((score) => score >= 80).toList()}, +2=$transformed, sum=$total',
  );
  print(
    'Even values via shared processor: ${DataProcessor.filterEvenNumbers(scores)}',
  );
}

void demonstrateSets() {
  final programming = {'Dart', 'SQL', 'Git'};
  final data = {'SQL', 'Python', 'Dart'};
  print(
    '\nSet: union=${programming.union(data)}, intersection=${programming.intersection(data)}, difference=${programming.difference(data)}',
  );
}

void demonstrateMaps() {
  final grades = {'Dart': 92.0, 'SQL': 84.0, 'Git': 90.0};
  final grouped = <String, List<int>>{};
  for (final entry in {
    'Olena': 92,
    'Maksym': 76,
    'Iryna': 88,
    'Taras': 69,
  }.entries) {
    grouped
        .putIfAbsent(
          entry.value >= 80 ? 'pass with distinction' : 'pass',
          () => [],
        )
        .add(entry.value);
  }
  print(
    '\nMap: grades=$grades; average=${grades.values.reduce((a, b) => a + b) / grades.length}',
  );
  print('Grouped scores: $grouped');
}

void demonstrateAdvancedOperations() {
  final nested = <String, List<Map<String, Object>>>{
    'engineering': [
      {'name': 'Olena', 'credits': 24},
      {'name': 'Maksym', 'credits': 18},
    ],
  };
  final flattened = nested.values.expand((students) => students).toList()
    ..sort((a, b) => (b['credits']! as int).compareTo(a['credits']! as int));
  print('\nNested collection sorted by credits: $flattened');
  final demo = [
    Student(
      id: 'x',
      firstName: 'Demo',
      lastName: 'Student',
      birthDate: DateTime(2000),
      skills: ['Dart'],
    ),
  ];
  print('Unique skills example: ${DataProcessor.getUniqueSkills(demo)}');
}
