import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/HomeScreen/Bloc/restaurant_get_bloc.dart';
import 'package:flutter_app/Screens/HomeScreen/Model/Stock.dart';
import 'package:flutter_app/Screens/HomeScreen/View/home_screen.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../data/data.dart';

class PromoScreen extends StatefulWidget {

  Stock stock;
  PromoScreen({Key key, this.stock}) : super(key: key);

  @override
  PromoScreenState createState() {
    return new PromoScreenState(stock);
  }
}

class PromoScreenState extends State<PromoScreen>{
  Stock stock;
  PromoScreenState(this.stock);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: InkWell(
              hoverColor: AppColor.themeColor,
              focusColor: AppColor.themeColor,
              splashColor: AppColor.themeColor,
              highlightColor: AppColor.themeColor,
              onTap: () {
                homeScreenKey = new GlobalKey<HomeScreenState>();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => RestaurantGetBloc(),
                          child: new HomeScreen(),
                        )),
                        (Route<dynamic> route) => false);
              },
              child: Padding(
                padding: EdgeInsets.only(top: 40),
                child: Container(
                    height: 40,
                    width: 60,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 12, bottom: 12, right: 10),
                      child: SvgPicture.asset(
                          'assets/svg_images/arrow_left.svg'),
                    )),),
            ),
          ),
        ],
      ),
    );
  }
}