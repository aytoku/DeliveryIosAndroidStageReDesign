import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/OrderConfirmationScreen/Model/DeliveryTariff.dart';
import 'package:flutter_app/Screens/OrderConfirmationScreen/View/address_screen.dart';

class DeliveryInfo extends StatefulWidget {

  AddressScreenState parent;
  DeliveryInfo({Key key, this.parent}) : super(key: key);

  @override
  DeliveryInfoState createState() {
    return new DeliveryInfoState(parent);
  }
}

class DeliveryInfoState extends State<DeliveryInfo>{
  DeliveryInfoState(this.parent);
  AddressScreenState parent;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    DeliveryTariff deliveryTariff;
    if(parent.addressSelectorKey.currentState != null
        && parent.addressSelectorKey.currentState.myFavouriteAddressesModel.deliveryTariff != null){
      deliveryTariff = parent.addressSelectorKey.currentState.myFavouriteAddressesModel.deliveryTariff;
    }else{
      deliveryTariff = new DeliveryTariff(price: 0, estimatedTime: 0);
    }
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
            child: Row(
              children: [
                Text(
                  'Доставка',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    (deliveryTariff.estimatedTime / 60).toString() + ' мин.',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12),
                  ),
                ),
              ],
            )
        ),
        Text(
          deliveryTariff.price.toStringAsFixed(0).toString() + ' \₽',
          style: TextStyle(
              color: Colors.black,
              fontSize: 14),
        )
      ],
    );
  }
}