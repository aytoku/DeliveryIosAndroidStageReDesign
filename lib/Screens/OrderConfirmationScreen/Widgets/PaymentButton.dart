import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PaymentButton extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
// TODO: implement build
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 43,
      decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(5)
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Text('Оплатить',
                style: TextStyle(
                    fontSize: 21,
                    letterSpacing: 0.4,
                    color: Colors.white,
                    fontWeight: FontWeight.w600
                ),
              ),
            ),
            SvgPicture.asset((Platform.isIOS)
                ? 'assets/svg_images/apple_pay_logo.svg'
                : 'assets/svg_images/google_pay_logo.svg')
          ],
        ),
      ),
    );
  }
}