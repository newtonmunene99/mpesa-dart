import 'dart:convert';

import 'package:http/http.dart' as http;

import '../utils/routes.dart';

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

  /// Your consumer key
  final String clientKey;

  /// Your consumer secret
  final String clientSecret;

  /// Environment the app is running on. It can either be `sandbox` or `production`
  final String environment;
  final String _accessToken;
  final String _passKey;

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
  Mpesa({
    required this.clientKey,
    required this.clientSecret,
    required this.environment,
    required String passKey,
  })  : assert(environment == "production" || environment == "sandbox"),
        _passKey = passKey,
        _baseUrl =
            environment == "production" ? Routes.production : Routes.sandbox,
        _accessToken = base64Url.encode("$clientKey:$clientSecret".codeUnits) {
    // _generateSecurityCredential(password: "", certificatepath: null);
  }

  Future<String> _authenticate() async {
    try {
      final http.Response response = await http.get(
        Uri.parse("$_baseUrl${Routes.oauth}"),
        headers: {
          "Authorization": "Basic $_accessToken",
        },
      );

      final data = json.decode(response.body);

      return data["access_token"] as String;
    } catch (e) {
      rethrow;
    }
  }

  /// Triggers a lipa na mpesa stk push and presents user with dialog to input mpesa pin. The method will complete regardless of whether the transaction was successful or not. Results of the transaction are sent to the [callbackUrl] provided. Ensure that the [callbackUrl] provided is publicly accessible. You can use ngrok,localtunnel or serveo for local development.
  ///
  /// `businessShortCode` can be gotten from https://developer.safaricom.co.ke/APIs/MpesaExpressSimulate under the Lipa Na Mpesa Online simulator under PartyB. You can ignore this if you have already set it in [globalBusinessShortCode]. Please note that this is for the sandbox environment. Use your registered business short code for production.
  ///
  /// `phoneNumber` is the phone number(MSISDN) to be charged. It must be a registered mpesa number(MSISDN) and should contain the international dialing code i.e `254`. For example `254712345678`
  ///
  /// `amount` is the amount to be charged. During development/sandbox all money transfered is refunded by safaricom within 24 hours. Please note that this is only applicable if you're using the [businessShortCode] provided by Safaricom and not a real one.
  ///
  /// `callbackUrl` is the url to which Mpesa responses are sent upon success or failure of a transaction. Should be able to receive post requests.
  ///
  /// `accountReference` used with Mpesa paybills as account number,
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
      throw "Amount should be at least Ksh 1";
    }

    final _now = DateTime.now();
    final _paybill = businessShortCode;

    if (_paybill == null) {
      throw "Paybill must be set either via businessShortCode or via globalBusinessShortCode";
    }

    final _timestamp =
        "${_now.year}${_now.month.toString().padLeft(2, '0')}${_now.day.toString().padLeft(2, '0')}${_now.hour.toString().padLeft(2, '0')}${_now.minute.toString().padLeft(2, '0')}${_now.second.toString().padLeft(2, '0')}";

    final String _rawPassword = _paybill + _passKey + _timestamp;

    final List<int> _passwordBytes = utf8.encode(_rawPassword);

    final String _password = base64.encode(_passwordBytes);

    final String token = await _authenticate();

    final String _body = json.encode({
      'BusinessShortCode': _paybill,
      'Password': _password,
      'Timestamp': _timestamp,
      'TransactionType': transactionType,
      'Amount': amount,
      'PartyA': phoneNumber,
      'PartyB': _paybill,
      'PhoneNumber': phoneNumber,
      'CallBackURL': callbackUrl.toString(),
      'AccountReference': accountReference,
      'TransactionDesc': transactionDescription
    });

    final http.Response response = await http.post(
      Uri.parse("$_baseUrl${Routes.stkpush}"),
      body: _body,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw json.decode(response.body) as Map<dynamic, dynamic>;
    }

    return MpesaResponse.fromMap(
      json.decode(response.body) as Map<String, dynamic>,
    );
  }
}

/// Response return by Mpesa request. Please Note that this does not indicate the success or failure of the payment. That will be sent to the callback url you provided. This response only indicates whether the payment request was accepted for processing or not.
class MpesaResponse {
  /// The merchant request id
  // ignore: non_constant_identifier_names
  String MerchantRequestID;

  /// Unique Checkout request Id. This will be sent along with the success or failure data to the callback url you provide. You can use it to identify a particular payment request.
  // ignore: non_constant_identifier_names
  String CheckoutRequestID;

  /// M-Pesa Result and Response Codes
  ///
  /// `0` - Success
  ///
  /// `1` - Insufficient Funds
  ///
  /// `2` - Less Than Minimum Transaction Value
  ///
  /// `3` - More Than Maximum Transaction Value
  ///
  /// `4` - Would Exceed Daily Transfer Limit
  ///
  /// `5` - Would Exceed Minimum Balance
  ///
  /// `6` - Unresolved Primary Party
  ///
  /// `7` - Unresolved Receiver Party
  ///
  /// `8` - Would Exceed Maxiumum Balance
  ///
  /// `11` - Debit Account Invalid
  ///
  /// `12` - Credit Account Invalid
  ///
  /// `13` - Unresolved Debit Account
  ///
  /// `14` - Unresolved Credit Account
  ///
  /// `15` - Duplicate Detected
  ///
  /// `17` - Internal Failure
  ///
  /// `20` - Unresolved Initiator
  ///
  /// `26` - Traffic blocking condition in place
  ///
  // ignore: non_constant_identifier_names
  String ResponseCode;

  /// Description of the response gotten
  // ignore: non_constant_identifier_names
  String ResponseDescription;

  /// Message that is user friendly and can be shown to the customer.
  /// Mostly same as [ResponseDescription]
  // ignore: non_constant_identifier_names
  String CustomerMessage;

  /// Response return by Mpesa request. Please Note that this does not indicate the success or failure of the payment. That will be sent to the callback url you provided. This response only indicates whether the payment request was accepted for processing or not.
  MpesaResponse({
    // ignore: non_constant_identifier_names
    required this.MerchantRequestID,
    // ignore: non_constant_identifier_names
    required this.CheckoutRequestID,
    // ignore: non_constant_identifier_names
    required this.ResponseCode,
    // ignore: non_constant_identifier_names
    required this.ResponseDescription,
    // ignore: non_constant_identifier_names
    required this.CustomerMessage,
  });

  /// Create a new instance of [MpesaResponse] by copying values from another instance
  MpesaResponse copyWith({
    // ignore: non_constant_identifier_names
    String? MerchantRequestID,
    // ignore: non_constant_identifier_names
    String? CheckoutRequestID,
    // ignore: non_constant_identifier_names
    String? ResponseCode,
    // ignore: non_constant_identifier_names
    String? ResponseDescription,
    // ignore: non_constant_identifier_names
    String? CustomerMessage,
  }) {
    return MpesaResponse(
      MerchantRequestID: MerchantRequestID ?? this.MerchantRequestID,
      CheckoutRequestID: CheckoutRequestID ?? this.CheckoutRequestID,
      ResponseCode: ResponseCode ?? this.ResponseCode,
      ResponseDescription: ResponseDescription ?? this.ResponseDescription,
      CustomerMessage: CustomerMessage ?? this.CustomerMessage,
    );
  }

  /// [MpesaResponse] as a [Map]
  Map<String, dynamic> toMap() {
    return {
      'MerchantRequestID': MerchantRequestID,
      'CheckoutRequestID': CheckoutRequestID,
      'ResponseCode': ResponseCode,
      'ResponseDescription': ResponseDescription,
      'CustomerMessage': CustomerMessage,
    };
  }

  /// Create an instance of [MpesaResponse] from a [Map]
  factory MpesaResponse.fromMap(Map<String, dynamic> map) {
    return MpesaResponse(
      MerchantRequestID: map['MerchantRequestID'] as String,
      CheckoutRequestID: map['CheckoutRequestID'] as String,
      ResponseCode: map['ResponseCode'] as String,
      ResponseDescription: map['ResponseDescription'] as String,
      CustomerMessage: map['CustomerMessage'] as String,
    );
  }

  @override
  String toString() {
    return 'MpesaResponse(MerchantRequestID: $MerchantRequestID, CheckoutRequestID: $CheckoutRequestID, ResponseCode: $ResponseCode, ResponseDescription: $ResponseDescription, CustomerMessage: $CustomerMessage)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MpesaResponse &&
        other.MerchantRequestID == MerchantRequestID &&
        other.CheckoutRequestID == CheckoutRequestID &&
        other.ResponseCode == ResponseCode &&
        other.ResponseDescription == ResponseDescription &&
        other.CustomerMessage == CustomerMessage;
  }

  @override
  int get hashCode {
    return MerchantRequestID.hashCode ^
        CheckoutRequestID.hashCode ^
        ResponseCode.hashCode ^
        ResponseDescription.hashCode ^
        CustomerMessage.hashCode;
  }
}
