import 'package:flutter/material.dart';
import 'package:flutter_app/Config/config.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/Screens/HomeScreen/Bloc/restaurant_get_bloc.dart';
import 'package:flutter_app/Screens/HomeScreen/View/home_screen.dart';
import 'package:flutter_app/Screens/NameScreen/Widgets/NameButton.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';

import '../../../data/data.dart';
import '../../../data/globalVariables.dart';
import '../../../data/globalVariables.dart';
import '../../../data/globalVariables.dart';
import '../../AuthScreen/View/auth_screen.dart';
import '../../CodeScreen/API/auth_code_data_pass.dart';
import '../API/set_client_name.dart';
import '../API/set_client_name.dart';

class NameScreen extends StatefulWidget {
  NameScreen({this.source = AuthSources.Drawer, Key key}) : super(key: key);
  AuthSources source;

  @override
  NameScreenState createState() => NameScreenState(source);
}

class NameScreenState extends State<NameScreen> {
  GlobalKey<NameButtonState> buttonStateKey;
  TextEditingController nameFieldController;
  AuthSources source;
  NameScreenState(this.source);

  @override
  void initState() {
    super.initState();
    buttonStateKey = new GlobalKey<NameButtonState>();
    nameFieldController = new TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.themeColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
              hoverColor: AppColor.themeColor,
              focusColor: AppColor.themeColor,
              splashColor: AppColor.themeColor,
              highlightColor: AppColor.themeColor,
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                      padding: EdgeInsets.only(left: 25, top: 40),
                      child: Container(
                          height: 40,
                          width: 60,
                          child: Padding(
                            padding:
                            EdgeInsets.only(top: 12, bottom: 12, right: 30),
                            child: SvgPicture.asset(
                                'assets/svg_images/arrow_left.svg'),
                          )))),
              onTap: () => Navigator.pop(context),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 0, bottom: 15),
                        child: Text('Как вас зовут?',
                            style: TextStyle(
                              fontSize: 24,
                            )),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Center(
                      child: Padding(
                          padding:
                          EdgeInsets.only(bottom: 100),
                          child: Container(
                            width: 313,
                            height: 45,
                            decoration: BoxDecoration(
                                color: Color(0xF5F5F5F5),
                                borderRadius: BorderRadius.circular(7.0),
                                border: Border.all(
                                    width: 1.0,
                                    color: Color(0xF5F5F5F5))),
                            child: TextField(
                              controller: nameFieldController,
                              textAlign: TextAlign.start,
                              textCapitalization:
                              TextCapitalization.sentences,
                              style: TextStyle(
                                fontSize: 18,),
                              keyboardType: TextInputType.text,
                              decoration: new InputDecoration(
                                hintText: 'Ваше имя',
                                contentPadding: EdgeInsets.only(left: 15, bottom: 5),
                                hintStyle: TextStyle(
                                    color: Color(0xFFB5B5B5),
                                    fontSize: 18),
                                border: InputBorder.none,
                                counterText: '',
                              ),
                            ),
                          )
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 17),
                child: Container(
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: 20),
                            child: NameButton(
                              key: buttonStateKey,
                              color: AppColor.mainColor,
                              onTap: () async {
                                if (await Internet.checkConnection()) {
                                  necessaryDataForAuth.name = nameFieldController.text;
                                  currentUser.isLoggedIn = true;
                                  await NecessaryDataForAuth.saveData();
                                  print(necessaryDataForAuth.name);

                                  if(source == AuthSources.Cart){
                                    for(int i = 0; i<3;i++)
                                      Navigator.pop(context);
                                    setState(() {

                                    });
                                    return;
                                  }
                                  await setClientName(necessaryDataForAuth.device_id, nameFieldController.text);
                                  homeScreenKey =
                                  new GlobalKey<HomeScreenState>();
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (context) => BlocProvider(
                                          create: (context) => RestaurantGetBloc(),
                                          child: new HomeScreen(),
                                        ),),
                                          (Route<dynamic> route) => false);
                                } else {
                                  noConnection(context);
                                }
                              },
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            )
          ],
        )
    );
  }
}

class Button extends StatefulWidget {
  Color color;
  VoidCallback onTap;

  Button({Key key, this.color, this.onTap}) : super(key: key);

  @override
  ButtonState createState() {
    return new ButtonState(color, onTap: onTap);
  }
}

class ButtonState extends State<Button> {
  String error = '';
  Color color;
  final VoidCallback onTap;

  ButtonState(this.color, {this.onTap});


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      child: Container(
        width: 313,
        height: 52,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text('Далее',
              style: TextStyle(
                  fontSize: 18.0,
                  color: AppColor.unselectedTextColor)),
        ),
      ),
      onTap: () async {
        await onTap();
      },
    );
  }
}
