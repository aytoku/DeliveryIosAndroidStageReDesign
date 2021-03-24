import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/Config/config.dart';
import 'package:flutter_app/Screens/CityScreen/View/city_screen.dart';
import 'package:flutter_app/Screens/HomeScreen/Bloc/restaurant_get_bloc.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Amplitude/amplitude.dart';
import '../Config/config.dart';
import '../Screens/HomeScreen/View/home_screen.dart';
import '../data/data.dart';


class DeviceIdScreen extends StatefulWidget{
  @override
  DeviceIdScreenState createState() =>
      DeviceIdScreenState();
}

class DeviceIdScreenState extends State<DeviceIdScreen> {

  GlobalKey<CityScreenState> cityScreenKey = new GlobalKey();


  Future<NecessaryDataForAuth> devId;
  bool selected = true;
  Timer timer;
  bool navigate = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    devId = NecessaryDataForAuth.getData();
    // new Timer.periodic(const Duration(milliseconds: 50), (Timer t) => selected = false);
    timer = new Timer(const Duration(seconds: 3), nav);
  }

  void nav() {

    navigate = true;
    setState(() {});
    print("navigate: $navigate");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width *
        MediaQuery.of(context).devicePixelRatio;

    double middleX = screenWidth / 21.5;

    print (middleX);
    return Container(

      color: AppColor.themeColor,
      child: FutureBuilder<NecessaryDataForAuth>(
        future: devId,
        builder:
            (BuildContext context, AsyncSnapshot<NecessaryDataForAuth> snapshot) {
          if (snapshot.connectionState == ConnectionState.done && navigate == true) {

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
                homeScreenKey =
                new GlobalKey<HomeScreenState>();
                return BlocProvider(
                  create: (context)=> RestaurantGetBloc(),
                  child: HomeScreen(),
                );
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
              homeScreenKey =
              new GlobalKey<HomeScreenState>();
              return BlocProvider(
                create: (context)=> RestaurantGetBloc(),
                child: HomeScreen(),
              );
            }
          } else {
            return Stack(
              alignment: Alignment.center,
              children: [
                Image.asset('assets/gif/hatta_preloader.gif'),
              ],
            );
          }
        },
      ),
    );
  }
}