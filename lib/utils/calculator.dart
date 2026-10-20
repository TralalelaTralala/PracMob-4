class Calculator {
  double add(num a, num b) => (a + b).toDouble();

  double subtract(num a, num b) => (a - b).toDouble();

  double multiply(num a, num b) => (a * b).toDouble();

  double divide(num a, num b) {
    if (b == 0) throw ArgumentError.value(b, 'b', 'Cannot divide by zero.');
    return a / b;
  }

  int modulo(int a, int b) {
    if (b == 0) throw ArgumentError.value(b, 'b', 'Cannot use zero divisor.');
    return a % b;
  }

  double power(num base, num exponent) =>
      _integerPower(base.toDouble(), exponent.toInt());

  double _integerPower(double base, int exponent) {
    if (exponent < 0) return 1 / _integerPower(base, -exponent);
    var result = 1.0;
    for (var i = 0; i < exponent; i++) {
      result *= base;
    }
    return result;
  }
}
