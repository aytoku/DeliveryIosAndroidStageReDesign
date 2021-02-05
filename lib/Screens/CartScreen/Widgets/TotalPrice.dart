import 'package:flutter/material.dart';
import 'package:flutter_app/data/data.dart';

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
    // currentUser.cartModel.cart.forEach(
    //         (Order order) {
    //       if(order.food.variants != null && order.food.variants.length > 0 && order.food.variants[0].price != null){
    //         totalPrice += order.quantity * (order.food.price + order.food.variants[0].price);
    //       }else{
    //         totalPrice += order.quantity * order.food.price;
    //       }
    //       double toppingsCost = 0;
    //       if(order.food.toppings != null){
    //         order.food.toppings.forEach((element) {
    //           toppingsCost += order.quantity * element.price;
    //         });
    //         totalPrice += toppingsCost;
    //       }
    //     }
    // );
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
          '${totalPrice.toStringAsFixed(0)} \₽',
          style: TextStyle(
              fontSize: 18.0,
              color: Colors.black)),
    );
  }
}