import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/AuthScreen/Bloc/phone_number_get_bloc.dart';
import 'package:flutter_app/Screens/AuthScreen/View/auth_screen.dart';
import 'package:flutter_app/Screens/CityScreen/View/add_city_screen.dart';
import 'package:flutter_app/Screens/HomeScreen/Bloc/restaurant_get_bloc.dart';
import 'package:flutter_app/Screens/HomeScreen/View/home_screen.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CityScreen extends StatefulWidget {

  CityScreen({Key key}) : super(key: key);

  @override
  CityScreenState createState() {
    return new CityScreenState();
  }
}

class CityScreenState extends State<CityScreen>{

  TextEditingController cityController;

  @override
  void initState(){
    super.initState();
    cityController = new TextEditingController();
  }

  @override
  void dispose(){
    super.dispose();
    cityController.dispose();
  }


  CityScreenState();

  showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(context).pop(true);
        });
        return Padding(
          padding: EdgeInsets.only(bottom: 500),
          child: Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            child: Container(
              height: 50,
              width: 100,
              child: Center(
                child: Text("Выберите город"),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if(selectedCity != null){
      cityController.text = selectedCity.name;
    }
    return Scaffold(
        body:  Stack(
          children: [
            SvgPicture.asset('assets/svg_images/city.svg', width: MediaQuery.of(context).size.width,),
            (!currentUser.isLoggedIn) ? Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 50, right: 20),
                child: GestureDetector(
                  child: Container(
                    width: 125,
                    height: 41,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFF09B44D)
                    ),
                    child: Center(
                      child: Text('Войти',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),
                  onTap: (){
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context)=> AuthGetBloc(),
                          child: AuthScreen(),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ) : Container(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 190,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    )
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20, left: 20),
                        child: Text('Укажите город доставки',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                      child: GestureDetector(
                        child: TextField(
                          controller: cityController,
                          decoration: InputDecoration(
                              enabled: false,
                              contentPadding: EdgeInsets.only(left: 2),
                              hintText: 'Введите город',
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey
                              )
                          ),
                        ),
                        onTap: (){
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => AddCityScreen()),
                                  (Route<dynamic> route) => false);
                        },
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom:  20, right: 20, left: 20),
                          child: GestureDetector(
                            child: Container(
                              height: 40,
                              width: 335,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: (cityController.text.length == 0) ? Color(0xFFF6F6F6) : Color(0xFF09B44D)
                              ),
                              child: Center(
                                child: Text('Далее',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18
                                  ),
                                ),
                              ),
                            ),
                            onTap: (){
                              if(cityController.text.length == 0){
                                showAlertDialog(context);
                              }
                              homeScreenKey = new GlobalKey<HomeScreenState>();
                              Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => BlocProvider(
                                        create: (context) => RestaurantGetBloc(),
                                        child: new HomeScreen(),
                                      )));
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        )
    );
  }
}