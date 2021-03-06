import 'package:flutter/material.dart';
import 'package:flutter_app/Config/config.dart';
import 'package:flutter_app/Screens/AuthScreen/Model/Auth.dart';
import 'package:flutter_app/Screens/ChatScreen/View/chat_screen.dart';
import 'package:flutter_app/Screens/CityScreen/Model/FilteredCities.dart';
import 'package:flutter_app/Screens/CodeScreen/Model/AuthCode.dart';
import 'package:flutter_app/Screens/HomeScreen/View/home_screen.dart';
import 'package:flutter_app/Screens/HomeScreen/Widgets/OrderChecking.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Model/FilteredProductCategories.dart';
import 'package:flutter_app/Screens/ServiceScreen/View/tickets_chat_screen.dart';

import '../Screens/HomeScreen/Model/Stock.dart';

Map<String,GlobalKey<OrderCheckingState>> orderCheckingStates = new Map<String,GlobalKey<OrderCheckingState>>();
Map<String,GlobalKey<TicketsChatMessageScreenState>> ticketsChatMessagesStates = new Map<String,GlobalKey<TicketsChatMessageScreenState>>();
GlobalKey<HomeScreenState>homeScreenKey = new GlobalKey<HomeScreenState>(debugLabel: 'homeScreenKey');
GlobalKey<ChatContentState>chatContentKey = new GlobalKey<ChatContentState>();
AuthCodeData authCodeData = null;
AuthData authData = null;
String FCMToken = '';
int code = 0;
NecessaryDataForAuth necessaryDataForAuth = new NecessaryDataForAuth(phone_number: null, refresh_token: null, device_id: null, name: null);
FilteredCities selectedCity;
String header = 'eda/fermer-market';
FilteredProductCategories selectedCategoriesUuid;
String tempClientUuid = '';
AssetImage assetImage = AssetImage('assets/images/Fermer_yellow.png');
bool lock = false;
Stock savedPromo = new Stock();