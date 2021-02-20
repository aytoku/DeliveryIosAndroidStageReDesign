
import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Model/ProductsByStoreUuid.dart';

import '../Model/CartModel.dart';
import '../Model/CartModel.dart';

class PriceField extends StatefulWidget {
  Item order;
  ProductsByStoreUuid restaurantDataItems;
  PriceField({Key key, this.order, this.restaurantDataItems}) : super(key: key);

  @override
  PriceFieldState createState() {
    return new PriceFieldState(order, restaurantDataItems);
  }
}

class PriceFieldState extends State<PriceField> {
  int count = 1;
  Item order;
  ProductsByStoreUuid restaurantDataItems;

  PriceFieldState(this.order, this.restaurantDataItems);

  Widget build(BuildContext context) {
    if(order != null){
      return Padding(
        padding: EdgeInsets.only(left: 20),
        child: Text('${order.totalItemPrice.toStringAsFixed(0)} \₽',
            style: TextStyle(
                decoration: TextDecoration.none,
                fontSize: 18.0,
                color: Colors.black)),
      );
    }else if(restaurantDataItems!=null) {
      return Text(
        '${restaurantDataItems.price * count}\₽',
        style: TextStyle(
            fontSize: 15.0,
            color: Color(0xFF000000)),
        overflow: TextOverflow.ellipsis,
      );
    }
    else
      return Container();


  }
  void setCount(int newCount){
    setState(() {
      count = newCount;
    });
  }
}