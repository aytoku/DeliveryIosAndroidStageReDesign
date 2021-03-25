import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Config/config.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/Screens/AuthScreen/Model/Auth.dart';
import 'package:flutter_app/Screens/ChatScreen/View/chat_message_screen.dart';
import 'package:flutter_app/Screens/ChatScreen/View/chat_screen.dart';
import 'package:flutter_app/Screens/CityScreen/Model/FilteredCities.dart';
import 'package:flutter_app/Screens/CodeScreen/Model/AuthCode.dart';
import 'package:flutter_app/Screens/HomeScreen/Bloc/restaurant_get_bloc.dart';
import 'package:flutter_app/Screens/HomeScreen/View/home_screen.dart';
import 'package:flutter_app/Screens/HomeScreen/Widgets/OrderChecking.dart';
import 'package:flutter_app/Screens/ServiceScreen/View/tickets_chat_screen.dart';
import 'package:flutter_app/data/global_variables.dart';
import 'package:flutter_app/data/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:convert' as convert;


String getImage(String imgJson) {
  try {
    Map<String,dynamic> json = convert.jsonDecode(imgJson);
    if(json.containsKey('medium_format')){
      print('parsedJson ' + json['medium_format']);
      return json['medium_format'];
    }
    print('not parsedJson ' + imgJson);
    return imgJson;
  } catch(e){
    if(imgJson.startsWith('"\\"')) {
      imgJson = imgJson.substring(3, imgJson.length - 3);
    }else if(imgJson.startsWith('"')){
      imgJson = imgJson.substring(1, imgJson.length - 1);
    }
    print('exception ' + imgJson);
    return imgJson;
  }
}

var DeliveryStates = [
  'cooking',
  'offer_offered',
  'smart_distribution',
  'finding_driver',
  'offer_rejected',
  'order_start',
  'on_place',
  'waiting_for_confirmation',
  'on_the_way',
  'order_payment'
];


// User
final currentUser = User(
  cartModel: null,
  name: '',
);
//checking on internet connection
noConnection(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      Future.delayed(Duration(seconds: 1), () {
        Navigator.of(context).pop(true);
      });
      return Center(
        child: Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          child: Container(
            height: 50,
            width: 100,
            child: Center(
              child: Text("Нет подключения к интернету"),
            ),
          ),
        ),
      );
    },
  );
}

// ignore: must_be_immutable
// for screen's title with navigator.pop
class ScreenTitlePop extends StatefulWidget {
  String title = '';
  String img = '';

  ScreenTitlePop({Key key, this.title, this.img}) : super(key: key);

  @override
  ScreenTitlePopState createState() {
    return new ScreenTitlePopState(title, img);
  }
}

class ScreenTitlePopState extends State<ScreenTitlePop> {
  String title = '';
  String img = '';

  ScreenTitlePopState(this.title, this.img);

  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.only(top: 30),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: InkWell(
                  hoverColor: Colors.white,
                  focusColor: Colors.white,
                  splashColor: Colors.white,
                  highlightColor: Colors.white,
                  child: Container(
                      height: 50,
                      width: 55,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 17, bottom: 17, right: 10),
                        child: SvgPicture.asset(
                            img),
                      )),
                  onTap: (){
                    homeScreenKey = new GlobalKey<HomeScreenState>();
                    Navigator.of(context).push(
                        PageRouteBuilder(
                            pageBuilder: (context, animation, anotherAnimation) {
                              return BlocProvider(
                              create: (context) => RestaurantGetBloc(),
                              child: new HomeScreen(),
                              );
                            },
                            transitionDuration: Duration(milliseconds: 300),
                            transitionsBuilder:
                                (context, animation, anotherAnimation, child) {
//                                      animation = CurvedAnimation(
//                                          curve: Curves.bounceIn, parent: animation);
                              return SlideTransition(
                                position: Tween(
                                    begin: Offset(1.0, 0.0),
                                    end: Offset(0.0, 0.0))
                                    .animate(animation),
                                child: child,
                              );
                            }
                        ));
                  }
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 15),
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF424242)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

//for screen's title with pushAndRemoveUntil
class ScreenTitlePushAndRemoveUntil extends StatefulWidget {
  String title = '';
  String img = '';

  ScreenTitlePushAndRemoveUntil({Key key, this.title, this.img}) : super(key: key);

  @override
  ScreenTitlePushAndRemoveUntilState createState() {
    return new ScreenTitlePushAndRemoveUntilState(title, img);
  }
}

class ScreenTitlePushAndRemoveUntilState extends State<ScreenTitlePushAndRemoveUntil> {
  String title = '';
  String img = '';

  ScreenTitlePushAndRemoveUntilState(this.title, this.img);

  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 30),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: InkWell(
              hoverColor: Colors.white,
              focusColor: Colors.white,
              splashColor: Colors.white,
              highlightColor: Colors.white,
              child: Container(
                  height: 50,
                  width: 60,
                  child: Padding(
                    padding:
                    EdgeInsets.only(top: 17, bottom: 17, right: 10),
                    child: SvgPicture.asset(
                        img),
                  )),
              onTap: () async {
                if (await Internet.checkConnection()) {
                  homeScreenKey = new GlobalKey<HomeScreenState>();
                  Navigator.of(context).pushAndRemoveUntil(
                      PageRouteBuilder(
                          pageBuilder: (context, animation, anotherAnimation) {
                            return BlocProvider(
                            create: (context) => RestaurantGetBloc(),
                            child: new HomeScreen(),
                            );
                          },
                          transitionDuration: Duration(milliseconds: 300),
                          transitionsBuilder:
                              (context, animation, anotherAnimation, child) {
//                                      animation = CurvedAnimation(
//                                          curve: Curves.bounceIn, parent: animation);
                            return SlideTransition(
                              position: Tween(
                                  begin: Offset(1.0, 0.0),
                                  end: Offset(0.0, 0.0))
                                  .animate(animation),
                              child: child,
                            );
                          }
                      ), (Route<dynamic> route) => false);
                } else {
                  noConnection(context);
                }
              },
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(top: 15),
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF424242)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

