import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/OrderConfirmationScreen/API/get_delivery_tariff.dart';

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
    return FutureBuilder<double>(
      future: getDeliveryTariff(),
      builder: (BuildContext context,
          AsyncSnapshot<double> snapshot){
        if(snapshot.connectionState ==
            ConnectionState.done){
          return Text(
            snapshot.data.toString() + ' \₽',
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