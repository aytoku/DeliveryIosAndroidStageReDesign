import 'package:flutter/material.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/Screens/OrdersScreen/API/getClientStoryOrders.dart';
import 'package:flutter_app/Screens/OrdersScreen/Model/OrdersDetailsModel.dart';
import 'package:flutter_app/Screens/RestaurantScreen/View/restaurant_screen.dart';
import 'package:flutter_app/Screens/ServiceScreen/Model/TicketModel.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'cost_error_screen.dart';

class ServiceOrdersStoryScreen extends StatefulWidget {
  final TicketModel ticketModel;

  ServiceOrdersStoryScreen({Key key, this.ticketModel}) : super(key: key);

  @override
  ServiceOrdersStoryScreenState createState() =>
      ServiceOrdersStoryScreenState(ticketModel: ticketModel);
}

class ServiceOrdersStoryScreenState extends State<ServiceOrdersStoryScreen> {
  int page = 1;
  int limit = 12;
  bool isLoading = true;
  List<OrderDetailsModelItem> records_items = new List<OrderDetailsModelItem>();
  final TicketModel ticketModel;

  ServiceOrdersStoryScreenState({this.ticketModel});

  Widget column(OrderDetailsModelItem ordersStoryModelItem) {
    var format = new DateFormat('  HH:mm    dd.MM.yyyy');
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 10, top: 10),
      child: Container(
          height: 90,
          padding: EdgeInsets.only(right: 10, left: 15),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4.0, // soften the shadow
                  spreadRadius: 1.0, //extend the shadow
                )
              ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(width: 1.0, color: Colors.grey[200])),
          child: InkWell(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(ordersStoryModelItem.storeData.name,
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 18, color: Color(0xFF000000))),
                      Text(
                        '${ordersStoryModelItem.totalPrice} \₽',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 2.0),
                              child: SvgPicture.asset('assets/svg_images/clock.svg'),
                            ),
                            Text(
                              format.format(ordersStoryModelItem.createdAt),
                              style: TextStyle(fontSize: 12, color: Color(0xFFB0B0B0)),
                            ),
                          ],
                        ),
                      ),
                      (ordersStoryModelItem.state == "finish") ? Row(
                        children: [
                          Text('Доставлен',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: SvgPicture.asset('assets/svg_images/delivered.svg'),
                          )
                        ],
                      ) : Container(
                        child: Text(ordersStoryModelItem.state,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }

  _buildOrdersStoryItems() {
    List<Widget> restaurantList = [];
    int i = 0;
    if(records_items == null){
      return Container();
    }else{
      records_items.forEach((OrderDetailsModelItem ordersStoryModelItem) {
        if(ordersStoryModelItem.items!= null && ordersStoryModelItem.items.length > 0){
          restaurantList.add(
            InkWell(
                child: column(ordersStoryModelItem),
                onTap: () async {
                  if (await Internet.checkConnection()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) {
                        return CostErrorScreen(ticketModel: ticketModel,);
                      }),
                    );
                  } else {
                    noConnection(context);
                  }
                }),
          );
        }
        i++;
      });
    }
    return Column(children: restaurantList);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 30, bottom: 10),
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: InkWell(
                      child: Container(
                          height: 40,
                          width: 60,
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 12, bottom: 12, right: 10),
                            child: SvgPicture.asset(
                                'assets/svg_images/arrow_left.svg'),
                          )
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          "История заказов",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3F3F3F)),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Divider(height: 1.0, color: Colors.grey),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 15, left: 16, bottom: 10),
                child: Text('По какому заказу ваше обращение?',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFB9B9B9))),
              ),
            ),
            FutureBuilder<OrderDetailsModel>(
                future: getClientStoryOrders(),
                initialData: null,
                builder: (BuildContext context,
                    AsyncSnapshot<OrderDetailsModel> snapshot) {
                  print(snapshot.connectionState);
                  if (snapshot.hasData) {
                    records_items = snapshot.data.orderDetailsModelItem;
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView(
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    NotificationListener<ScrollNotification>(
                                        onNotification: (ScrollNotification scrollInfo) {
                                          if (!isLoading &&
                                              scrollInfo.metrics.pixels ==
                                                  scrollInfo.metrics.maxScrollExtent) {
                                            setState(() {
                                              isLoading = true;
                                            });
                                          }
                                        },
                                        child: _buildOrdersStoryItems()),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  } else {
                    return Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.35),
                      child: Center(
                        child: SpinKitFadingCircle(
                          color: Colors.green,
                          size: 50.0,
                        ),
                      ),
                    );
                  }
                })
          ],
        ),
      ),
    );
  }
}