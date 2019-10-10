import 'package:flutter/material.dart';
import 'package:mpesa/mpesa.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Mpesa _mpesa = Mpesa(
    clientKey: "qPB2VrkOdN0mHzwuKbfBdxghTB8BxDB0",
    clientSecret: "JcmP4DBFZc3CjXo0",
    passKey: "bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919",
    initiatorPassword: "Safaricom007@",
    environment: "sandbox",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: RaisedButton(
            child: Text("PAY"),
            onPressed: () {
              _mpesa
                  .lipaNaMpesa(
                    phoneNumber: "254792274634",
                    amount: 1,
                    businessShortCode: "174379",
                    callbackUrl:
                        "https://darajaendpoint-git-master.newtonmunene99.now.sh/callback",
                  )
                  .then((result) {})
                  .catchError((error) {});
            },
          ),
        ),
      ),
    );
  }
}
