import '../models/student.dart';
import '../models/university.dart';

class DataProcessor {
  static List<int> filterEvenNumbers(List<int> numbers) =>
      numbers.where((number) => number.isEven).toList();

  static Map<String, int> countWords(String text) {
    final cleaned = text.toLowerCase().replaceAll(
          RegExp(r"[^A-Za-zА-Яа-яЁёІіЇїЄєҐґ0-9\s'-]"),
          ' ',
        );
    final words =
        cleaned.split(RegExp(r'\s+')).where((word) => word.isNotEmpty);
    final counts = <String, int>{};
    for (final word in words) {
      counts.update(word, (count) => count + 1, ifAbsent: () => 1);
    }
    return counts;
  }

  static List<Map<String, dynamic>> sortStudentsByGPA(List<Student> students) {
    final sorted = List<Student>.from(students)
      ..sort((a, b) => b.gpa.compareTo(a.gpa));
    return sorted
        .map(
          (student) => {
            'id': student.id,
            'name': student.fullName,
            'gpa': student.gpa,
            'year': student.enrollmentYear,
          },
        )
        .toList();
  }

  static Set<String> getUniqueSkills(List<Student> students) => students
      .expand((student) => student.skills)
      .map((skill) => skill.trim())
      .where((skill) => skill.isNotEmpty)
      .toSet();

  static Set<String> findCommonCourses(List<Student> students) {
    if (students.isEmpty) return {};
    final common = students.first.enrolledCourses.toSet();
    for (final student in students.skip(1)) {
      common.retainAll(student.enrolledCourses);
    }
    return common;
  }

  static Map<String, List<Student>> groupStudentsByYear(
    List<Student> students,
  ) {
    final groups = <String, List<Student>>{};
    for (final student in students) {
      groups
          .putIfAbsent(student.enrollmentYear.toString(), () => [])
          .add(student);
    }
    return groups;
  }

  static Map<String, double> calculateAverageGradesByCourse(
    List<Student> students,
  ) {
    final totals = <String, double>{};
    final counts = <String, int>{};
    for (final student in students) {
      for (final grade in student.grades.entries) {
        totals.update(
          grade.key,
          (total) => total + grade.value,
          ifAbsent: () => grade.value,
        );
        counts.update(grade.key, (count) => count + 1, ifAbsent: () => 1);
      }
    }
    return {
      for (final courseId in totals.keys)
        courseId: totals[courseId]! / counts[courseId]!,
    };
  }

  static Map<String, dynamic> generateReport(University university) {
    final statistics = university.generateStatistics();
    return {
      ...statistics,
      'averageGradesByCourse': calculateAverageGradesByCourse(
        university.students,
      ),
      'uniqueSkills': getUniqueSkills(university.students).toList()..sort(),
      'studentsByYear': {
        for (final group in groupStudentsByYear(university.students).entries)
          group.key: group.value.length,
      },
      'studentsByGpa': sortStudentsByGPA(university.students),
    };
  }
}
