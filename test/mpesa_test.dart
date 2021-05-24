import 'package:mpesa/mpesa.dart';
import 'package:test/test.dart';

void main() {
  group('', () {
    late Mpesa mpesa;

    setUp(() {
      mpesa = Mpesa(
        clientKey: "",
        clientSecret: "",
        environment: "sandbox",
        passKey: "",
      );
    });

    test('is instance of Mpesa', () {
      expect(mpesa, isA<Mpesa>());
    });

    test('client key is not null', () {
      expect(mpesa.clientKey, isNotNull);
    });

    test('client secret is not null', () {
      expect(mpesa.clientSecret, isNotNull);
    });

    test('environment is not null', () {
      expect(mpesa.environment, isNotNull);
    });
  });
}
