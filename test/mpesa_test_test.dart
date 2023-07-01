import 'package:mpesa/src/mpesa_base/mpesa.dart';
import 'package:mpesa/src/mpesa_base/mpesa_response.dart';
import 'package:test/test.dart';

void main() {
  group('Mpesa', () {
    late Mpesa mpesa;

    setUp(() {
      mpesa = Mpesa(
        clientKey: 'your_client_key',
        clientSecret: 'your_client_secret',
        environment: 'sandbox',
        passKey: 'your_pass_key',
      );
    });

    test('Authentication should return access token', () async {
      final token = await mpesa.authenticate();
      expect(token, isNotEmpty);
    });

    test('Lipa na Mpesa should return MpesaResponse', () async {
      const phoneNumber = '254712345678';
      const amount = 100.0;
      const callbackUrl = 'https://your_callback_url.com';
      const businessShortCode = 'your_business_short_code';

      final response = await mpesa.lipaNaMpesa(
        phoneNumber: phoneNumber,
        amount: amount,
        callbackUrl: callbackUrl,
        businessShortCode: businessShortCode,
      );

      expect(response, isA<MpesaResponse>());
      expect(response.MerchantRequestID, isNotEmpty);
      expect(response.CheckoutRequestID, isNotEmpty);
      expect(response.ResponseCode, isNotEmpty);
      expect(response.ResponseDescription, isNotEmpty);
      expect(response.CustomerMessage, isNotEmpty);
    });

    test('Lipa na Mpesa should throw exception for invalid amount', () async {
      const phoneNumber = '254712345678';
      const amount = 0.5;
      const callbackUrl = 'https://your_callback_url.com';
      const businessShortCode = 'your_business_short_code';

      expect(
        () => mpesa.lipaNaMpesa(
          phoneNumber: phoneNumber,
          amount: amount,
          callbackUrl: callbackUrl,
          businessShortCode: businessShortCode,
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('Lipa na Mpesa should throw exception for missing businessShortCode',
        () async {
      const phoneNumber = '254712345678';
      const amount = 100.0;
      const callbackUrl = 'https://your_callback_url.com';

      expect(
        () => mpesa.lipaNaMpesa(
          phoneNumber: phoneNumber,
          amount: amount,
          callbackUrl: callbackUrl,
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}
