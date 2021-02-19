
import 'package:flutter/material.dart';

import '../Model/CartModel.dart';
import '../Model/CartModel.dart';

class PriceField extends StatefulWidget {
  Item order;
  PriceField({Key key, this.order}) : super(key: key);

  @override
  PriceFieldState createState() {
    return new PriceFieldState(order);
  }
}

class PriceFieldState extends State<PriceField> {
  int count = 1;
  Item order;
  PriceFieldState(this.order);

  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20),
      child: Text('${order.totalItemPrice.toStringAsFixed(0)} \₽',
          style: TextStyle(
              decoration: TextDecoration.none,
              fontSize: 18.0,
              color: Colors.black)),
    );
  }
  void setCount(int newCount){
    setState(() {
      count = newCount;
    });
  }
}