class Student {
  final String id;
  final String firstName;
  final String lastName;
  final DateTime birthDate;
  final List<String> enrolledCourses;
  final Map<String, double> grades;
  final List<String> skills;
  final int enrollmentYear;

  Student({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    List<String>? enrolledCourses,
    Map<String, double>? grades,
    List<String>? skills,
    int? enrollmentYear,
  })  : enrolledCourses = List<String>.from(enrolledCourses ?? const []),
        grades = Map<String, double>.from(grades ?? const {}),
        skills = List<String>.from(skills ?? const []),
        enrollmentYear = enrollmentYear ?? DateTime.now().year;

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

  double get gpa => grades.isEmpty
      ? 0
      : grades.values.reduce((a, b) => a + b) / grades.length;

  void enrollInCourse(String courseId) {
    if (!enrolledCourses.contains(courseId)) enrolledCourses.add(courseId);
  }

  void addGrade(String courseId, double grade) {
    if (!grade.isFinite || grade < 0 || grade > 100) {
      throw RangeError.range(grade, 0, 100, 'grade');
    }
    if (!enrolledCourses.contains(courseId)) {
      throw StateError('Student must be enrolled in $courseId before grading.');
    }
    grades[courseId] = grade;
  }

  List<String> getPassedCourses({double passMark = 60}) => grades.entries
      .where((entry) => entry.value >= passMark)
      .map((entry) => entry.key)
      .toList()
    ..sort();

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'birthDate': birthDate.toIso8601String(),
        'enrolledCourses': enrolledCourses,
        'grades': grades,
        'skills': skills,
        'enrollmentYear': enrollmentYear,
      };

  factory Student.fromJson(Map<String, dynamic> json) {
    final rawGrades = json['grades'] as Map? ?? const {};
    final parsedGrades = <String, double>{
      for (final entry in rawGrades.entries)
        entry.key.toString(): (entry.value as num).toDouble(),
    };
    return Student(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      birthDate: DateTime.parse(json['birthDate'] as String),
      enrolledCourses: (json['enrolledCourses'] as List<dynamic>? ?? const [])
          .cast<String>(),
      grades: parsedGrades,
      skills: (json['skills'] as List<dynamic>? ?? const []).cast<String>(),
      enrollmentYear: (json['enrollmentYear'] as num?)?.toInt(),
    );
  }

  @override
  String toString() =>
      'Student($id, $fullName, age: $age, GPA: ${gpa.toStringAsFixed(1)})';
}
