import 'package:mpesa/mpesa.dart';
import 'package:mpesa/src/mpesa_base/mpesa_response.dart';
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

//was throwing this error before
//type 'String' is not a subtype of type 'int' in type cast

    test(
        "testing MpesaResponse fromMap  constructor method response code casting",
        () {
      final Map<String, dynamic> demoResponse = {
        "MerchantRequestID": "7623-624922-1",
        "CheckoutRequestID": "ws_CO_110720211339362008",
        "ResponseCode": "0",
        "ResponseDescription": "Success. Request accepted for processing,",
        "CustomerMessage": "Success. Request accepted for processin"
      };
      final MpesaResponse mpesaResponse = MpesaResponse.fromMap(demoResponse);

      expect(mpesaResponse.ResponseCode, '0');
      //the response code is of type string that's why assigning 0 causes the test to fail
    });
  });
}
