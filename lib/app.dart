import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Localization/app_localizations.dart';
import 'package:flutter_app/Preloader/device_id_screen.dart';
import 'package:flutter_app/Screens/PaymentScreen/View/payment_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'Preloader/device_id_screen.dart';

class App extends StatelessWidget {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Faem Eda",
      theme: ThemeData(
        primaryColor: Color(0xFF09B44D),
        cursorColor: Color(0xFF09B44D),
        unselectedWidgetColor: Color(0xFF09B44D),
        selectedRowColor: Color(0xFF09B44D),
        toggleableActiveColor: Color(0xFF09B44D),
      ),
      home: DeviceIdScreen(),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],localeResolutionCallback: (locale, supportedLocaleList){

        for(var v in supportedLocaleList){
          if(v.languageCode == locale.languageCode && v.countryCode == locale.countryCode){
            return locale;
          }
        }
        return supportedLocaleList.first;
      },
      supportedLocales: [
        const Locale('ru', 'RU'),
        const Locale('en', 'US'),
      ],
    );
  }
}