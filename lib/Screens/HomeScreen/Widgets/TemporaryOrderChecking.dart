import 'package:flutter/material.dart';
import 'package:flutter_app/Centrifugo/centrifugo.dart';
import 'package:flutter_app/Screens/HomeScreen/Widgets/OrderChecking.dart';
import 'package:flutter_app/data/data.dart';

class TemporaryOrderChecking extends StatefulWidget {

  List<OrderChecking> orderList;
  TemporaryOrderChecking({Key key, this.orderList}) : super(key: key);

  @override
  TemporaryOrderCheckingState createState() {
    return new TemporaryOrderCheckingState(orderList);
  }
}

class TemporaryOrderCheckingState extends State<TemporaryOrderChecking>{

  TemporaryOrderCheckingState(this.orderList);
  List<OrderChecking> orderList;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(!currentUser.isLoggedIn){
      return Container();
    }else{
      return FutureBuilder<List<OrderChecking>>(
        future: OrderChecking.getActiveOrder(),
        builder: (BuildContext context,
            AsyncSnapshot<List<OrderChecking>> snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.done &&
              snapshot.data != null &&
              snapshot.data.length > 0) {
              snapshot.data.forEach((snapshotOrder) {
                int index = orderList.indexWhere((order) => order.ordersDetailsItem.uuid == snapshotOrder.ordersDetailsItem.uuid);
                if(index == -1 || orderList[index].ordersDetailsItem.state != snapshotOrder.ordersDetailsItem.state){
                  // snapshotOrder.ordersDetailsItem.state
                  if(snapshotOrder.ordersDetailsItem.state == "cooking")
                    Centrifugo.showNotification({
                      "title": "Заказ готовится",
                      "message": "Ваш заказ готовится"
                    });
                  else if(snapshotOrder.ordersDetailsItem.state == "delivery")
                    Centrifugo.showNotification({
                      "title": "Заказ в пути",
                      "message": "Ваш заказ передан курьеру"
                    });
                }
              });

            orderList = snapshot.data;
          }

          if(snapshot.hasData &&  snapshot.data != null &&
              snapshot.data.length > 0){
            return (currentUser.isLoggedIn)
                ? Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Container(
                height: 230,
                child: (snapshot.data.length > 1) ? ListView(
                  children: snapshot.data,
                  scrollDirection: Axis.horizontal,
                ) : Center(
                  child: Row(
                    children: snapshot.data,
                  ),
                ),
              ),
            ) : Container(
              height: 0,
            );
          }

          return Container(
            height: 0,
          );
        },
      );
    }
  }
}