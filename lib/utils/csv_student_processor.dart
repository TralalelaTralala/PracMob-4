import '../models/student.dart';
import 'data_processor.dart';

class CsvStudentProcessor {
  List<Student> parse(String csv) {
    final lines = csv
        .split(RegExp(r'\r?\n'))
        .where((line) => line.trim().isNotEmpty)
        .toList();
    if (lines.length < 2) return [];

    final headers =
        lines.first.split(',').map((value) => value.trim()).toList();
    const requiredHeaders = {
      'id',
      'firstName',
      'lastName',
      'birthDate',
      'enrollmentYear',
      'gpa',
      'courses',
      'skills',
    };
    if (!headers.toSet().containsAll(requiredHeaders)) {
      throw FormatException('CSV is missing required columns.');
    }

    final students = <Student>[];
    for (final line in lines.skip(1)) {
      final values = line.split(',').map((value) => value.trim()).toList();
      if (values.length != headers.length) {
        throw FormatException(
          'CSV row has ${values.length} values; expected ${headers.length}.',
        );
      }
      final row = Map<String, String>.fromIterables(headers, values);
      final courseIds = _splitList(row['courses']!);
      final grade = double.parse(row['gpa']!);
      students.add(
        Student(
          id: row['id']!,
          firstName: row['firstName']!,
          lastName: row['lastName']!,
          birthDate: DateTime.parse(row['birthDate']!),
          enrollmentYear: int.parse(row['enrollmentYear']!),
          enrolledCourses: courseIds,
          grades: {for (final id in courseIds) id: grade},
          skills: _splitList(row['skills']!),
        ),
      );
    }
    return students;
  }

  Map<String, dynamic> analyze(List<Student> students) => {
        'studentCount': students.length,
        'averageGpa': students.isEmpty
            ? 0.0
            : students.map((student) => student.gpa).reduce((a, b) => a + b) /
                students.length,
        'studentsByYear': {
          for (final group
              in DataProcessor.groupStudentsByYear(students).entries)
            group.key: group.value.length,
        },
        'topStudents':
            DataProcessor.sortStudentsByGPA(students).take(3).toList(),
        'uniqueSkills': DataProcessor.getUniqueSkills(students).toList()
          ..sort(),
      };

  List<String> _splitList(String value) => value
      .split('|')
      .map((item) => item.trim())
      .where((item) => item.isNotEmpty)
      .toList();
}
