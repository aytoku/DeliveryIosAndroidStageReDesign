import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/OrderConfirmationScreen/API/get_delivery_tariff.dart';
import 'package:flutter_app/Screens/OrderConfirmationScreen/Model/DeliveryTariff.dart';

class DeliveryPrice extends StatefulWidget {

  DeliveryPrice({Key key}) : super(key: key);

  @override
  DeliveryPriceState createState() {
    return new DeliveryPriceState();
  }
}

class DeliveryPriceState extends State<DeliveryPrice>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder<DeliveryTariff>(
      future: getDeliveryTariff(),
      builder: (BuildContext context,
          AsyncSnapshot<DeliveryTariff> snapshot){
        if(snapshot.connectionState ==
            ConnectionState.done){
          return Text(
            snapshot.data.price.toString() + ' \₽',
            style: TextStyle(
                color: Colors.black,
                fontSize: 14),
          );
        }else{
          return Container();
        }
      },
    );
  }
}