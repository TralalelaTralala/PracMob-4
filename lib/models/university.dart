import 'course.dart';
import 'student.dart';

abstract class Person {
  final String id;
  final String firstName;
  final String lastName;
  final DateTime birthDate;

  Person({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
  });

  String get fullName => '$firstName $lastName';

  int get age {
    final now = DateTime.now();
    var years = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      years--;
    }
    return years;
  }

  String get role;

  @override
  String toString() => '$role($id, $fullName, age: $age)';
}

class Professor extends Person {
  final String department;
  final List<String> taughtCourses;
  final double salary;

  Professor({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.birthDate,
    required this.department,
    required this.salary,
    List<String>? taughtCourses,
  }) : taughtCourses = List<String>.from(taughtCourses ?? const []);

  @override
  String get role => 'Professor';

  void assignCourse(String courseId) {
    if (!taughtCourses.contains(courseId)) taughtCourses.add(courseId);
  }

  @override
  String toString() =>
      '${super.toString()}, department: $department, courses: ${taughtCourses.length}';
}

class University {
  final String name;
  final List<Student> students;
  final List<Professor> professors;
  final List<Course> courses;

  University({
    required this.name,
    List<Student>? students,
    List<Professor>? professors,
    List<Course>? courses,
  })  : students = List<Student>.from(students ?? const []),
        professors = List<Professor>.from(professors ?? const []),
        courses = List<Course>.from(courses ?? const []);

  void addStudent(Student student) {
    if (findStudentById(student.id) != null) {
      throw ArgumentError('Student id already exists: ${student.id}');
    }
    students.add(student);
  }

  void removeStudent(String studentId) {
    students.removeWhere((student) => student.id == studentId);
  }

  Student? findStudentById(String id) {
    for (final student in students) {
      if (student.id == id) return student;
    }
    return null;
  }

  void addProfessor(Professor professor) {
    if (professors.any((item) => item.id == professor.id)) {
      throw ArgumentError('Professor id already exists: ${professor.id}');
    }
    professors.add(professor);
  }

  void removeProfessor(String professorId) {
    professors.removeWhere((professor) => professor.id == professorId);
  }

  void addCourse(Course course) {
    if (courses.any((item) => item.id == course.id)) {
      throw ArgumentError('Course id already exists: ${course.id}');
    }
    courses.add(course);
    final assignedProfessor = professors.where(
      (item) => item.fullName == course.instructor,
    );
    if (assignedProfessor.isNotEmpty) {
      assignedProfessor.first.assignCourse(course.id);
    }
  }

  void removeCourse(String courseId) {
    courses.removeWhere((course) => course.id == courseId);
    for (final student in students) {
      student.enrolledCourses.remove(courseId);
      student.grades.remove(courseId);
    }
    for (final professor in professors) {
      professor.taughtCourses.remove(courseId);
    }
  }

  Course? findCourseById(String id) {
    for (final course in courses) {
      if (course.id == id) return course;
    }
    return null;
  }

  bool enrollStudentInCourse(String studentId, String courseId) {
    final student = findStudentById(studentId);
    final course = findCourseById(courseId);
    if (student == null ||
        course == null ||
        !course.canStudentEnroll(student)) {
      return false;
    }
    student.enrollInCourse(courseId);
    return true;
  }

  bool addGrade(String studentId, String courseId, double grade) {
    final student = findStudentById(studentId);
    if (student == null || !student.enrolledCourses.contains(courseId)) {
      return false;
    }
    student.addGrade(courseId, grade);
    return true;
  }

  List<Student> getStudentsByCourse(String courseId) => students
      .where((student) => student.enrolledCourses.contains(courseId))
      .toList();

  List<Course> getAvailableCoursesForStudent(String studentId) {
    final student = findStudentById(studentId);
    if (student == null) return [];
    return courses.where((course) => course.canStudentEnroll(student)).toList();
  }

  Map<String, dynamic> generateStatistics() {
    final averageGpa = students.isEmpty
        ? 0.0
        : students.map((student) => student.gpa).reduce((a, b) => a + b) /
            students.length;
    final courseLoads = <String, int>{
      for (final course in courses)
        course.id: getStudentsByCourse(course.id).length,
    };
    final topStudents = List<Student>.from(students)
      ..sort((a, b) => b.gpa.compareTo(a.gpa));
    return {
      'university': name,
      'studentCount': students.length,
      'professorCount': professors.length,
      'courseCount': courses.length,
      'averageGpa': averageGpa,
      'courseEnrollments': courseLoads,
      'topStudents':
          topStudents.take(3).map((student) => student.fullName).toList(),
    };
  }
}
