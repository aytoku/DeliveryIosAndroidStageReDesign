
import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Model/ProductsByStoreUuid.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/VariantSelector.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/data/global_variables.dart';

import '../Model/CartModel.dart';
import '../Model/CartModel.dart';

class PriceField extends StatefulWidget {
  Item order;
  ProductsByStoreUuid restaurantDataItems;
  List<VariantsSelector> variantsSelectors;
  PriceField({Key key, this.order, this.restaurantDataItems, this.variantsSelectors}) : super(key: key);

  @override
  PriceFieldState createState() {
    return new PriceFieldState(order, restaurantDataItems, variantsSelectors);
  }
}

class PriceFieldState extends State<PriceField> {
  int count = 1;
  Item order;
  ProductsByStoreUuid restaurantDataItems;

  PriceFieldState(this.order, this.restaurantDataItems, this.variantsSelectors);
  List<VariantsSelector> variantsSelectors;

  Widget build(BuildContext context) {

    double variantsPrice = 0;
    if(variantsSelectors != null)
      variantsSelectors.forEach((element) {
        if(element.key.currentState != null)
          variantsPrice+=element.key.currentState.getSelectedVariantsCost();
      });

    if(order != null){
      return Padding(
        padding: EdgeInsets.only(left: 20),
        child: Text('${order.totalItemPrice.toStringAsFixed(0)} \₽',
            style: TextStyle(
                decoration: TextDecoration.none,
                fontSize: 18.0,
                color: AppColor.textColor)),
      );
    }else if(restaurantDataItems!=null) {
      return Text(
        '${((restaurantDataItems.price+variantsPrice) * count).toStringAsFixed(0)}\₽',
        style: TextStyle(
            fontSize: 15.0,
            color: AppColor.textColor),
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