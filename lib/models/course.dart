import 'student.dart';

class Course {
  final String id;
  final String name;
  final String description;
  final int credits;
  final String instructor;
  final List<String> prerequisites;

  Course({
    required this.id,
    required this.name,
    required this.description,
    required this.credits,
    required this.instructor,
    List<String>? prerequisites,
  }) : prerequisites = List<String>.from(prerequisites ?? const []);

  bool hasPrerequisites() => prerequisites.isNotEmpty;

  bool canStudentEnroll(Student student) {
    if (student.enrolledCourses.contains(id)) return false;
    return student.getPassedCourses().toSet().containsAll(prerequisites);
  }

  @override
  String toString() =>
      'Course($id, $name, $credits credits, instructor: $instructor)';
}
