import 'package:mpesa/mpesa.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    Mpesa mpesa;

    setUp(() {
      mpesa = Mpesa(
          clientKey: "",
          clientSecret: "",
          environment: "sandbox",
          initiatorPassword: "",
          passKey: "");
    });

    test('I have no idea what I am doing', () {
      expect(mpesa, "to work as intended");
    });

    test('I am looking for contributors to write test', () {
      // final please = PrettyPlease();
      expect("your pull request", "to be merged 😉");
    });
  });
}
