/// Response return by Mpesa request. Please Note that this does not indicate the success or failure of the payment. That will be sent to the callback url you provided. This response only indicates whether the payment request was accepted for processing or not.
class MpesaResponse {
  /// The merchant request id
  String MerchantRequestID;

  /// Unique Checkout request Id. This will be sent along with the success or failure data to the callback url you provide. You can use it to identify a particular payment request.
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
