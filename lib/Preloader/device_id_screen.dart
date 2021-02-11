import 'package:flutter/material.dart';
import 'package:flutter_app/Config/config.dart';
import 'package:flutter_app/Screens/CityScreen/View/city_screen.dart';
import 'package:flutter_app/data/data.dart';

import '../Amplitude/amplitude.dart';
import '../Screens/HomeScreen/View/home_screen.dart';
import '../data/data.dart';
import '../data/data.dart';
import '../data/data.dart';
import '../data/data.dart';

class DeviceIdScreen extends StatelessWidget {

  GlobalKey<CityScreenState> cityScreenKey = new GlobalKey();


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: FutureBuilder<NecessaryDataForAuth>(
        future: NecessaryDataForAuth.getData(),
        builder:
            (BuildContext context, AsyncSnapshot<NecessaryDataForAuth> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // CartDataModel.getCart().then((value) {
            //   currentUser.cartModel = value;
            //   print('Cnjbn');
            // });
            necessaryDataForAuth = snapshot.data;
            if (necessaryDataForAuth.refresh_token == null ||
                necessaryDataForAuth.phone_number == null ||
                necessaryDataForAuth.name == null) {
              currentUser.isLoggedIn = false;
              AmplitudeAnalytics.initialize(necessaryDataForAuth.device_id).then((value){
                AmplitudeAnalytics.analytics.logEvent('open_app');
              });
              if(necessaryDataForAuth.city == null){
                return CityScreen();
              }else{
                selectedCity = necessaryDataForAuth.city;
                return HomeScreen();
              }
            }
            print(necessaryDataForAuth.refresh_token);
            AmplitudeAnalytics.initialize(necessaryDataForAuth.phone_number).then((value){
              AmplitudeAnalytics.analytics.logEvent('open_app');
            });
            if(necessaryDataForAuth.city == null){
              return CityScreen();
            }else{
              selectedCity = necessaryDataForAuth.city;
              return HomeScreen();
            }
          } else {
            return Center(
              child: Image(
                image: AssetImage('assets/images/faem.png'),
              )
            );
          }
        },
      ),
    );
  }
}