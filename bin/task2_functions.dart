import 'package:prac_mob4/utils/calculator.dart';
import 'package:prac_mob4/utils/text_analyzer.dart';

void main() {
  print('=== Dart Functions Demo ===');
  testBasicFunctions();
  testAdvancedFunctions();
  testFunctionalProgramming();
  print('\n=== Calculator & Text Analyzer ===');
  final calculator = Calculator();
  print('12 + 8 = ${calculator.add(12, 8)}');
  print('12 / 8 = ${calculator.divide(12, 8)}');
  print('2^8 = ${calculator.power(2, 8)}');
  final analysis = TextAnalyzer().analyze(
    'Dart makes data clear. Dart is productive!',
  );
  print('Text analysis: $analysis');
}

int calculateSum(int a, int b) => a + b;

double calculateAverage(List<double> numbers) {
  if (numbers.isEmpty) return 0;
  return numbers.reduce((a, b) => a + b) / numbers.length;
}

String formatName(
  String firstName,
  String lastName, {
  String? middleName,
  bool uppercase = false,
}) {
  final fullName = [
    firstName,
    if (middleName != null) middleName,
    lastName,
  ].join(' ');
  return uppercase ? fullName.toUpperCase() : fullName;
}

void testBasicFunctions() {
  print(
    '\nBasic: sum=${calculateSum(7, 5)}, average=${calculateAverage([
          80,
          90,
          100
        ])}',
  );
  print('Named/optional: ${formatName('Ira', 'Bondar', middleName: 'O.')}');
}

int Function(int) makeAdder(int amount) => (value) => value + amount;

int fibonacci(int n) {
  if (n < 0) throw ArgumentError.value(n, 'n', 'Must be non-negative.');
  if (n < 2) return n;
  return fibonacci(n - 1) + fibonacci(n - 2);
}

int factorial(int n) {
  if (n < 0) throw ArgumentError.value(n, 'n', 'Must be non-negative.');
  if (n < 2) return 1;
  return n * factorial(n - 1);
}

void testAdvancedFunctions() {
  print('Advanced: fibonacci(8)=${fibonacci(8)}, factorial(6)=${factorial(6)}');
}

void testFunctionalProgramming() {
  final values = [1, 2, 3, 4, 5, 6];
  final doubledEvens =
      values.where((value) => value.isEven).map((value) => value * 2).toList();
  final sum = values.fold<int>(0, (total, value) => total + value);
  final addTen = makeAdder(10);
  print(
    'Functional: even values doubled=$doubledEvens, sum=$sum, closure=${addTen(5)}',
  );
}
