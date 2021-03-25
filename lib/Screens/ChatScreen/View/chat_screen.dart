import 'package:flutter/material.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/Screens/ChatScreen/API/chat.dart';
import 'package:flutter_app/Screens/ChatScreen/Model/ChatHistoryModel.dart';
import 'package:flutter_app/Screens/ChatScreen/View/chat_message_screen.dart';
import 'package:flutter_app/Screens/ChatScreen/View/quick_message_screen.dart';
import 'package:flutter_app/Screens/HomeScreen/View/home_screen.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_app/data/global_variables.dart';


class ChatScreen extends StatefulWidget {
  String order_uuid;

  ChatScreen({Key key, this.order_uuid}) : super(key: key);

  @override
  ChatScreenState createState() {
    return new ChatScreenState(order_uuid);
  }
}

class ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  List<ChatMessageScreen> chatMessageList;
  String order_uuid;

  ChatScreenState(this.order_uuid);

  TextEditingController messageField = new TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed){
      setState(() {

      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  buildChat() {
    List<String> messagedUuid = new List<String>();
    chatMessageList.forEach((element) {
      if (element.chatMessage.to == 'client' &&
          element.chatMessage.ack == false) {
        element.chatMessage.ack = true;
        messagedUuid.add(element.chatMessage.uuid);
      }
    });
    if (messagedUuid.length > 0) {
      Chat.readMessage(messagedUuid);
    }
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Padding(
              padding: EdgeInsets.only(right: 10),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  'Чат с водителем',
                  style: TextStyle(
                      fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF424242)),
                ),
              )),
          leading: InkWell(
            child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                    padding: EdgeInsets.only(left: 15, top: 0),
                    child: Container(
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 20, bottom: 20, right: 0),
                          child: SvgPicture.asset('assets/svg_images/arrow_left.svg'),
                        )))),
            onTap: () {
              Navigator.pushReplacement(
                context,
                new MaterialPageRoute(
                  builder: (context) => new HomeScreen(),
                ),
              );
            },
          ),
        ),
        body: Stack(
          children: <Widget>[
            Positioned(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: MediaQuery.of(context).viewInsets.left,
              right: MediaQuery.of(context).viewInsets.right,
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(top: 60),
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.9,
                        child: Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: ListView.builder(
                            reverse: true,
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.vertical,
                            itemCount: chatMessageList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return chatMessageList[index];
                            },
                            //chatMessageList
                          ),
                        ),
                      ),
                      Stack(
                        children: <Widget>[
                          Container(
                            height: 60,
                            child: QuickMessageScreen(
                              messageField: messageField,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 65, bottom: 20, right: 15, left: 15),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Padding(
                                        padding: EdgeInsets.only(right: 10, top: 0),
                                        child: Container(
                                          height: 34,
                                          child: TextField(
                                            controller: messageField,
                                            decoration: new InputDecoration(
                                              contentPadding: EdgeInsets.only(bottom: 5, left: 10, right: 15),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius: const BorderRadius.all(
                                                    const Radius.circular(15.0),
                                                  ),
                                                  borderSide: BorderSide(
                                                      color: Color(0xFFC8C7CC)
                                                  )
                                              ),
                                              border: new OutlineInputBorder(
                                                borderRadius: const BorderRadius.all(
                                                  const Radius.circular(15.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                    )
                                ),
                                InkWell(
                                  child: Container(
                                      height: 40,
                                      width: 40,
                                      child: Padding(
                                        padding: EdgeInsets.all(6),
                                        child: SvgPicture.asset(
                                            'assets/svg_images/send_message.svg'),
                                      )
                                  ),
                                  onTap: () async {
                                    if (await Internet.checkConnection()) {
                                      var message = await Chat.sendMessage(
                                          order_uuid, messageField.text, 'driver');
                                      chatMessagesStates.forEach((key, value) {
                                        print(
                                            key + ' ' + value.currentState.toString());
                                      });
                                      print("Отправка сообщения");
                                      messageField.clear();
                                      setState(() {
                                        GlobalKey<ChatMessageScreenState>
                                        chatMessageScreenStateKey =
                                        new GlobalKey<ChatMessageScreenState>();
                                        chatMessagesStates[message.uuid] =
                                            chatMessageScreenStateKey;
                                        chatMessageList.insert(
                                            0,
                                            new ChatMessageScreen(
                                                key: chatMessageScreenStateKey,
                                                chatMessage: message));
                                      });
                                    } else {
                                      noConnection(context);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    if (chatMessageList != null) {
      print(chatMessageList.length);
      return buildChat();
    }
    return Container(
      color: Colors.white,
      child: FutureBuilder<ChatHistoryModel>(
        future: Chat.loadChatHistory(order_uuid, 'driver'),
        builder:
            (BuildContext context, AsyncSnapshot<ChatHistoryModel> snapshot) {
          print('tututuwapatututuwapa ' + order_uuid);
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            chatMessagesStates.clear();
            chatMessageList = new List<ChatMessageScreen>();
            snapshot.data.chatMessageList.forEach((element) {
              GlobalKey<ChatMessageScreenState> chatMessageScreenStateKey =
              new GlobalKey<ChatMessageScreenState>();
              chatMessagesStates[element.uuid] = chatMessageScreenStateKey;
              chatMessageList.add(new ChatMessageScreen(
                  chatMessage: element, key: chatMessageScreenStateKey));
            });
            return buildChat();
          } else {
            return Center(
                child: SpinKitFadingCircle(
                  color: Colors.green,
                  size: 50.0,
                )
            );
          }
        },
      ),
    );
  }
}