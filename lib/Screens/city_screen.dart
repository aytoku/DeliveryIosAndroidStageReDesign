import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/add_city_screen.dart';
import 'package:flutter_app/Screens/auth_screen.dart';
import 'package:flutter_app/Screens/device_id_screen.dart';
import 'package:flutter_app/Screens/home_screen.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CityScreen extends StatefulWidget {

  CityScreen({Key key}) : super(key: key);

  @override
  CityScreenState createState() {
    return new CityScreenState();
  }
}

class CityScreenState extends State<CityScreen>{

  TextEditingController cityController = new TextEditingController();
  CityScreenState();

  @override
  Widget build(BuildContext context) {
    if(selectedCity != null){
      cityController.text = selectedCity.name;
    }
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/city_image.png"), fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            Expanded(
              child: Align(
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
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => AuthScreen()),
                              (Route<dynamic> route) => false);
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 276,
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
                                  color: Color(0xFF09B44D)
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
                                homeScreenKey = new GlobalKey<HomeScreenState>();
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()),
                                        (Route<dynamic> route) => false);
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}