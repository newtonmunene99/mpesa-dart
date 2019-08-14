library mpesa;

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './utils/routes.dart';

/// Initializes a new instance of [Mpesa]
/// Requires 4 parameters:
///
/// 1. `clientKey`
///
/// 2. `clientSecret`
///
/// 3. `environment` - This is the environment our app is running on. It can either be `sandbox` or `production`.
///
/// 4. `initiatorPassword`
class Mpesa {
  final String _baseUrl;
  final String _clientKey;
  final String _clientSecret;
  final String _environment;
  final String _accessToken;
  final String _passKey;
  String _securityCredential;
  String _globalBusinessShortCode;

  Mpesa({
    @required String clientKey,
    @required String clientSecret,
    @required String environment,
    @required String initiatorPassword,
    @required String passKey,
  })  : assert(clientKey != null),
        assert(clientSecret != null),
        assert(environment != null),
        assert(initiatorPassword != null),
        assert(passKey != null),
        _clientKey = clientKey,
        _clientSecret = clientSecret,
        _environment = environment,
        _passKey = passKey,
        _baseUrl =
            environment == "production" ? Routes.production : Routes.sandbox,
        _accessToken =
            base64Url.encode((clientKey + ":" + clientSecret).codeUnits) {
    // _generateSecurityCredential(password: "", certificatepath: null);
  }

  /// You can use this to set the [businessShortCode] and you won't have to pass it everywhere. If you use this make sure to call it before any other method.
  set setGlobalBusinessShortCode(String shortCode) {
    _globalBusinessShortCode = shortCode;
  }

  Future<String> _authenticate() async {
    try {
      http.Response response = await http.get(
        "$_baseUrl${Routes.oauth}",
        headers: {
          "Authorization": "Basic $_accessToken",
        },
      );
      var data = json.decode(response.body);
      return data["access_token"];
    } catch (e) {
      throw e;
    }
  }

  // _generateSecurityCredential({String password, String certificatepath}) {
  //   var certificate;
  //   final publicKeyFile = File('./keys/sandbox-cert.cer');
  //   final parser = RSAKeyParser();

  //   final RSAPublicKey publicKey =
  //       parser.parse(publicKeyFile.readAsStringSync());
  //   final encrypter = Encrypter(RSA(publicKey: publicKey));
  // }

  /// Triggers a lipa na mpesa stk push and presents user with dialog to input mpesa pin. The method will complete regardless of whether the transaction was successful or not. Results of the transaction are sent to the [callbackUrl] provided. Ensure that the [callbackUrl] provided is publicly accessible. You can use ngrok,localtunnel or serveo for local development.
  ///
  /// `businessShortCode` can be gotten from https://developer.safaricom.co.ke/test_credentials under Lipa Na Mpesa Online Shortcode. You can ignore this if you have already used [setGlobalBusinessShortCode]
  ///
  /// `phoneNumber` is the phone number to be charged. It must be a registered mpesa number and should contain the country code i.e `254`. For example `254712345678`
  ///
  /// `amount` is the amount to be charged. During development/sandbox all money transfered is refunded by safaricom within 24 hours. Please note that this is only applicable if you're using the [businessShortCode] provided by Safaricom and not a real one.
  ///
  /// `callbackUrl` is the url to which Mpesa responses are sent upon success or failure of a transaction. Should be able to receive post requests.
  ///
  /// `accountReference` used with Mpesa paybills,
  ///
  ///  Please see https://developer.safaricom.co.ke/docs#lipa-na-m-pesa-online-payment for more info.
  Future<Map> lipaNaMpesa({
    @required String phoneNumber,
    @required double amount,
    @required String callbackUrl,
    String businessShortCode,
    String transactionType = "CustomerPaybillOnline",
    String accountReference = "account",
    String transactionDescription = "Lipa Na Mpesa",
  }) async {
    try {
      var date = DateTime.now();
      var _paybill = businessShortCode ?? _globalBusinessShortCode;
      var _timestamp =
          "${date.year}${date.month}${date.day}${date.hour}${date.minute}${date.second}";
      var _password =
          base64Url.encode((_paybill + _passKey + _timestamp).codeUnits);

      var token = await _authenticate();

      http.Response response = await http.post(
        "$_baseUrl${Routes.stkpush}",
        body: {
          "BusinessShortCode": _paybill,
          "Password": _password,
          "Timestamp": _timestamp,
          "TransactionType": transactionType,
          "Amount": amount,
          "PartyA": phoneNumber,
          "PartyB": _paybill,
          "PhoneNumber": phoneNumber,
          "CallbackURL": callbackUrl,
          "AccountReference": accountReference,
          "TransactionDesc": transactionDescription
        },
        headers: {
          "Authorization": "Bearer $token",
        },
      );
      return json.decode(response.body);
    } catch (e) {
      throw e;
    }
  }
}
