
import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/CartScreen/API/change_item_count_in_cart.dart';
import 'package:flutter_app/Screens/CartScreen/View/cart_screen.dart';
import 'package:flutter_app/Screens/CartScreen/Widgets/PriceField.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../Internet/check_internet.dart';
import '../../../data/data.dart';
import '../API/decriment_cart_item.dart';
import '../API/increment_cart_item_count.dart';
import '../Model/CartModel.dart';
import 'TotalPrice.dart';

class Counter extends StatefulWidget {
  State parent;
  GlobalKey<PriceFieldState> priceFieldKey;
  Item order;
  List<TotalPrice> totalPriceList;
  Counter({Key key, this.priceFieldKey, this.order, this.totalPriceList, this.parent}) : super(key: key);

  @override
  CounterState createState() {
    return new CounterState(priceFieldKey, order, totalPriceList, parent);
  }
}

class CounterState extends State<Counter> {
  State parent;
  GlobalKey<PriceFieldState> priceFieldKey;
  List<TotalPrice> totalPriceList;
  Item order;
  CounterState(this.priceFieldKey, this.order, this.totalPriceList, this.parent);

  int counter;

  // ignore: non_constant_identifier_names
  Future<void> _incrementCounter_plus() async {

    currentUser.cartModel = await changeItemCountInCart(necessaryDataForAuth.device_id, order.id, 1);
    if(parent is CartScreenState){
      if((parent as CartScreenState).parent.totalPriceWidget.key.currentState!= null){
        (parent as CartScreenState).parent.totalPriceWidget.key.currentState.setState(() {

        });
      }
    }

    parent.setState(() {

    });

    // setState(() {
    //   counter++;
    //   //updateCartItemQuantity();
    // });
  }

  // ignore: non_constant_identifier_names
  Future<void> _incrementCounter_minus() async {
    currentUser.cartModel = await changeItemCountInCart(necessaryDataForAuth.device_id, order.id, -1);
    if(parent is CartScreenState) {
      if ((parent as CartScreenState).parent.totalPriceWidget.key.currentState != null) {
        (parent as CartScreenState).parent.totalPriceWidget.key.currentState.setState(() {

        });
      }
    }
    parent.setState(() {

    });
    // setState(() {
    //   counter--;
    //   //updateCartItemQuantity();
    // });
  }


  // void updateCartItemQuantity(){
  //   order.count = counter;
  //   priceFieldKey.currentState.setState(() {
  //
  //   });
  //   totalPriceList.forEach((totalPrice) {
  //     if(totalPrice.key.currentState != null)
  //       totalPrice.key.currentState.setState(() {
  //
  //       });
  //   });
  // }

  Widget build(BuildContext context) {
    counter = order.count;
    return Row(
        children: [
          InkWell(
            onTap: () async {
              if (counter != 1) {
                await _incrementCounter_minus();
                // counter = restaurantDataItems.records_count;
              }
            },
            child: SvgPicture.asset('assets/svg_images/rest_minus.svg'),
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.only(right: 15, left: 15),
              child: Center(
                child: Text(
                  '$counter',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              if (await Internet.checkConnection()) {
                await _incrementCounter_plus();
                // setState(() {
                //
                //   // counter = restaurantDataItems.records_count;
                // });
              } else {
                noConnection(context);
              }
            },
            child: SvgPicture.asset('assets/svg_images/rest_plus.svg'),
          ),
        ]);
  }

  void refresh() {
    setState(() {});
  }
}