import 'package:flutter/material.dart';
import 'package:flutter_app/Config/config.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/Screens/HomeScreen/View/home_screen.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';

import '../../AuthScreen/View/auth_screen.dart';

class NameScreen extends StatefulWidget {
  NameScreen({this.source = AuthSources.Drawer, Key key}) : super(key: key);
  AuthSources source;

  @override
  NameScreenState createState() => NameScreenState(source);
}

class NameScreenState extends State<NameScreen> {
  GlobalKey<ButtonState> buttonStateKey;
  TextEditingController nameFieldController;
  AuthSources source;
  NameScreenState(this.source);

  @override
  void initState() {
    super.initState();
    buttonStateKey = new GlobalKey<ButtonState>();
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
        resizeToAvoidBottomPadding: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                      padding: EdgeInsets.only(left: 15, top: 40),
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
                    child: Padding(
                      padding:
                          EdgeInsets.only(right: 30, left: 30, bottom: 100),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            flex: 1,
                            child: Padding(
                                padding: EdgeInsets.only(left: 15, right: 15),
                                child: Container(
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
                                      contentPadding: EdgeInsets.only(left: 15),
                                      hintStyle: TextStyle(
                                          color: Color(0xFFB5B5B5),
                                          fontSize: 18),
                                      border: InputBorder.none,
                                      counterText: '',
                                    ),
                                  ),
                                )),
                          ),
                        ],
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
                            child: Button(
                              key: buttonStateKey,
                              color: Color(0xFF09B44D),
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

                                  homeScreenKey =
                                      new GlobalKey<HomeScreenState>();
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => HomeScreen()),
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
        ));
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
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text('Далее',
            style: TextStyle(
                fontSize: 18.0,
                color: Colors.white)),
        padding: EdgeInsets.only(left: 130, top: 20, right: 130, bottom: 20),
      ),
      onTap: () async {
        await onTap();
      },
    );
  }
}
