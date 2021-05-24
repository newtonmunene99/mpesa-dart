/// Holds all routes required
class Routes {
  /// Production environment base url
  static const String production = "https://api.safaricom.co.ke";

  /// Sandbox environment base url
  static const String sandbox = "https://sandbox.safaricom.co.ke";

  /// OAuth endpoint
  static const String oauth =
      "/oauth/v1/generate?grant_type=client_credentials";

  /// Business to Consumer(B2C) endpoint
  static const String b2c = "/mpesa/b2c/v1/paymentrequest";

  /// Business to Business(B2B) endpoint
  static const String b2b = "/mpesa/b2b/v1/paymentrequest";

  /// Customer to Business(C2B) register endpoint
  static const String c2bregister = "/mpesa/c2b/v1/registerurl";

  /// Customer to Business(C2B) simulate endpoint
  static const String c2bsimulate = "/mpesa/c2b/v1/simulate";

  /// Account balance endpoint
  static const String accountbalance = "/mpesa/accountbalance/v1/query";

  /// Transaction status endpoint
  static const String transactionstatus = "/mpesa/transactionstatus/v1/query";

  /// Reversal endpoint
  static const String reversal = "/mpesa/reversal/v1/request";

  /// Stk push endpoint
  static const String stkpush = "/mpesa/stkpush/v1/processrequest";

  /// Stk query endpoint
  static const String stkquery = "/mpesa/stkpushquery/v1/query";
}
