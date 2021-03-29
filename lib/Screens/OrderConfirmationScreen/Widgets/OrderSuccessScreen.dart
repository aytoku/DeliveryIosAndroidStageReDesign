import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/HomeScreen/Bloc/restaurant_get_bloc.dart';
import 'package:flutter_app/Screens/HomeScreen/View/home_screen.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/data/global_variables.dart';
import 'package:flutter_app/CoreColor/API/get_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderSuccessScreen extends StatefulWidget {
  final String name;

  OrderSuccessScreen({Key key, this.name}) : super(key: key);

  @override
  OrderSuccessScreenState createState() {
    return new OrderSuccessScreenState(name);
  }
}

class OrderSuccessScreenState extends State<OrderSuccessScreen> {
  final String name;

  OrderSuccessScreenState(this.name);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: AppColor.themeColor,
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 40),
                  child: (necessaryDataForAuth.name == '') ? Text('Ваш заказ принят!', style: TextStyle(
                      fontSize: 24, color: AppColor.textColor,
                  ),) : Text(name + ', ваш заказ принят! ',
                    style: TextStyle(
                        fontSize: 24,
                      color: AppColor.textColor
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(top: 60),
                  child: Text('Вы можете отследить его статус\nна главной странице!',
                    style: TextStyle(
                        fontSize: 18,
                      color: AppColor.textColor
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Padding(
                    padding:
                    EdgeInsets.only(bottom: 15, left: 15, right: 15, top: 15),
                    child: FlatButton(
                      child: Text(
                        'Продолжить',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      color: AppColor.mainColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.only(
                          left: 110, top: 20, right: 110, bottom: 20),
                      onPressed: () {
                        homeScreenKey = new GlobalKey<HomeScreenState>();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => RestaurantGetBloc(),
                                  child: new HomeScreen(),
                                )),
                                (Route<dynamic> route) => false);
                      },
                    ),
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }
}