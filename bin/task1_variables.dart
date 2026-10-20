void main() {
  print('=== Dart Variables & Types Demo ===');
  demonstrateNumbers();
  demonstrateStrings();
  demonstrateBooleans();
  demonstrateCollections();
  demonstrateNullSafety();
}

void demonstrateNumbers() {
  const int students = 24;
  const double tuition = 1250.50;
  num total = students * tuition;
  print('\nNumbers: students=$students, tuition=$tuition, total=$total');
  print('Operations: ${students + 6}, ${tuition / 2}, ${students % 5}');
  final converted = total.toStringAsFixed(2);
  print('Conversion: $converted -> ${double.parse(converted)}');
}

void demonstrateStrings() {
  const firstName = 'Olena';
  const lastName = 'Marchenko';
  final fullName = '$firstName $lastName';
  const message = '''Welcome to PracMob4.
Dart strings support multiple lines.''';
  print('\nStrings: $fullName (${fullName.length} characters)');
  print(message.replaceAll('Dart', 'The Dart language'));
  print('Trim/uppercase: ${'  student  '.trim().toUpperCase()}');
  print('Escapes: first line\nsecond line\t(indented)');
}

void demonstrateBooleans() {
  const grade = 87;
  const attended = true;
  final passed = grade >= 60 && attended;
  print('\nBooleans: passed=$passed, excellent=${grade >= 90}');
  print('Conditional: ${passed ? 'eligible for credit' : 'retake required'}');
}

void demonstrateCollections() {
  final scores = <int>[72, 91, 84, 91];
  final uniqueScores = scores.toSet();
  final student = <String, Object>{
    'name': 'Olena',
    'year': 2025,
    'active': true,
  };
  print(
    '\nList: $scores -> even ${scores.where((score) => score.isEven).toList()}',
  );
  print('Set: $uniqueScores; max=${scores.reduce((a, b) => a > b ? a : b)}');
  print('Map: $student');
}

void demonstrateNullSafety() {
  String? optionalNote;
  final note = optionalNote ?? 'No note provided';
  late final String initializedAfterDeclaration;
  initializedAfterDeclaration = 'initialized with late';
  print('\nNull safety: $note; $initializedAfterDeclaration');
}

String formatStudentName({required String firstName, String? middleName}) => [
      firstName,
      if (middleName != null && middleName.isNotEmpty) middleName,
    ].join(' ');
