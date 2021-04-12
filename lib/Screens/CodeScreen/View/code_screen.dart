import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Config/config.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/Screens/AuthScreen/API/auth_data_pass.dart';
import 'package:flutter_app/Screens/AuthScreen/Bloc/phone_number_get_bloc.dart';
import 'package:flutter_app/Screens/AuthScreen/Model/Auth.dart';
import 'package:flutter_app/Screens/CodeScreen/API/auth_code_data_pass.dart';
import 'package:flutter_app/Screens/CodeScreen/Bloc/code_event.dart';
import 'package:flutter_app/Screens/CodeScreen/Bloc/code_get_bloc.dart';
import 'package:flutter_app/Screens/CodeScreen/Bloc/code_state.dart';
import 'package:flutter_app/Screens/CodeScreen/Widgets/CodeButton.dart';
import 'package:flutter_app/Screens/CodeScreen/Widgets/TimerCountDown.dart';
import 'package:flutter_app/Screens/HomeScreen/Bloc/restaurant_get_bloc.dart';
import 'package:flutter_app/Screens/HomeScreen/View/home_screen.dart';
import 'package:flutter_app/Screens/NameScreen/View/name_screen.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import '../../../data/data.dart';
import '../../AuthScreen/View/auth_screen.dart';

class CodeScreen extends StatefulWidget {
  AuthSources source;
  AuthData authData;
  CodeScreen(this.authData, {this.source = AuthSources.Drawer, Key key}) : super(key: key);

  @override
  CodeScreenState createState() => CodeScreenState(source, authData);
}

class CodeScreenState extends State<CodeScreen> {
  AuthSources source;
  AuthData authData;
  TextField code1;
  TextField code2;
  TextField code3;
  TextField code4;
  String error = '';
  TextEditingController controller1 = new TextEditingController();
  TextEditingController controller2 = new TextEditingController();
  TextEditingController controller3 = new TextEditingController();
  TextEditingController controller4 = new TextEditingController();
  String temp1 = '';
  String temp2 = '';
  String temp3 = '';
  String temp4 = '';
  GlobalKey<CodeButtonState> buttonStateKey = new GlobalKey<CodeButtonState>();
  CodeGetBloc codeGetBloc;
  CodeScreenState(this.source, this.authData);

  void buttonColor() {
    String code = code1.controller.text +
        code2.controller.text +
        code3.controller.text +
        code4.controller.text;
    if (code.length > 0 &&
        buttonStateKey.currentState.color != AppColor.mainColor) {
      buttonStateKey.currentState.setState(() {
        buttonStateKey.currentState.color = AppColor.mainColor;
      });
    } else if (code.length == 0 &&
        buttonStateKey.currentState.color != Color(0xFFF3F3F3)) {
      buttonStateKey.currentState.setState(() {
        buttonStateKey.currentState.color = Color(0xFFF3F3F3);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    codeGetBloc = BlocProvider.of<CodeGetBloc>(context);
    controller1.addListener(() {
      if(controller1.text.length > 1){
        if(controller1.text[0] == temp1){
          temp1 = controller1.text[1];
          controller1.text = controller1.text[1];
        }else{
          temp1 = controller1.text[0];
          controller1.text = controller1.text[0];
        }
      }
      else
        temp1 = controller1.text;
    });
    controller2.addListener(() {
      if(controller2.text.length > 1){
        if(controller2.text[0] == temp2){
          temp2 = controller2.text[1];
          controller2.text = controller2.text[1];
        }else{
          temp2 = controller2.text[0];
          controller2.text = controller2.text[0];
        }
      }
      else
        temp2 = controller2.text;
    });
    controller3.addListener(() {
      if(controller3.text.length > 1){
        if(controller3.text[0] == temp3){
          temp3 = controller3.text[1];
          controller3.text = controller3.text[1];
        }else{
          temp3 = controller3.text[0];
          controller3.text = controller3.text[0];
        }
      }
      else
        temp3 = controller3.text;
    });
    controller4.addListener(() {
      if(controller4.text.length > 1){
        if(controller4.text[0] == temp4){
          temp4 = controller4.text[1];
          controller4.text = controller4.text[1];
        }else{
          temp4 = controller4.text[0];
          controller4.text = controller4.text[0];
        }
      }
      else
        temp4 = controller4.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.themeColor,
      body: BlocListener<CodeGetBloc, CodeState>(
        bloc: codeGetBloc,
        listener: (BuildContext context, CodeState state){
          if(state is CodeStateSuccess){
            if(state.goToNameScreen){
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) =>
                  new NameScreen(source: source,),
                ),
              );
            }else if(state.goToHomeScreen){
              if(source == AuthSources.Cart){
                for(int i = 0; i<2;i++)
                  Navigator.pop(context);

                return;
              }
              homeScreenKey =
              new GlobalKey<HomeScreenState>();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => RestaurantGetBloc(),
                      child: new HomeScreen(),
                    ),),
                      (Route<dynamic> route) => false);
            }
          }
        },
        child: BlocBuilder<CodeGetBloc, CodeState>(
          bloc: codeGetBloc,
          builder: (BuildContext context, CodeState state){
            return Stack(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      hoverColor: AppColor.themeColor,
                      focusColor: AppColor.themeColor,
                      splashColor: AppColor.themeColor,
                      highlightColor: AppColor.themeColor,
                      child: Padding(
                          padding: EdgeInsets.only(left: 20, top: 40),
                          child: Container(
                            width: 40,
                            height: 60,
                            child: Center(
                              child: SvgPicture.asset(
                                  'assets/svg_images/arrow_left.svg'),
                            ),
                          )),
                      onTap: () => Navigator.pop(context),
                    ),
                    InkWell(
                      hoverColor: AppColor.themeColor,
                      focusColor: AppColor.themeColor,
                      splashColor: AppColor.themeColor,
                      highlightColor: AppColor.themeColor,
                      child:  Padding(
                          padding: EdgeInsets.only(right: 24, top: 40),
                          child: Container(
                            width: 40,
                            height: 60,
                            child: Center(
                              child: SvgPicture.asset(
                                  'assets/svg_images/code_cross.svg'),
                            ),
                          )),
                      onTap: () => Navigator.pop(context),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 140),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: 130,
                      width: 313,
                      decoration: BoxDecoration(
                        color: AppColor.mainColor,
                        border: Border.all(
                          color: AppColor.mainColor,
                        ),
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(10.0),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Text(
                                'Введите код из смс',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: AppColor.textColor
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              padding: EdgeInsets.only(bottom: 15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
                                  color: AppColor.themeColor
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Flexible(
                                    flex: 1,
                                    child: Padding(
                                      padding:
                                      EdgeInsets.only(left: 15, right: 15),
                                      child: code1 = TextField(
                                          autofocus: true,
                                          focusNode: new FocusNode(),
                                          controller: controller1,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 28),
                                          keyboardType: TextInputType.number,
                                          cursorColor: AppColor.mainColor,
                                          maxLength: 2,
                                          decoration: new InputDecoration(
                                            focusedBorder:UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: AppColor.mainColor),
                                            ),
                                            enabledBorder:
                                            UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                            ),
                                            counterText: '',
                                          ),
                                          onChanged: (String value) {
                                            if (value != '') {
                                              code2.focusNode.requestFocus();
                                            }
                                            buttonColor();
                                          }),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Padding(
                                      padding:
                                      EdgeInsets.only(left: 15, right: 15),
                                      child: code2 = TextField(
                                          focusNode: new FocusNode(),
                                          controller: controller2,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 28),
                                          keyboardType: TextInputType.number,
                                          cursorColor: AppColor.mainColor,
                                          maxLength: 2,
                                          decoration: new InputDecoration(
                                            focusedBorder:UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: AppColor.mainColor),
                                            ),
                                            enabledBorder:
                                            UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                            ),
                                            counterText: '',
                                          ),
                                          onChanged: (String value) {
                                            if (value != '') {
                                              code3.focusNode.requestFocus();
                                            }
                                            if(value.isEmpty){
                                              code1.focusNode.requestFocus();
                                            }
                                            buttonColor();
                                          }),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Padding(
                                      padding:
                                      EdgeInsets.only(left: 15, right: 15),
                                      child: code3 = TextField(
                                          focusNode: new FocusNode(),
                                          controller: controller3,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 28),
                                          keyboardType: TextInputType.number,
                                          cursorColor: AppColor.mainColor,
                                          maxLength: 2,
                                          decoration: new InputDecoration(
                                            focusedBorder:UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: AppColor.mainColor),
                                            ),
                                            enabledBorder:
                                            UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                            ),
                                            counterText: '',
                                          ),
                                          onChanged: (String value) {
                                            if (value != '') {
                                              code4.focusNode.requestFocus();
                                            }
                                            if(value.isEmpty){
                                              code2.focusNode.requestFocus();
                                            }
                                            buttonColor();
                                          }),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Padding(
                                      padding:
                                      EdgeInsets.only(left: 15, right: 15),
                                      child: code4 = TextField(
                                        onChanged: (String value){
                                          if(value.isEmpty){
                                            code3.focusNode.requestFocus();
                                          }
                                          if(value.length != 0){
                                            FocusScope.of(context).requestFocus(new FocusNode());
                                          }
                                        },
                                        focusNode: new FocusNode(),
                                        controller: controller4,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 28),
                                        keyboardType: TextInputType.number,
                                        cursorColor: AppColor.mainColor,
                                        maxLength: 2,
                                        decoration: new InputDecoration(
                                          focusedBorder:UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: AppColor.mainColor),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey,width: 1),
                                          ),
                                          counterText: '',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                (state is SearchStateError) ? Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.4, ),
                    child: Text(
                      state.error,
                      style: TextStyle(
                          color: Colors.red, fontSize: 12),
                    ),
                  ),
                ) : Container(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 90, top: 15),
                    child: BlocProvider(
                      create: (context)=> AuthGetBloc(),
                      child: new TimerCountDown(codeScreenState: this),
                    )
                  ),
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: 20, left: 0, right: 0, top: 10),
                      child: CodeButton(
                        key: buttonStateKey,
                        color: Color(0xFFF3F3F3),
                        onTap: () async {
                          if (await Internet.checkConnection()) {
                            try{
                              String temp = '';
                              temp = code1.controller.text +
                                  code2.controller.text +
                                  code3.controller.text +
                                  code4.controller.text;
                              codeGetBloc.add(SendCode(code: int.parse(temp)));
                            }finally{
                              lock = false;
                              await Vibrate.canVibrate;
                            }
                          } else {
                            noConnection(context);
                          }
                        },
                      ),
                    )
                )
              ],
            );
          },
        ),
      ),
    );
  }
}