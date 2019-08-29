import 'package:mpesa/mpesa.dart';

void main() {
  var mpesa = Mpesa(
    clientKey: "YOUR_CONSUMER_KEY_HERE",
    clientSecret: "YOUR_CONSUMER_SECRET_HERE",
    passKey: "YOUR_LNM_PASS_KEY_HERE",
    initiatorPassword: "YOUR_SECURITY_CREDENTIAL_HERE",
    environment: "sandbox",
  );

  mpesa
      .lipaNaMpesa(
        phoneNumber: "",
        amount: 1,
        businessShortCode: "",
        callbackUrl: "",
      )
      .then((result) {})
      .catchError((error) {});
}
