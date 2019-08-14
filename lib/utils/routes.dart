class Routes {
  static final String production = "https://api.safaricom.co.ke";
  static final String sandbox = "https://sandbox.safaricom.co.ke";
  static final String oauth =
      "/oauth/v1/generate?grant_type=client_credentials";
  static final String b2c = "/mpesa/b2c/v1/paymentrequest";
  static final String b2b = "/mpesa/b2b/v1/paymentrequest";
  static final String c2bregister = "/mpesa/c2b/v1/registerurl";
  static final String c2bsimulate = "/mpesa/c2b/v1/simulate";
  static final String accountbalance = "/mpesa/accountbalance/v1/query";
  static final String transactionstatus = "/mpesa/transactionstatus/v1/query";
  static final String reversal = "/mpesa/reversal/v1/request";
  static final String stkpush = "/mpesa/stkpush/v1/processrequest";
  static final String stkquery = "/mpesa/stkpushquery/v1/query";
}
