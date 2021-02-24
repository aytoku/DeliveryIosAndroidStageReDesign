import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/Screens/AuthScreen/Bloc/phone_number_event.dart';
import 'package:flutter_app/Screens/AuthScreen/Bloc/phone_number_get_bloc.dart';
import 'package:flutter_app/Screens/AuthScreen/Bloc/phone_number_state.dart';
import 'package:flutter_app/Screens/CodeScreen/Bloc/code_get_bloc.dart';
import 'package:flutter_app/Screens/HomeScreen/View/home_screen.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/data.dart';
import '../../CodeScreen/View/code_screen.dart';

class AuthScreen extends StatefulWidget {
  AuthSources source;
  AuthScreen({this.source = AuthSources.Drawer,Key key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState(source);
}

class _AuthScreenState extends State<AuthScreen> {
  AuthSources source;
  var controller;
  AuthGetBloc authGetBloc;
  GlobalKey<ButtonState> buttonStateKey;
  _AuthScreenState(this.source);

  @override
  void initState() {
    super.initState();
    authGetBloc = BlocProvider.of<AuthGetBloc>(context); // инициализация bloc
    controller = new MaskedTextController(mask: '+7 000 000-00-00');
    buttonStateKey = new GlobalKey<ButtonState>();
    controller.afterChange = (String previous, String next){
      if(next.length > previous.length){
        controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
      }
      return false;
    };
    controller.beforeChange = (String previous, String next) {
      if(controller.text == '8') {
        controller.updateText('+7 ');
      }
      return true;
    };
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: BlocListener<AuthGetBloc, AuthState>( // листенер для переходов на другие скрины
          bloc: authGetBloc,
          listener: (BuildContext context, AuthState state){
            if(state is AuthStateSuccess){
              if(state.goToHomeScreen){
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => HomeScreen()),
                        (Route<dynamic> route) => false);
              } else{
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => BlocProvider(
                        create: (context) => CodeGetBloc(),
                        child: new CodeScreen(state.authData, source: source),
                    ),
                  ),
                );
              }
            }
          },
          child: BlocBuilder<AuthGetBloc, AuthState>( // билдинг скрина в зависимости от состояния
            bloc: authGetBloc,
            builder: (BuildContext context, AuthState state){
              return Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                    child: Row(
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                              padding: EdgeInsets.only(left: 0, top: 30),
                              child: Container(
                                  height: 40,
                                  width: 60,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 12, bottom: 12, right: 10),
                                    child: SvgPicture.asset(
                                        'assets/svg_images/arrow_left.svg'),
                                  ))),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 140),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            height: 91,
                            width: 300,
                            decoration: BoxDecoration(
                              color: Color(0xFF09B44D),
                              border: Border.all(
                                color: Color(0xFF09B44D),
                              ),
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Text(
                                    'Укажите ваш номер телефона',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: TextField(
                                      autofocus: true,
                                      controller: controller,
                                      style: TextStyle(fontSize: 18),
                                      textAlign: TextAlign.start,
                                      maxLength: 16,
                                      keyboardType: TextInputType.number,
                                      decoration: new InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10),),
                                          borderSide: BorderSide(
                                            width: 0,
                                            style: BorderStyle.none,
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        counterText: '',
                                        contentPadding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.18),
                                        hintStyle: TextStyle(
                                          color: Color(0xFFC0BFC6),
                                        ),
                                        hintText: '+7918 888-88-88',
                                      ),
                                      onChanged: (String value) {
                                        if(value == '+7 8'){
                                          controller.text = '+7';
                                        }
                                        if(value.length == 16){
                                          FocusScope.of(context).requestFocus(new FocusNode());
                                        }
                                        currentUser.phone = value;
                                        if (value.length > 0 &&
                                            buttonStateKey.currentState.color !=
                                                Color(0xFF09B44D)) {
                                          buttonStateKey.currentState.setState(() {
                                            buttonStateKey.currentState.color =
                                                Color(0xFF09B44D);
                                          });
                                        } else if (value.length == 0 &&
                                            buttonStateKey.currentState.color !=
                                                Color(0xF3F3F3F3)) {
                                          buttonStateKey.currentState.setState(() {
                                            buttonStateKey.currentState.color =
                                                Color(0xF3F3F3F3);
                                          });
                                        }
                                      },
                                    )
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      (state is SearchStateError) ? Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            state.error,
                            style: TextStyle(
                                color: Colors.red, fontSize: 12),
                          ),
                        ),
                      ) : Container(),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 85, top: 10),
                        child: Text.rich(
                          TextSpan(
                              text:
                              'Нажимая кнопку “Далее”, вы принимете условия\n',
                              style: TextStyle(
                                  color: Color(0x97979797), fontSize: 13),
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Пользовательского соглашения',
                                    style: TextStyle(
                                        decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        if (await Internet.checkConnection()) {
                                          if (await canLaunch(
                                              "https://faem.ru/legal/agreement")) {
                                            await launch(
                                                "https://faem.ru/legal/agreement");
                                          }
                                        } else {
                                          noConnection(context);
                                        }
                                      }),
                                TextSpan(
                                  text: ' и ',
                                ),
                                TextSpan(
                                    text: 'Политики\nконфиденцальности',
                                    style: TextStyle(
                                        decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        if (await Internet.checkConnection()) {
                                          if (await canLaunch(
                                              "https://faem.ru/privacy")) {
                                            await launch(
                                                "https://faem.ru/privacy");
                                          }
                                        } else {
                                          noConnection(context);
                                        }
                                      }),
                              ]),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Button(key: buttonStateKey, color: Color(0xF3F3F3F3), source: source, authGetBloc: authGetBloc)
                    ),
                  ),
                ],
              );
            },
          ),
        )
    );
  }
}

class Button extends StatefulWidget {
  Color color;
  AuthSources source;
  AuthGetBloc authGetBloc;

  Button({Key key, this.color, this.source, this.authGetBloc}) : super(key: key);

  @override
  ButtonState createState() {
    return new ButtonState(color, source, authGetBloc);
  }
}

class ButtonState extends State<Button> {
  String error = '';
  Color color = Color(0xFFF3F3F3);
  AuthSources source;
  AuthGetBloc authGetBloc;

  ButtonState(this.color, this.source, this.authGetBloc);

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
        if (await Internet.checkConnection()) {
          currentUser.phone = currentUser.phone.replaceAll('-', '');
          currentUser.phone = currentUser.phone.replaceAll(' ', '');
          print(currentUser.phone);
          if (validateMobile(currentUser.phone) == null) {
            if (currentUser.phone[0] != '+') {
              currentUser.phone = '+' + currentUser.phone;
            }
            authGetBloc.add(SendPhoneNumber(phoneNumber: currentUser.phone)); // отправка события в bloc
          } else {
            authGetBloc.add(SetError('Указан неверный номер')); // отправка события в bloc
          }
        } else {
          noConnection(context);
        }
      },
    );
  }
}

enum AuthSources{
  Drawer,
  Cart
}