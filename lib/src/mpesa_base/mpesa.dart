import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mpesa/src/mpesa_base/mpesa_response.dart';
import 'package:mpesa/utils/routes.dart';

/// Initializes a new instance of [Mpesa]
/// Requires 4 parameters:
///
/// 1. `clientKey` - This is your consumer key
///
/// 2. `clientSecret` - This is your consumer secret
///
/// 3. `environment` - This is the environment our app is running on. It can either be `sandbox` or `production`.
///
/// 4. `initiatorPassword` - You can get this from Your Portal(production) or from test credentials(Sandbox). It will be the Security Credential (Shortcode 1)
class Mpesa {
  final String _baseUrl;

  /// 1. `clientKey` - This is your consumer key
  final String clientKey;

  /// 2. `clientSecret` - This is your consumer secret
  final String clientSecret;

  /// 3. `environment` - This is the environment our app is running on. It can either be `sandbox` or `production`.
  final String environment;

  final String _accessToken;

  /// 4. `passKey` - You can get this from Your Portal(production) or from test credentials(Sandbox). It will be the Security Credential (Shortcode 1)
  final String _passKey;

  /// Initializes a new instance of [Mpesa]
  Mpesa({
    required this.clientKey,
    required this.clientSecret,
    required this.environment,
    required String passKey,
  })  : assert(environment == "production" || environment == "sandbox"),
        _passKey = passKey,
        _baseUrl =
            environment == "production" ? Routes.production : Routes.sandbox,
        _accessToken = base64Url.encode("$clientKey:$clientSecret".codeUnits);

  // ignore: public_member_api_docs
  Future<String> authenticate() async {
    try {
      final http.Response response = await http.get(
        Uri.parse("$_baseUrl${Routes.oauth}"),
        headers: {
          "Authorization": "Basic $_accessToken",
        },
      );

      final data = json.decode(response.body);
      final String accessToken = data["access_token"].toString();

      if (response.statusCode != 200) {
        throw Exception('Failed to authenticate with Mpesa API');
      }

      return accessToken;
    } catch (e) {
      throw Exception('Failed to authenticate with Mpesa API: $e');
    }
  }

  /// Triggers a lipa na mpesa stk push and presents user with dialog to input mpesa pin. The method will complete regardless of whether the transaction was successful or not. Results of the transaction are sent to the [callbackUrl] provided. Ensure that the [callbackUrl] provided is publicly accessible. You can use ngrok,local-tunnel or serveo for local development.
  ///
  /// `phoneNumber` is the phone number(MSISDN) to be charged. It must be a registered mpesa number(MSISDN) and should contain the international dialing code i.e `254`. For example `254712345678`
  ///
  /// `amount` is the amount to be charged. During development/sandbox all money transferred is refunded by Safaricom within 24 hours. Please note that this is only applicable if you're using the [businessShortCode] provided by Safaricom and not a real one.
  ///
  /// `callbackUrl` is the URL to which Mpesa responses are sent upon success or failure of a transaction. Should be able to receive post requests.
  ///
  /// `businessShortCode` can be obtained from https://developer.safaricom.co.ke/APIs/MpesaExpressSimulate under the Lipa Na Mpesa Online simulator under PartyB. You can ignore this if you have already set it in [globalBusinessShortCode]. Please note that this is for the sandbox environment. Use your registered business short code for production.
  ///
  /// `transactionType` is the type of transaction. Default value is "CustomerPayBillOnline".
  ///
  /// `accountReference` is used with Mpesa paybill as the account number.
  ///
  /// `transactionDescription` is the description of the transaction. Default value is "Lipa Na Mpesa Online".
  ///
  ///  Please see https://developer.safaricom.co.ke/Documentation for more info.
  Future<MpesaResponse> lipaNaMpesa({
    required String phoneNumber,
    required double amount,
    required String callbackUrl,
    String? businessShortCode,
    String transactionType = "CustomerPayBillOnline",
    String accountReference = "account",
    String transactionDescription = "Lipa Na Mpesa Online",
  }) async {
    if (amount < 1.0) {
      throw Exception("Amount should be at least Ksh 1");
    }

    final now = DateTime.now();
    final payBill = businessShortCode;

    if (payBill == null) {
      throw Exception(
        "Paybill must be set either via businessShortCode or via globalBusinessShortCode",
      );
    }

    final timestamp = _generateTimestamp(now);
    final String password = _generatePassword(payBill, timestamp);

    final String token = await authenticate();

    final String body = json.encode({
      'BusinessShortCode': payBill,
      'Password': password,
      'Timestamp': timestamp,
      'TransactionType': transactionType,
      'Amount': amount,
      'PartyA': phoneNumber,
      'PartyB': payBill,
      'PhoneNumber': phoneNumber,
      'CallBackURL': callbackUrl,
      'AccountReference': accountReference,
      'TransactionDesc': transactionDescription
    });

    final http.Response response = await http.post(
      Uri.parse("$_baseUrl${Routes.stkpush}"),
      body: body,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to process Mpesa transaction');
    }

    return MpesaResponse.fromMap(
      json.decode(response.body) as Map<String, dynamic>,
    );
  }

  String _generateTimestamp(DateTime now) {
    return "${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}";
  }

  String _generatePassword(String paybill, String timestamp) {
    final String rawPassword = paybill + _passKey + timestamp;
    final List<int> passwordBytes = utf8.encode(rawPassword);
    return base64.encode(passwordBytes);
  }
}
