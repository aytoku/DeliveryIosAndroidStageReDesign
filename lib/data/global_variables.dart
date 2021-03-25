import 'package:flutter/material.dart';
import 'package:flutter_app/Config/config.dart';
import 'package:flutter_app/Screens/AuthScreen/Model/Auth.dart';
import 'package:flutter_app/Screens/ChatScreen/View/chat_message_screen.dart';
import 'package:flutter_app/Screens/ChatScreen/View/chat_screen.dart';
import 'package:flutter_app/Screens/CityScreen/Model/FilteredCities.dart';
import 'package:flutter_app/Screens/CodeScreen/Model/AuthCode.dart';
import 'package:flutter_app/Screens/HomeScreen/View/home_screen.dart';
import 'package:flutter_app/Screens/HomeScreen/Widgets/OrderChecking.dart';
import 'package:flutter_app/Screens/ServiceScreen/View/tickets_chat_screen.dart';

Map<String,GlobalKey<OrderCheckingState>> orderCheckingStates = new Map<String,GlobalKey<OrderCheckingState>>();
Map<String,GlobalKey<ChatMessageScreenState>> chatMessagesStates = new Map<String,GlobalKey<ChatMessageScreenState>>();
Map<String,GlobalKey<TicketsChatMessageScreenState>> ticketsChatMessagesStates = new Map<String,GlobalKey<TicketsChatMessageScreenState>>();
GlobalKey<HomeScreenState>homeScreenKey = new GlobalKey<HomeScreenState>(debugLabel: 'homeScreenKey');
GlobalKey<ChatScreenState>chatKey = new GlobalKey<ChatScreenState>();
AuthCodeData authCodeData = null;
AuthData authData = null;
String FCMToken = '';
int code = 0;
NecessaryDataForAuth necessaryDataForAuth = new NecessaryDataForAuth(phone_number: null, refresh_token: null, device_id: null, name: null);
FilteredCities selectedCity;
class AppColor {
  AppColor._();

  static const Color mainColor = Color(0xFF92CB45);
  static const Color textColor = Color(0xFF000000);
  static const Color unselectedTextColor = Color(0xFFFFFFFF);
  static const Color additionalTextColor = Color(0xFF9E9E9E);
  static const Color themeColor = Color(0xFFFFFFFF);
  static const Color fieldColor = Color(0xFFFFFFFF);
  static const Color elementsColor = Color(0xFFEFEFEF);
  static const Color subElementsColor = Color(0xFFEFEFEF);
  static const Color borderFieldColor = Color(0xFF92CB45);
  static const Color unselectedBorderFieldColor = Color(0xFF9E9E9E);

}
String header = 'eda/siria';