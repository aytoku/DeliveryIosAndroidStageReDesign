import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../data/data.dart';
import '../../../data/data.dart';
import '../../../data/data.dart';
import '../../../data/globalVariables.dart';
import '../../HomeScreen/Bloc/restaurant_get_bloc.dart';
import '../../HomeScreen/View/home_screen.dart';

class ChatScreen extends StatefulWidget {

  ChatScreen({Key key}) : super(key: key);

  @override
  ChatScreenState createState() {
    return new ChatScreenState();
  }
}

class ChatScreenState extends State<ChatScreen> {

  ChatScreenState();
  TextEditingController messageField = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50, bottom: 15),
              child: Container(
                padding: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 1,
                        offset: Offset(0,2)
                    )
                  ],
                ),
                child: Row(
                  children: <Widget>[
                    InkWell(
                        hoverColor: AppColor.themeColor,
                        focusColor: AppColor.themeColor,
                        splashColor: AppColor.themeColor,
                        highlightColor: AppColor.themeColor,
                        onTap: (){
                          homeScreenKey = new GlobalKey<HomeScreenState>();
                          Navigator.pushReplacement(context,
                              new MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                    create: (context) => RestaurantGetBloc(),
                                    child: new HomeScreen(),
                                  )
                              )
                          );
                        },
                        child: Container(
                            height: 40,
                            width: 60,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 12, bottom: 12, right: 15, left: 0),
                              child: SvgPicture.asset(
                                  'assets/svg_images/arrow_left.svg'),
                            ))),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: SvgPicture.asset(
                              'assets/svg_images/chat_logo.svg'),
                        ),
                        Column(
                          children: [
                            Text(
                              'Поддержка',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF3F3F3F)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 32),
                              child: Text('Мы рядом 24/7',
                                style: TextStyle(
                                    color: AppColor.additionalTextColor,
                                    fontSize: 12
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,

                ),
              ),
              onTap: (){
                FocusScope.of(context).unfocus();
              },
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Container(
                    height: 62,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Color(0xFFF9F9F9),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 1,
                          offset: Offset(0,-1)
                        )
                      ],
                    ),
                    child: TextField(
                      cursorColor: Colors.grey,
                      controller: messageField,
                      decoration: new InputDecoration(
                        suffixIcon: InkWell(
                          child: Container(
                            padding: EdgeInsets.all(6),
                            child: SvgPicture.asset((messageField.text.length == 0)
                                ? 'assets/svg_images/inactive_message_button.svg'
                                : 'assets/svg_images/send_message.svg',
                            ),
                          ),
                          onTap: (){
                            setState(() {

                            });
                          },
                        ),
                        hintText: 'Сообщение ...',
                        contentPadding: EdgeInsets.only(left: 20, right: 10),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none
                        ),
                        border: new OutlineInputBorder(
                            borderSide: BorderSide.none
                        ),
                      ),
                    ),
                  )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}