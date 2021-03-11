import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mad_pay/mad_pay.dart';

class ApplePay extends StatefulWidget {
  @override
  ApplePayState createState() => ApplePayState();
}

class ApplePayState extends State<ApplePay> {
  final MadPay pay = MadPay();
  final List<PaymentItem> items = <PaymentItem>[
    PaymentItem(name: 'T-Shirt', price: 2.98),
    PaymentItem(name: 'Trousers', price: 15.24),
  ];

  String result = 'Result will be shown here';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(result),
              TextButton(
                onPressed: () async {
                  try {
                    final bool req = await pay.checkPayments();
                    setState(() {
                      result = 'Can make payments: $req';
                    });
                  } catch (e) {
                    setState(() {
                      result = 'Error:\n$e';
                    });
                  }
                },
                child: const Text('Can make payments?'),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    final bool req = await pay.checkActiveCard(
                      paymentNetworks: <PaymentNetwork>[
                        PaymentNetwork.visa,
                        PaymentNetwork.mastercard,
                      ],
                    );
                    setState(() {
                      result = 'Can make payments with verified card: $req';
                    });
                  } catch (e) {
                    setState(() {
                      result = 'Error:\n$e';
                    });
                  }
                },
                child: const Text('Can make payments with verified card?'),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    final Map<String, String> req =
                    await pay.processingPayment(
                      google: GoogleParameters(
                        gatewayName: 'example',
                        gatewayMerchantId: 'example_id',
                      ),
                      apple: AppleParameters(
                        merchantIdentifier: 'example_id',
                      ),
                      currencyCode: 'USD',
                      countryCode: 'US',
                      paymentItems: items,
                      paymentNetworks: <PaymentNetwork>[
                        PaymentNetwork.visa,
                        PaymentNetwork.mastercard,
                      ],
                    );
                    setState(() {
                      result = 'Try to pay:\n$req';
                    });
                  } catch (e) {
                    setState(() {
                      result = 'Error:\n$e';
                    });
                  }
                },
                child: const Text('Try to pay?'),
              )
            ],
          ),
        ),
      ),
    );
  }
}