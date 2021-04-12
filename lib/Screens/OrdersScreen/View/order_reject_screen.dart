import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../Internet/check_internet.dart';
import '../../../data/data.dart';
import '../../../data/globalVariables.dart';
import '../../HomeScreen/Bloc/restaurant_get_bloc.dart';
import '../../HomeScreen/View/home_screen.dart';
import '../API/cancel_order.dart';
import '../Model/OrdersDetailsModel.dart';

class OrderRejectScreen extends StatefulWidget {
  final OrderDetailsModelItem ordersStoryModelItem;
  OrderRejectScreen({Key key, this.ordersStoryModelItem}) : super(key: key);

  @override
  OrderRejectScreenState createState() {
    return new OrderRejectScreenState(ordersStoryModelItem);
  }
}

class OrderRejectScreenState extends State<OrderRejectScreen> {
  final OrderDetailsModelItem ordersStoryModelItem;
  OrderRejectScreenState(this.ordersStoryModelItem);

  showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          child: Container(
              height: 100,
              width: 320,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 10, top: 20, bottom: 20, right: 10),
                    child: Center(
                      child: Text(
                        'Отмена заказа',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF424242)),
                      ),
                    ),
                  ),
                  Center(
                    child: SpinKitThreeBounce(
                      color: AppColor.mainColor,
                      size: 20.0,
                    ),
                  ),
                ],
              )),
        );
      },
    );
  }

  Widget build(BuildContext context) {
    double toppingsCost = 0;
    return Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    child: Container(
                        height: 50,
                        width: 60,
                        child: Padding(
                          padding: EdgeInsets.only(top: 12, bottom: 12, right: 15),
                          child: Center(
                            child:SvgPicture.asset(
                                'assets/svg_images/arrow_left.svg'),
                          ),
                        )
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.35),
                    child: Text('Отмена заказа',style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF424242))),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 10, bottom: 10),
              child: Text('Почему вы решили отменить заказ?',style: TextStyle(fontSize: 18, color: Color(0xFF424242))),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.7,
              child: ListView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
                children: List.generate(5,(index){
                  return Padding(
                    padding: const EdgeInsets.only(top: 30.0, left: 15, right: 15),
                    child: Container(
                        width: 345,
                        height: 56,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xFFE6E6E6)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Align(alignment: Alignment.centerLeft,child: Text('Заказал случайно', textAlign: TextAlign.start,)),
                        )
                    ),
                  );
                }),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: GestureDetector(
                    child: Container(
                        height: 50,
                        width: 340,
                        decoration: BoxDecoration(
                          color: Color(0xFFFE534F),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Center(
                          child: Text(
                            'Оменить заказ',
                            style: TextStyle(
                              color: AppColor.textColor,
                              fontSize: 18,),
                          ),
                        )),
                    onTap: () async {
                      if (await Internet.checkConnection()) {
                        showAlertDialog(context);
                        await cancelOrder(ordersStoryModelItem.uuid);
                        homeScreenKey = new GlobalKey();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => RestaurantGetBloc(),
                                  child: new HomeScreen(),
                                )),
                                (Route<dynamic> route) => false);
                      } else {
                        noConnection(context);
                      }
                    },
                  ),
                ),
              ),
            )
          ],
        )
    );
  }
}