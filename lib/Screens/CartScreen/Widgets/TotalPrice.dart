import 'package:flutter/material.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/data/global_variables.dart';


class TotalPrice extends StatefulWidget {
  GlobalKey<TotalPriceState> key;
  TotalPrice({this.key}) : super(key: key);

  @override
  TotalPriceState createState() {
    return new TotalPriceState();
  }
}

class TotalPriceState extends State<TotalPrice> {

  TotalPriceState();

  Widget build(BuildContext context) {
    double totalPrice = currentUser.cartModel.totalPrice + currentUser.cartModel.deliveryPrice * 1.0;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
          '${totalPrice.toStringAsFixed(0)} \₽',
          style: TextStyle(
              fontSize: 18.0,
              color: AppColor.textColor)),
    );
  }
}