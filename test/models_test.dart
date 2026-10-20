import 'package:prac_mob4/models/course.dart';
import 'package:prac_mob4/models/student.dart';
import 'package:prac_mob4/models/university.dart';
import 'package:test/test.dart';

Student makeStudent({
  String id = 's1',
  List<String>? courses,
  Map<String, double>? grades,
}) =>
    Student(
      id: id,
      firstName: 'Olena',
      lastName: 'Bondar',
      birthDate: DateTime(2004, 2, 8),
      enrollmentYear: 2023,
      enrolledCourses: courses,
      grades: grades,
    );

void main() {
  group('Student', () {
    test('computes full name, GPA, and passed courses', () {
      final student = makeStudent(
        courses: ['dart', 'oop'],
        grades: {'dart': 90, 'oop': 55},
      );
      expect(student.fullName, 'Olena Bondar');
      expect(student.gpa, 72.5);
      expect(student.getPassedCourses(), ['dart']);
    });

    test('JSON round-trip preserves student data', () {
      final student = makeStudent(courses: ['dart'], grades: {'dart': 87.5});
      final restored = Student.fromJson(student.toJson());
      expect(restored.id, student.id);
      expect(restored.fullName, student.fullName);
      expect(restored.grades, student.grades);
      expect(restored.skills, student.skills);
    });

    test('grade requires enrollment and must be between 0 and 100', () {
      final student = makeStudent();
      expect(() => student.addGrade('dart', 75), throwsStateError);
      student.enrollInCourse('dart');
      student.addGrade('dart', 75);
      expect(student.grades['dart'], 75);
      expect(() => student.addGrade('dart', 101), throwsRangeError);
    });
  });

  group('Course and University', () {
    test('prerequisites block enrollment until passed', () {
      final student = makeStudent(courses: ['intro'], grades: {'intro': 59});
      final course = Course(
        id: 'advanced',
        name: 'Advanced',
        description: 'Prereqs',
        credits: 3,
        instructor: 'Teacher',
        prerequisites: ['intro'],
      );
      expect(course.canStudentEnroll(student), isFalse);
      student.grades['intro'] = 60;
      expect(course.canStudentEnroll(student), isTrue);
    });

    test('university CRUD, enrollment, grades and statistics work', () {
      final student = makeStudent();
      final uni = University(name: 'Test University', students: [student]);
      uni.addCourse(
        Course(
          id: 'dart',
          name: 'Dart',
          description: 'Basics',
          credits: 4,
          instructor: 'Teacher',
        ),
      );
      expect(uni.enrollStudentInCourse('s1', 'dart'), isTrue);
      expect(uni.addGrade('s1', 'dart', 88), isTrue);
      expect(uni.generateStatistics()['studentCount'], 1);
      expect(uni.getStudentsByCourse('dart'), [student]);
      uni.removeCourse('dart');
      expect(student.enrolledCourses, isEmpty);
      expect(student.grades, isEmpty);
      uni.removeStudent('s1');
      expect(uni.findStudentById('s1'), isNull);
    });

    test('duplicate identifiers are rejected', () {
      final uni = University(name: 'Test');
      uni.addStudent(makeStudent());
      expect(() => uni.addStudent(makeStudent()), throwsArgumentError);
    });
  });
}
