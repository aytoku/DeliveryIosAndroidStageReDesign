import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_app/FCM/API/sendFcmToken.dart';
import 'package:flutter_app/Screens/OrdersScreen/Model/OrdersDetailsModel.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert' as convert;

class FirebaseNotifications {
  FirebaseMessaging _firebaseMessaging;

  Future setUpFirebase() async{
    _firebaseMessaging = FirebaseMessaging();
    await firebaseCloudMessaging_Listeners();
  }

  // ignore: missing_return
  static Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
    print(message);
    print('EXPLOOOOSION');
    messageHandler(message);
  }


  static Future<void> OrderCheckingUpdater(String order_uuid, String order_state, Map<String, dynamic> data) async {
    if(homeScreenKey.currentState != null && homeScreenKey.currentState.orderList != null
        && !DeliveryStates.contains(order_state)){
      homeScreenKey.currentState.orderList.removeWhere((element) => element.ordersDetailsItem.uuid == order_uuid);
      // if(homeScreenKey.currentState.orderList.length == 0)
      //   homeScreenKey.currentState.setState(() { });
      // Navigator.push(
      //   homeScreenKey.currentContext,
      //   MaterialPageRoute(builder: (_) {
      //     return CompletedOrderScreen();
      //   }),
      // );
    }
    if(orderCheckingStates.containsKey(order_uuid)) {
      if(orderCheckingStates[order_uuid].currentState != null) {
        orderCheckingStates[order_uuid].currentState.ordersStoryModelItem = OrderDetailsModelItem.fromJson(data['payload']['order']);
        orderCheckingStates[order_uuid].currentState.setState(() {
//          orderCheckingStates[order_uuid].currentState.ordersStoryModelItem
//              .state = order_state;
        });
      } else {
        if(homeScreenKey.currentState != null && homeScreenKey.currentState.orderList != null) {
          homeScreenKey.currentState.orderList.forEach((element) async {
            if(element.ordersDetailsItem.uuid == order_uuid) {
              element.ordersDetailsItem =OrderDetailsModelItem.fromJson(data['payload']['order']);
//              element.ordersStoryModelItem.state = order_state;
              return;
            }
          });
        }
      }
    }
  }


  static void messageHandler(Map<String, dynamic> message) async {

    //ios fix
    print(message);
    if(!message.containsKey('data') && (message.containsKey('payload') || message.containsKey('tag'))){
      print('arturia saber');
      message['data'] = new Map<String, dynamic>();
      if(message.containsKey('payload')){
        message['data']['payload'] = message['payload'];
        print('arturia lancer');
      }
      if(message.containsKey('tag')){
        message['data']['tag'] = message['tag'];
        print('arturia kartyojnik');
      }
      if(message.containsKey('notification_message')){
        message['data']['notification_message'] = message['notification_message'];
        print('arturia gopnik');
      }
    }
    print(message);


    var data =  message;
    if(data.containsKey('tag')) {
      switch (data['tag']){
        case 'order-state' :
          String order_state = data['payload']['state'];
          String order_uuid = data['payload']['order']['uuid'];
          OrderCheckingUpdater(order_uuid, order_state, data);
          break;

      // case 'chat_message' :
      //   var payload = data['payload'];
      //   var message = ChatMessage.fromJson(payload);
      //   if(chatKey.currentState != null){
      //     chatKey.currentState.setState(() {
      //       chatKey.currentState.chatMessageList.insert(0, new ChatMessageScreen(chatMessage: message, key: new ObjectKey(message)));
      //     });
      //   }
      //   String order_uuid = message.order_uuid;
      //   if(orderCheckingStates.containsKey(order_uuid)) {
      //     if(orderCheckingStates[order_uuid].currentState != null) {
      //       orderCheckingStates[order_uuid].currentState.setState(() {
      //       });
      //     }
      //   }
      //   break;
      //
      // case 'chat_messages_read' :
      //   var payload = data['payload'];
      //   List<dynamic> messagesUuid = payload['messages_uuid'];
      //   if(chatKey.currentState != null && chatKey.currentState.order_uuid == payload['order_uuid']){
      //     messagesUuid.forEach((element) {
      //       if(chatMessagesStates.containsKey(element)){
      //         // ignore: invalid_use_of_protected_member
      //         if(chatMessagesStates[element].currentState != null) {
      //           chatMessagesStates[element].currentState.setState(() {
      //             chatMessagesStates[element].currentState.chatMessage.ack = true;
      //           });
      //         } else {
      //           chatKey.currentState.chatMessageList.forEach((message) {
      //             if(message.chatMessage.uuid == element) {
      //               message.chatMessage.ack = true;
      //               return;
      //             }
      //           });
      //         }
      //       }
      //     });
      //   }
      //   break;
      }
    }
  }


  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  new FlutterLocalNotificationsPlugin();

  void firebaseCloudMessaging_Listeners() async{
    if (Platform.isIOS) iOS_Permission();
    var token = await _firebaseMessaging.getToken();
    FCMToken = token;
    await sendFCMToken(token, necessaryDataForAuth.device_id);
    print('DAITE MNE TOKEN   ' + token);
    var android = new AndroidInitializationSettings('@mipmap/faem');
    var ios = new IOSInitializationSettings();
    var platform = new InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(platform);
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
        await showNotification(message);
        await messageHandler(message);
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
        await messageHandler(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
        await messageHandler(message);
      },
    );
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  Future<void> showNotification(Map<String, dynamic> message) async {
    String title = message['title'];
    String body = message['message'];
    if(Platform.isIOS){
      body = '';
    }
    if(title == null)
      return;
    var androidChannelSpecifics = AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      "CHANNEL_DESCRIPTION",
      importance: Importance.Max,
      priority: Priority.High,
      playSound: true,
      timeoutAfter: 5000,
      styleInformation: DefaultStyleInformation(true, true),
    );
    var iosChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics =
    NotificationDetails(androidChannelSpecifics, iosChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,  // Notification ID
      title, // Notification Title
      body, // Notification Body, set as null to remove the body
      //for ios change body on empty field
//      title_ios,
//      '',
      platformChannelSpecifics,
      payload: 'New Payload', // Notification Payload
    );
  }
}