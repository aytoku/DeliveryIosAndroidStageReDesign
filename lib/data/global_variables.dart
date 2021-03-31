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

  static Color mainColor = Color(0xFFF7CB46);
  static Color textColor = Color(0xFF000000);
  static Color unselectedTextColor = Color(0xFFFFFFFF);
  static Color additionalTextColor = Color(0xFF9E9E9E);
  static Color themeColor = Color(0xFFFFFFFF);
  static Color fieldColor = Color(0xFFFFFFFF);
  static Color elementsColor = Color(0xFFEFEFEF);
  static Color subElementsColor = Color(0xFFEFEFEF);
  static Color borderFieldColor = Color(0xFFF7CB46);
  static Color unselectedBorderFieldColor = Color(0xFF9E9E9E);


  static fromJson(Map<String, dynamic> json){
    mainColor = (json['main_color'] == null || json['main_color'] == '') ? mainColor : Color(int.parse(json['main_color']));
    textColor = (json['text_color'] == null || json['text_color'] == '') ? textColor : Color(int.parse(json['text_color']));
    unselectedTextColor = (json['unselected_text_color'] == null || json['unselected_text_color'] == '') ? unselectedTextColor : Color(int.parse(json['unselected_text_color']));
    additionalTextColor = (json['additional_text_color'] == null || json['additional_text_color'] == '') ? additionalTextColor : Color(int.parse(json['additional_text_color']));
    themeColor = (json['theme_color'] == null || json['theme_color'] == '') ? themeColor : Color(int.parse(json['theme_color']));
    fieldColor = (json['text_field_color'] == null || json['text_field_color'] == '') ? fieldColor : Color(int.parse(json['text_field_color']));
    elementsColor = (json['elements_color'] == null || json['elements_color'] == '') ? elementsColor : Color(int.parse(json['elements_color']));
    subElementsColor = (json['sub_elements_color'] == null || json['sub_elements_color'] == '') ? subElementsColor : Color(int.parse(json['sub_elements_color']));
    borderFieldColor = (json['border_field_color'] == null || json['border_field_color'] == '') ? borderFieldColor : Color(int.parse(json['border_field_color']));
    unselectedBorderFieldColor = (json['unselected_border_field_color'] == null || json['unselected_border_field_color'] == '') ? unselectedBorderFieldColor : Color(int.parse(json['unselected_border_field_color']));
  }
}
String header = 'eda/fermer-market';

