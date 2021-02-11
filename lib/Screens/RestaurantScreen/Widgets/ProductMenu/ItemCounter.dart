import 'package:flutter/material.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/Screens/CartScreen/Model/CartModel.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Model/ProductsByStoreUuid.dart';
import 'package:flutter_app/Screens/RestaurantScreen/View/restaurant_screen.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/PriceField.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../data/data.dart';
import '../../../CartScreen/API/decriment_cart_item.dart';
import '../../../CartScreen/API/increment_cart_item_count.dart';
import '../../Model/ProductsByStoreUuid.dart';
import 'Item.dart';

class MenuItemCounter extends StatefulWidget {
  GlobalKey<PriceFieldState> priceFieldKey;
  GlobalKey<MenuItemCounterState> menuItemCounterKey;
  ProductsByStoreUuid foodRecords;
  MenuItemState parent;
  MenuItemCounter({this.menuItemCounterKey, this.priceFieldKey, this.foodRecords, this.parent}) : super(key: menuItemCounterKey);

  @override
  MenuItemCounterState createState() {
    return new MenuItemCounterState(priceFieldKey, this.foodRecords, this.parent, this.menuItemCounterKey);
  }
}

class MenuItemCounterState extends State<MenuItemCounter> {
  GlobalKey<PriceFieldState> priceFieldKey;
  ProductsByStoreUuid foodRecords;
  Item item;
  GlobalKey<MenuItemCounterState> menuItemCounterKey;

  MenuItemState parent;

  MenuItemCounterState(this.priceFieldKey, this.foodRecords, this.parent, this.menuItemCounterKey);

  int counter = 1;

  // ignore: non_constant_identifier_names
  Future<void> _incrementCounter_plus() async {
    currentUser.cartModel = await incrementCartItemCount(necessaryDataForAuth.device_id, item.id);
    setState(() {
    });
  }

  // ignore: non_constant_identifier_names
  Future<void> _incrementCounter_minus() async{
    currentUser.cartModel = await decrementCartItem(necessaryDataForAuth.device_id, item.id);
    item = findCartItem(foodRecords);
    setState(() {
    });
  }


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
      return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 5),
          child: Row(
            children: [
              SvgPicture.asset('assets/svg_images/rest_plus.svg'),
              Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 5, top: 5, right: 5),
                    child: Text(
                       '${foodRecords.price} \₽',
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
              ),
            ],
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

    return Padding(
        padding: EdgeInsets.only(left: 15, right: 0),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          InkWell(
            onTap: () async {
              if (counter != 1) {
                await _incrementCounter_minus();

              }
            },
            child: SvgPicture.asset('assets/svg_images/rest_minus.svg'),
          ),
          Container(
            height: 30,
            width: 50,
            child: Padding(
              padding: EdgeInsets.only(right: 10, left: 10),
              child: Center(
                child: Text(
                  '$counter',
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              if (await Internet.checkConnection()) {
                if(foodRecords.type == 'variable'){
                  parent.onPressedButton(foodRecords, menuItemCounterKey);
                }else{
                  await _incrementCounter_plus();
                }

              } else {
                noConnection(context);
              }
            },
            child: SvgPicture.asset('assets/svg_images/rest_plus.svg'),
          ),
        ])
    );
  }

  void refresh() {
    setState(() {});
  }
}