import 'package:prac_mob4/models/student.dart';
import 'package:prac_mob4/utils/calculator.dart';
import 'package:prac_mob4/utils/csv_student_processor.dart';
import 'package:prac_mob4/utils/data_processor.dart';
import 'package:prac_mob4/utils/text_analyzer.dart';
import 'package:test/test.dart';

void main() {
  group('Calculator', () {
    final calculator = Calculator();
    test('performs arithmetic operations', () {
      expect(calculator.add(2, 3), 5);
      expect(calculator.subtract(8, 3), 5);
      expect(calculator.multiply(4, 3), 12);
      expect(calculator.divide(9, 2), 4.5);
      expect(calculator.modulo(11, 4), 3);
      expect(calculator.power(2, 5), 32);
    });
    test('rejects zero divisors', () {
      expect(() => calculator.divide(1, 0), throwsArgumentError);
      expect(() => calculator.modulo(1, 0), throwsArgumentError);
    });
  });

  test('text analyzer counts Unicode words, lines, and characters', () {
    final result = TextAnalyzer().analyze('Dart, dart!\nПривіт світ');
    expect(result['words'], 4);
    expect(result['uniqueWords'], 3);
    expect((result['wordFrequencies'] as Map<String, int>)['dart'], 2);
    expect(result['lines'], 2);
  });

  test('collection helpers filter, group, and summarize', () {
    final students = [
      Student(
        id: '1',
        firstName: 'A',
        lastName: 'One',
        birthDate: DateTime(2000),
        enrollmentYear: 2023,
        enrolledCourses: ['dart'],
        grades: {'dart': 80},
        skills: ['Dart'],
      ),
      Student(
        id: '2',
        firstName: 'B',
        lastName: 'Two',
        birthDate: DateTime(2000),
        enrollmentYear: 2023,
        enrolledCourses: ['dart', 'oop'],
        grades: {'dart': 90},
        skills: ['SQL'],
      ),
    ];
    expect(DataProcessor.filterEvenNumbers([1, 2, 3, 4]), [2, 4]);
    expect(DataProcessor.getUniqueSkills(students), {'Dart', 'SQL'});
    expect(DataProcessor.findCommonCourses(students), {'dart'});
    expect(DataProcessor.groupStudentsByYear(students)['2023']!.length, 2);
    expect(DataProcessor.calculateAverageGradesByCourse(students)['dart'], 85);
  });

  test('CSV processor parses sample data and produces a report', () {
    const csv =
        'id,firstName,lastName,birthDate,enrollmentYear,gpa,courses,skills\n'
        'x,Test,Student,2000-01-01,2022,91,dart|oop,Dart|SQL';
    final processor = CsvStudentProcessor();
    final students = processor.parse(csv);
    expect(students, hasLength(1));
    expect(students.single.gpa, 91);
    expect(processor.analyze(students)['studentCount'], 1);
    expect(() => processor.parse('id,name\nx,Student'), throwsFormatException);
  });
}
