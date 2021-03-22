import 'package:flutter/material.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/Screens/AboutAppScreen/View/about_app_screen.dart';
import 'package:flutter_app/Screens/HomeScreen/Bloc/restaurant_get_bloc.dart';
import 'package:flutter_app/Screens/HomeScreen/View/home_screen.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class InformationScreen extends StatefulWidget {
  @override
  InformationScreenState createState() => InformationScreenState();
}

class InformationScreenState extends State<InformationScreen>{
  bool status1 = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              InkWell(
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top:30, bottom: 10),
                      child: Container(
                          height: 50,
                          width: 60,
                          child: Padding(
                            padding: EdgeInsets.only(top: 12, bottom: 12, right: 15),
                            child: Center(
                                child:SvgPicture.asset(
                                    'assets/svg_images/arrow_left.svg', color: AppColor.textColor,),
                            ),
                          )
                      )
                    )
                ),
                onTap: () async {
                  if(await Internet.checkConnection()){
                    homeScreenKey = new GlobalKey<HomeScreenState>();
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => RestaurantGetBloc(),
                          child: new HomeScreen(),
                        )), (Route<dynamic> route) => false);
                  }else{
                    noConnection(context);
                  }
                },
              ),
              Padding(
                padding: EdgeInsets.only(top: 30, left: 90, right: 15, bottom: 10),
                child: Text('Информация',style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColor.textColor)),
              ),
            ],
          ),
          Divider(height: 1.0, color: Colors.grey),
          InkWell(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                  padding: EdgeInsets.only(top: 20, left: 30, bottom: 20, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('О приложении',
                        style: TextStyle(
                            color: AppColor.textColor,
                            fontSize: 17
                        ),
                      ),
                      GestureDetector(
                        child: SvgPicture.asset(
                            'assets/svg_images/arrow_right.svg', color: AppColor.textColor),
                      ),
                    ],
                  )
              ),
            ),
            onTap: () async {
              if(await Internet.checkConnection()){
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => new AboutAppScreen(),
                  ),
                );
              }else{
                noConnection(context);
              }
            },
          ),
          Divider(height: 1.0, color: Colors.grey),
        ],
      ),
    );
  }
}