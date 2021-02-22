import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/Amplitude/amplitude.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/Screens/CartScreen/API/change_item_count_in_cart.dart';
import 'package:flutter_app/Screens/CartScreen/API/delete_item_from_cart.dart';
import 'package:flutter_app/Screens/CartScreen/Model/CartModel.dart';
import 'package:flutter_app/Screens/CartScreen/Widgets/Counter.dart';
import 'package:flutter_app/Screens/CartScreen/Widgets/PriceField.dart';
import 'package:flutter_app/Screens/CartScreen/Widgets/TotalPrice.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Model/ProductsByStoreUuid.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../data/data.dart';
import '../../Model/ProductsByStoreUuid.dart';
import 'Item.dart';

class MenuItemDesc extends StatefulWidget {
  GlobalKey<PriceFieldState> priceFieldKey;
  GlobalKey<MenuItemDescState> menuItemCounterKey;
  ProductsByStoreUuid foodRecords;
  MenuItemState parent;
  MenuItemDesc({this.menuItemCounterKey, this.priceFieldKey, this.foodRecords, this.parent}) : super(key: menuItemCounterKey);

  @override
  MenuItemDescState createState() {
    return new MenuItemDescState(priceFieldKey, this.foodRecords, this.parent, this.menuItemCounterKey);
  }
}

class MenuItemDescState extends State<MenuItemDesc> {
  GlobalKey<PriceFieldState> priceFieldKey;
  ProductsByStoreUuid foodRecords;
  Item item;
  GlobalKey<MenuItemDescState> menuItemCounterKey;

  MenuItemState parent;

  MenuItemDescState(this.priceFieldKey, this.foodRecords, this.parent, this.menuItemCounterKey);

  int counter = 1;

  Item findCartItem(ProductsByStoreUuid product){
    var item;
    try {
      item = currentUser.cartModel.items.firstWhere((element) => element.product.uuid == product.uuid);
    }catch(e){
      item = null;
    }
    return item;
  }

  Widget build(BuildContext context) {
    item = findCartItem(foodRecords);
    if(item == null){
      return Padding(
        padding: const EdgeInsets.only(left: 15.0, bottom: 0, top: 5),
        child: Align(
          alignment: Alignment.topLeft,
          child: Text(
            '${foodRecords.weight.toStringAsFixed(0)}' + '' + foodRecords.weightMeasurement,
            style: TextStyle(
                fontSize: 10.0,
                color: Colors.grey),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }

    counter = 0;
    for(int i = 0; i<currentUser.cartModel.items.length; i++){
      var element = currentUser.cartModel.items[i];
      if(element.product.uuid == foodRecords.uuid){
        counter += element.count;
      }
    }

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0, bottom: 0, top: 5),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              '${foodRecords.weight.toStringAsFixed(0)}' + '' + foodRecords.weightMeasurement,
              style: TextStyle(
                  fontSize: 10.0,
                  color: Colors.grey),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5.0, top: 5, right: 5),
          child: SvgPicture.asset('assets/svg_images/ellipse.svg'),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            '${foodRecords.price} \₽',
            style: TextStyle(
                fontSize: 10.0,
                color: Colors.grey),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void refresh() {
    setState(() {});
  }
}