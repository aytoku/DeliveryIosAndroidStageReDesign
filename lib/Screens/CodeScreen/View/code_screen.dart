import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Config/config.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/Screens/AuthScreen/API/auth_data_pass.dart';
import 'package:flutter_app/Screens/AuthScreen/Model/Auth.dart';
import 'package:flutter_app/Screens/CodeScreen/API/auth_code_data_pass.dart';
import 'package:flutter_app/Screens/CodeScreen/Bloc/code_event.dart';
import 'package:flutter_app/Screens/CodeScreen/Bloc/code_get_bloc.dart';
import 'package:flutter_app/Screens/CodeScreen/Bloc/code_state.dart';
import 'package:flutter_app/Screens/HomeScreen/Bloc/restaurant_get_bloc.dart';
import 'package:flutter_app/Screens/HomeScreen/View/home_screen.dart';
import 'package:flutter_app/Screens/NameScreen/View/name_screen.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';
import 'package:flutter_app/data/global_variables.dart';


import '../../../Amplitude/amplitude.dart';
import '../../../Centrifugo/centrifugo.dart';
import '../../../data/data.dart';
import '../../../data/data.dart';
import '../../AuthScreen/View/auth_screen.dart';

class CodeScreen extends StatefulWidget {
  AuthSources source;
  AuthData authData;
  CodeScreen(this.authData, {this.source = AuthSources.Drawer, Key key}) : super(key: key);

  @override
  _CodeScreenState createState() => _CodeScreenState(source, authData);
}

class _CodeScreenState extends State<CodeScreen> {

  TextEditingController pinController = new TextEditingController();
  AuthSources source;
  AuthData authData;
  // TextField code1;
  // TextField code2;
  // TextField code3;
  // TextField code4;
  String error = '';
  // TextEditingController controller1 = new TextEditingController();
  // TextEditingController controller2 = new TextEditingController();
  // TextEditingController controller3 = new TextEditingController();
  // TextEditingController controller4 = new TextEditingController();
  // String temp1 = '';
  // String temp2 = '';
  // String temp3 = '';
  // String temp4 = '';
  GlobalKey<ButtonState> buttonStateKey = new GlobalKey<ButtonState>();
  CodeGetBloc codeGetBloc;
  _CodeScreenState(this.source, this.authData);
  String code;

  void buttonColor() {
    // String code = code1.controller.text +
    //     code2.controller.text +
    //     code3.controller.text +
    //     code4.controller.text;
    if (code.length == 4 &&
        buttonStateKey.currentState.color != AppColor.mainColor) {
      buttonStateKey.currentState.setState(() {
        buttonStateKey.currentState.color = AppColor.mainColor;
      });
    } else if (code.length < 4 &&
        buttonStateKey.currentState.color != AppColor.subElementsColor) {
      buttonStateKey.currentState.setState(() {
        buttonStateKey.currentState.color = AppColor.subElementsColor;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    codeGetBloc = BlocProvider.of<CodeGetBloc>(context);
    // controller1.addListener(() {
    //   if(controller1.text.length > 1){
    //     if(controller1.text[0] == temp1){
    //       temp1 = controller1.text[1];
    //       controller1.text = controller1.text[1];
    //     }else{
    //       temp1 = controller1.text[0];
    //       controller1.text = controller1.text[0];
    //     }
    //   }
    //   else
    //     temp1 = controller1.text;
    // });
    // controller2.addListener(() {
    //   if(controller2.text.length > 1){
    //     if(controller2.text[0] == temp2){
    //       temp2 = controller2.text[1];
    //       controller2.text = controller2.text[1];
    //     }else{
    //       temp2 = controller2.text[0];
    //       controller2.text = controller2.text[0];
    //     }
    //   }
    //   else
    //     temp2 = controller2.text;
    // });
    // controller3.addListener(() {
    //   if(controller3.text.length > 1){
    //     if(controller3.text[0] == temp3){
    //       temp3 = controller3.text[1];
    //       controller3.text = controller3.text[1];
    //     }else{
    //       temp3 = controller3.text[0];
    //       controller3.text = controller3.text[0];
    //     }
    //   }
    //   else
    //     temp3 = controller3.text;
    // });
    // controller4.addListener(() {
    //   if(controller4.text.length > 1){
    //     if(controller4.text[0] == temp4){
    //       temp4 = controller4.text[1];
    //       controller4.text = controller4.text[1];
    //     }else{
    //       temp4 = controller4.text[0];
    //       controller4.text = controller4.text[0];
    //     }
    //   }
    //   else
    //     temp4 = controller4.text;
    // });
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
                      hoverColor: Colors.white,
                      focusColor: Colors.white,
                      splashColor: Colors.white,
                      highlightColor: Colors.white,
                      child: Padding(
                          padding: EdgeInsets.only(left: 20, top: 40),
                          child: Container(
                            width: 40,
                            height: 60,
                            child: Center(
                              child: SvgPicture.asset(
                                  'assets/svg_images/arrow_left.svg', color: AppColor.textColor,),
                            ),
                          )),
                      onTap: () => Navigator.pop(context),
                    ),
                    InkWell(
                      hoverColor: Colors.white,
                      focusColor: Colors.white,
                      splashColor: Colors.white,
                      highlightColor: Colors.white,
                      child:  Padding(
                          padding: EdgeInsets.only(right: 24, top: 40),
                          child: Container(
                            width: 40,
                            height: 60,
                            child: Center(
                              child: SvgPicture.asset(
                                  'assets/svg_images/code_cross.svg', color: AppColor.textColor,),
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
                        // border: Border.all(
                        //   color: mainColor,
                        // ),
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(10.0),
                        ),
                        border: Border.all(color: AppColor.mainColor),
                      ),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Text(
                                'Введите код из смс',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: AppColor.unselectedTextColor
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Container(
                              height: 80.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10)),
                                  color: AppColor.fieldColor),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Container(
                                    width: 200.0,
                                    padding: EdgeInsets.only(bottom: 19.0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(10),
                                            bottomLeft: Radius.circular(10)),
                                        color: AppColor.fieldColor),
                                    child: PinInputTextField(
                                      keyboardType: TextInputType.number,
                                      autoFocus: true,
                                      controller: pinController,
                                      pinLength: 4,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      decoration: UnderlineDecoration(
                                        textStyle: TextStyle(
                                          color: AppColor.textColor,
                                          fontSize: 30.0,
                                        ),
                                        colorBuilder: PinListenColorBuilder(
                                          AppColor.textColor,
                                          AppColor.textColor,
                                        ),
                                      ),
                                      // inputFormatter: <TextInputFormatter>[
                                      //   WhitelistingTextInputFormatter.digitsOnly
                                      // ],
                                      onChanged: (String newPin) async {
                                        if (this.mounted) {
                                          setState(() {
                                            code = newPin;
                                            buttonColor();
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                (state is SearchStateError) ? Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 10, bottom: 60, left: 0),
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
                    child: new TimerCountDown(codeScreenState: this),
                  ),
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: 20, left: 0, right: 0, top: 10),
                      child: Button(
                        key: buttonStateKey,
                        color: AppColor.fieldColor,
                        onTap: () async {
                          if (await Internet.checkConnection()) {
                            String temp = '';
                            temp = code;
                            codeGetBloc.add(SendCode(code: int.parse(temp)));
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

class TimerCountDown extends StatefulWidget {
  TimerCountDown({
    Key key,
    this.codeScreenState,
  }) : super(key: key);
  final _CodeScreenState codeScreenState;

  @override
  TimerCountDownState createState() {
    return new TimerCountDownState(codeScreenState: codeScreenState);
  }
}

class TimerCountDownState extends State<TimerCountDown> {
  TimerCountDownState({this.codeScreenState});

  final _CodeScreenState codeScreenState;
  Timer _timer;
  int _start = 60;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) => setState(
            () {
          if (_start < 1) {
            timer.cancel();
            _timer.cancel();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_start == 60) {
      startTimer();
    }
    return _start != 0
        ? Text('Получить новый код можно через $_start c',
        style: TextStyle(
          color: AppColor.additionalTextColor,
          fontSize: 13.0,
          letterSpacing: 1.2,
        ))
        : GestureDetector(
      child: Text(
        'Отправить код повторно',
        style: TextStyle(color: AppColor.additionalTextColor),
      ),
      onTap: () {
        codeScreenState.setState(() {});
      },
    );
  }
}

class Button extends StatefulWidget {
  Color color;
  final AsyncCallback onTap;

  Button({Key key, this.color, this.onTap}) : super(key: key);

  @override
  ButtonState createState() {
    return new ButtonState(color, onTap);
  }
}

class ButtonState extends State<Button> {
  String error = '';
  TextField code1;
  TextField code2;
  TextField code3;
  TextField code4;
  Color color;
  final AsyncCallback onTap;

  ButtonState(this.color, this.onTap);

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
                  color: Colors.white)),
        ),
      ),
      onTap: () async {
        if (await Internet.checkConnection()) {
          await onTap();
        } else {
          noConnection(context);
        }
      },
    );
  }

  String validateMobile(String value) {
    String pattern = r'(^(?:[+]?7)[0-9]{10}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return 'Укажите норер';
    } else if (!regExp.hasMatch(value)) {
      return 'Указан неверный номер';
    }
    return null;
  }
}