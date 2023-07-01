import 'package:mpesa/src/mpesa_base/mpesa_response.dart';
import 'package:test/test.dart';

//all pass
void main() {
  group('MpesaResponse', () {
    test('copyWith method should return a new instance with updated values',
        () {
      final response = MpesaResponse(
        MerchantRequestID: '123',
        CheckoutRequestID: '456',
        ResponseCode: '0',
        ResponseDescription: 'Success',
        CustomerMessage: 'Payment successful',
      );

      final updatedResponse = response.copyWith(
        MerchantRequestID: '789',
        CheckoutRequestID: '012',
        ResponseCode: '1',
        ResponseDescription: 'Insufficient Funds',
        CustomerMessage: 'Payment failed',
      );

      expect(updatedResponse.MerchantRequestID, '789');
      expect(updatedResponse.CheckoutRequestID, '012');
      expect(updatedResponse.ResponseCode, '1');
      expect(updatedResponse.ResponseDescription, 'Insufficient Funds');
      expect(updatedResponse.CustomerMessage, 'Payment failed');
    });

    test('toMap method should return a map representation of the response', () {
      final response = MpesaResponse(
        MerchantRequestID: '123',
        CheckoutRequestID: '456',
        ResponseCode: '0',
        ResponseDescription: 'Success',
        CustomerMessage: 'Payment successful',
      );

      final responseMap = response.toMap();

      expect(responseMap['MerchantRequestID'], '123');
      expect(responseMap['CheckoutRequestID'], '456');
      expect(responseMap['ResponseCode'], '0');
      expect(responseMap['ResponseDescription'], 'Success');
      expect(responseMap['CustomerMessage'], 'Payment successful');
    });

    test('fromMap method should create an instance of MpesaResponse from a map',
        () {
      final responseMap = {
        'MerchantRequestID': '123',
        'CheckoutRequestID': '456',
        'ResponseCode': '0',
        'ResponseDescription': 'Success',
        'CustomerMessage': 'Payment successful',
      };

      final response = MpesaResponse.fromMap(responseMap);

      expect(response.MerchantRequestID, '123');
      expect(response.CheckoutRequestID, '456');
      expect(response.ResponseCode, '0');
      expect(response.ResponseDescription, 'Success');
      expect(response.CustomerMessage, 'Payment successful');
    });

    test(
        'toString method should return a string representation of the response',
        () {
      final response = MpesaResponse(
        MerchantRequestID: '123',
        CheckoutRequestID: '456',
        ResponseCode: '0',
        ResponseDescription: 'Success',
        CustomerMessage: 'Payment successful',
      );

      final responseString = response.toString();

      expect(responseString,
          'MpesaResponse(MerchantRequestID: 123, CheckoutRequestID: 456, ResponseCode: 0, ResponseDescription: Success, CustomerMessage: Payment successful)');
    });

    test('equality operator should compare two instances of MpesaResponse', () {
      final response1 = MpesaResponse(
        MerchantRequestID: '123',
        CheckoutRequestID: '456',
        ResponseCode: '0',
        ResponseDescription: 'Success',
        CustomerMessage: 'Payment successful',
      );

      final response2 = MpesaResponse(
        MerchantRequestID: '123',
        CheckoutRequestID: '456',
        ResponseCode: '0',
        ResponseDescription: 'Success',
        CustomerMessage: 'Payment successful',
      );

      final response3 = MpesaResponse(
        MerchantRequestID: '789',
        CheckoutRequestID: '012',
        ResponseCode: '1',
        ResponseDescription: 'Insufficient Funds',
        CustomerMessage: 'Payment failed',
      );

      expect(response1 == response2, true);
      expect(response1 == response3, false);
    });

    test('hashCode method should return the hash code of the response', () {
      final response = MpesaResponse(
        MerchantRequestID: '123',
        CheckoutRequestID: '456',
        ResponseCode: '0',
        ResponseDescription: 'Success',
        CustomerMessage: 'Payment successful',
      );

      final hashCode = response.hashCode;

      expect(hashCode, isA<int>());
    });
  });
}
