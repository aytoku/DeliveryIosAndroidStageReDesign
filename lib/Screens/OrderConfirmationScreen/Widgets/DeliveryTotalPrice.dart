import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/OrderConfirmationScreen/API/get_delivery_tariff.dart';
import 'package:flutter_app/Screens/OrderConfirmationScreen/Model/DeliveryTariff.dart';
import 'package:flutter_app/Screens/OrderConfirmationScreen/View/address_screen.dart';
import 'package:flutter_app/data/data.dart';

class DeliveryTotalPrice extends StatefulWidget {
  AddressScreenState parent;
  DeliveryTotalPrice({Key key, this.parent}) : super(key: key);

  @override
  DeliveryTotalPriceState createState() {
    return new DeliveryTotalPriceState(parent);
  }
}

class DeliveryTotalPriceState extends State<DeliveryTotalPrice>{
  AddressScreenState parent;
  DeliveryTotalPriceState(this.parent);

  @override
  Widget build(BuildContext context) {
    DeliveryTariff deliveryTariff;
    if(parent.addressSelectorKey.currentState != null
        && parent.addressSelectorKey.currentState.myFavouriteAddressesModel.deliveryTariff != null){
      deliveryTariff = parent.addressSelectorKey.currentState.myFavouriteAddressesModel.deliveryTariff;
    }else{
      deliveryTariff = new DeliveryTariff(price: 0);
    }
    double totalPrice = currentUser.cartModel.totalPrice + deliveryTariff.price - currentUser.cartModel.promotion.amount;
    // TODO: implement build

    return Text(
      '${(totalPrice).toStringAsFixed(0)} \₽',
      style: TextStyle(
          color: Colors.black,
          fontSize: 22),
    );
  }
}