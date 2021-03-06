import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/ChatScreen/API/create_message.dart';
import 'package:flutter_app/Screens/ChatScreen/API/get_filtered_messages.dart';
import 'package:flutter_app/Screens/ChatScreen/Model/CreateMessage.dart';
import 'package:flutter_app/Screens/ChatScreen/Widgets/ChatFieldButton.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

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
  GlobalKey<ChatFieldButtonState> chatFieldKey;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chatContentKey = GlobalKey();
    chatFieldKey = GlobalKey();
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
            ChatContent(key: chatContentKey),
            Align(
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
                      maxLines: 5,
                      onChanged: (text){
                        chatFieldKey.currentState.setState(() {

                        });
                      },
                      decoration: new InputDecoration(
                        suffixIcon: InkWell(
                          child: Container(
                            padding: EdgeInsets.all(6),
                            child: ChatFieldButton(parent: this, key: chatFieldKey,),
                          ),
                          onTap: () async{
                            await createMessage(messageField.text);
                            chatContentKey.currentState.setState(() {

                            });
                            messageField.clear();
                          },
                        ),
                        hintText: 'Сообщение ...',
                        contentPadding: EdgeInsets.only(left: 20, right: 10, top: 30),
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
          ],
        ),
      ),
    );
  }
}



class ChatContent extends StatefulWidget {
  ChatContent({Key key}) : super(key: key);
  @override
  ChatContentState createState() => ChatContentState();
}

class ChatContentState extends State<ChatContent> {
  ChatData chatData;
  ScrollController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = ScrollController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  scrollToEnd(){
    controller.animateTo(controller.position.maxScrollExtent, duration: Duration(milliseconds: 100), curve: Curves.ease);
  }

  List<Widget> buildChatList(){
    List<Widget> result = new List<Widget>();
    DateTime tempDate = new DateTime(1970);
    chatData.chat.forEach((element) {
      DateTime date = new DateTime(element.createdAt.year, element.createdAt.month, element.createdAt.day);
      if(date != tempDate){
        result.add(
          Center(
              child: Text(DateFormat.yMMMd(Localizations.localeOf(context).languageCode).format(date),
                style: TextStyle(
                  fontSize: 12
                ),
              )
        ));
        tempDate = date;
      }
      if(element.operatorUuid != ''){
        result.add(Padding(
          padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color(0xFFF6F6F6)
                      ),
                      padding: EdgeInsets.only(left: 16, right: 16, top: 9, bottom: 9),
                      child: Text(element.msg,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: AppColor.textColor
                        ),
                      )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    children: [
                      Text(element.createdAt.hour.toString()
                          + ' ' +
                          element.createdAt.minute.toString()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
      }else{
        result.add(Padding(
          padding: const EdgeInsets.only(bottom: 15, left: 50, right: 15),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Column(
                    children: [
                      Text(element.createdAt.hour.toString()
                          + ' ' +
                          element.createdAt.minute.toString()),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: SvgPicture.asset(!(element.unreaded) ?
                        'assets/svg_images/read_message.svg' : 'assets/svg_images/unread_message.svg'),
                      )
                    ],
                  ),
                ),
                Flexible(
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color(0xFF7D7D7D)
                      ),
                      padding: EdgeInsets.only(left: 16, right: 16, top: 9, bottom: 9),
                      child: Text(element.msg,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.white
                        ),
                      )
                  ),
                ),
              ],
            ),
          ),
        ));
      }
    });

    return List.from(result.reversed);
  }

  buildChatBody(){
    return Align(
      alignment: Alignment.bottomCenter,
      child: ListView(
        reverse: true,
        controller: controller,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        scrollDirection: Axis.vertical,
        children: buildChatList()
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Expanded(
      child: FutureBuilder<ChatData>(
        future: getFilteredMessage(),
        builder: (BuildContext context,
            AsyncSnapshot<ChatData> snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.done &&
              snapshot.data != null || snapshot.hasData) {
            chatData = snapshot.data;
            return buildChatBody();
          } else {
            return Container(
              height: 0,
            );
          }
        },
      ),
    );
  }
}
