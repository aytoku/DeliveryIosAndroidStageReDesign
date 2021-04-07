import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/OrderConfirmationScreen/View/address_screen.dart';
import 'package:flutter_app/Screens/OrderConfirmationScreen/Widgets/AddressSelector.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PaymentButton extends StatefulWidget {
  final AsyncCallback onTap;
  AddressScreenState parent;

  PaymentButton({Key key, this.onTap, this.parent}) : super(key: key);

  @override
  PaymentButtonState createState() {
    return new PaymentButtonState(onTap, parent);
  }
}

class PaymentButtonState extends State<PaymentButton>{
  final AsyncCallback onTap;
  AddressScreenState parent;
  PaymentButtonState(this.onTap, this.parent);
  @override
  Widget build(BuildContext context) {
    double totalPrice = currentUser.cartModel.totalPrice + currentUser.cartModel.deliveryPrice * 1.0;
    if(parent.selectedPaymentName == parent.paymentMethods[0]['tag']){
      return Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 5.0,
                offset: Offset(0.0, 1)
            )
          ],
          color: AppColor.themeColor,),
        child: Padding(
          padding: EdgeInsets.only(bottom: 15, left: 50, right: 20, top: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                      '${(totalPrice).toStringAsFixed(0)} \₽',
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black)),
                  Padding(
                    padding: const EdgeInsets.only(right: 3),
                    child: Text(
                      (currentUser.cartModel.cookingTime != null)
                          ? '~' + '${currentUser.cartModel.cookingTime ~/ 60} мин'
                          : '',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                child: Container(
                  height: 52,
                  width: 168,
                  decoration: BoxDecoration(
                    color: AppColor.mainColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text('Заказать',
                        style: TextStyle(
                            fontSize: 18.0,
                            color: AppColor.unselectedTextColor)),
                  ),
                ),
                onTap: () async {
                  if(onTap != null){
                    await onTap();
                  }
                },
              )
            ],
          ),
        ),
      );
    }
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Container(
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
        ),
      ),
      onTap: () async {
        if(onTap != null){
          await onTap();
        }
      },
    );
  }
}