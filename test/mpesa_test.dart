import 'package:flutter_test/flutter_test.dart';

import 'package:mpesa/mpesa.dart';

void main() {
  // test('adds one to input values', () {
  //   final calculator = Calculator();
  //   expect(calculator.addOne(2), 3);
  //   expect(calculator.addOne(-7), -6);
  //   expect(calculator.addOne(0), 1);
  //   expect(() => calculator.addOne(null), throwsNoSuchMethodError);
  // });

  test('I have no idea what I am doing', () {
    final mpesa = Mpesa();
    expect(mpesa, "to work as intended");
  });

  test('I am looking for contributors to write test', () {
    // final please = PrettyPlease();
    expect("your pull request", "to be merged 😉");
  });
}
