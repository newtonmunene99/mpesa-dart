# mpesa

A dart wrapper around mpesa daraja api.

Ready Methods/APIs

- [x] LIPA NA MPESA
- [ ] C2BSIMULATE
- [ ] B2B
- [ ] C2B
- [ ] B2C
- [ ] TRANSACTION STATUS
- [ ] ACCOUNT BALANCE
- [ ] REVERSAL

## Requisites

You Will need a few things from Safaricom before development.

1. Consumer Key
2. Consumer Secret
3. Test Credentials for Development/Sanbox environment

- Login or Register as a Safaricom developer [here](https://developer.safaricom.co.ke/) if you haven't.
- Add a new App [here](https://developer.safaricom.co.ke/MyApps)
- You will be issued with a Consumer Key and Consumer Secret. You will use these to initiate an Mpesa Instance.
- Obtain Test Credentials [here](https://developer.safaricom.co.ke/APIs/MpesaExpressSimulate).
  - The Test Credentials Obtained Are only valid in Sandbox/Development environment. Take note of them.
  - To run in Production Environment you will need real Credentials.
    - To go Live and be issued with real credentials,please refer to [this guide](https://developer.safaricom.co.ke/Documentation)

## Getting Started

Add dependency in pubspec.yaml

```yaml
dependencies:
  mpesa: [ADD_LATEST_VERSION_HERE]
```

Import in your Flutter app or plain dart app.

```dart
import 'package:mpesa/mpesa.dart';

class MYClass {

    Mpesa mpesa = Mpesa(
        clientKey: "YOUR_CONSUMER_KEY_HERE",
        clientSecret: "YOUR_CONSUMER_SECRET_HERE",
        passKey: "YOUR_LNM_PASS_KEY_HERE",
        environment: "sandbox",
    );

}
```

Environment should be either `sandbox` or `production`

## Methods and Api Calls

### Lipa Na Mpesa Online (LNMO)

Lipa na M-Pesa Online Payment API is used to initiate a M-Pesa transaction on behalf of a customer using STK Push. This is the same technique mySafaricom App uses whenever the app is used to make payments.

```dart
import 'package:mpesa/mpesa.dart';

class MYClass {

    myMethod(){
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
}
```

1. businessShortCode - The organization shortcode used to receive the transaction.
2. amount - The amount to be transacted.
3. phoneNumber - The MSISDN sending the funds.
4. callbackUrl - The url to where responses from M-Pesa will be sent to.

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/newtonmunene99/mpesa-dart/issues

## Recording

![Recording](https://github.com/newtonmunene99/mpesa-dart/blob/master/recording.gif)

## Demo App

[Demo App](https://github.com/newtonmunene99/flutter_mpesa_demo)

## Contributing

1. Fork the project then clone the forked project
2. Create your feature branch: `git checkout -b my-new-feature`
3. Make your changes and add name to Contributors list below and in authors in pubspec.yaml
4. Commit your changes: `git commit -m 'Add some feature'`
5. Push to the branch: `git push origin my-new-feature`
6. Submit a pull request.

## Credits

| Contributors                                       |
| -------------------------------------------------- |
| [Newton Munene](https://github.com/newtonmunene99) |

----------------------------

For help getting started with Flutter, view their
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
