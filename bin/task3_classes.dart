import 'package:prac_mob4/models/course.dart';
import 'package:prac_mob4/models/student.dart';
import 'package:prac_mob4/models/university.dart';
import 'package:prac_mob4/utils/data_processor.dart';

void main() {
  print('=== University Management System Demo ===');
  runUniversityDemo();
}

void runUniversityDemo() {
  final university = University(name: 'PracMob4 University');
  final professor = Professor(
    id: 'p1',
    firstName: 'Ihor',
    lastName: 'Koval',
    birthDate: DateTime(1982, 5, 12),
    department: 'Computer Science',
    salary: 32000,
  );
  final student1 = Student(
    id: 's1',
    firstName: 'Olena',
    lastName: 'Bondar',
    birthDate: DateTime(2004, 2, 8),
    enrollmentYear: 2023,
    skills: ['Dart', 'SQL'],
  );
  final student2 = Student(
    id: 's2',
    firstName: 'Maksym',
    lastName: 'Shevchenko',
    birthDate: DateTime(2003, 9, 20),
    enrollmentYear: 2022,
    skills: ['Dart', 'Git'],
  );

  university.addProfessor(professor);
  university.addStudent(student1);
  university.addStudent(student2);
  university.addCourse(
    Course(
      id: 'dart-1',
      name: 'Dart Fundamentals',
      description: 'Language basics',
      credits: 4,
      instructor: professor.fullName,
    ),
  );
  university.addCourse(
    Course(
      id: 'oop-2',
      name: 'Object-Oriented Dart',
      description: 'Models and design',
      credits: 5,
      instructor: professor.fullName,
      prerequisites: ['dart-1'],
    ),
  );

  university.enrollStudentInCourse('s1', 'dart-1');
  university.enrollStudentInCourse('s2', 'dart-1');
  university.addGrade('s1', 'dart-1', 92);
  university.addGrade('s2', 'dart-1', 81);
  university.enrollStudentInCourse('s1', 'oop-2');
  university.addGrade('s1', 'oop-2', 88);

  print(
    'People: ${professor.role} ${professor.fullName} teaches ${professor.taughtCourses}',
  );
  print('Students:');
  for (final student in university.students) {
    print('  $student; passed=${student.getPassedCourses()}');
  }
  print(
    'Students in dart-1: ${university.getStudentsByCourse('dart-1').length}',
  );
  print(
    'Available courses for s2: ${university.getAvailableCoursesForStudent('s2').map((c) => c.name).toList()}',
  );
  print('Statistics: ${DataProcessor.generateReport(university)}');
  print('JSON round-trip: ${Student.fromJson(student1.toJson())}');
}
