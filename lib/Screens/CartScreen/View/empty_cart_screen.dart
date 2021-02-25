import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/CartScreen/View/cart_page_view.dart';
import 'package:flutter_app/Screens/HomeScreen/Bloc/restaurant_get_bloc.dart';
import 'package:flutter_app/Screens/RestaurantScreen/View/restaurant_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../data/data.dart';
import '../../HomeScreen/Model/FilteredStores.dart';
import '../../HomeScreen/View/home_screen.dart';

class EmptyCartScreen extends StatefulWidget {
  final FilteredStores restaurant;
  CartSources source;

  EmptyCartScreen({Key key, this.restaurant, this.source}) : super(key: key);

  @override
  EmptyCartScreenState createState() {
    return new EmptyCartScreenState(restaurant, source);
  }
}

class EmptyCartScreenState extends State<EmptyCartScreen> {
  final FilteredStores restaurant;
  CartSources source;

  EmptyCartScreenState(this.restaurant, this.source);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: InkWell(
                          onTap: () {
                            if(source == CartSources.Home){
                              homeScreenKey = new GlobalKey<HomeScreenState>();
                              Navigator.pushReplacement(context,
                                  new MaterialPageRoute(
                                      builder: (context) => BlocProvider(
                                        create: (context) => RestaurantGetBloc(),
                                        child: new HomeScreen(),
                                      )
                                  )
                              );
                            }else if(source == CartSources.Restaurant){
                              Navigator.pushReplacement(context,
                                  new MaterialPageRoute(builder:
                                      (context)=>RestaurantScreen(restaurant: restaurant)
                                  )
                              );
                            }
                          },
                          child: Padding(
                              padding: EdgeInsets.only(right: 0),
                              child: Container(
                                  width: 40,
                                  height: 60,
                                  child: Center(
                                    child: SvgPicture.asset(
                                        'assets/svg_images/arrow_left.svg'),
                                  ))),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 0),
                        child: Text(
                          'Корзина',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF000000)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: SvgPicture.asset(
                            'assets/svg_images/del_basket.svg'),),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(top: 90),
                  child: Container(
                    decoration: BoxDecoration(color: Color(0xFFFAFAFA)),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: Center(
                            child: SvgPicture.asset(
                                'assets/svg_images/basket.svg'),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Center(
                              child: Text(
                                'Корзина пуста',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: Color(0xFF424242)),
                              )),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 100),
                          child: Center(
                            child: Text(
                              'Перейдите в список мест, чтобы\nоформить заказ заново',
                              style:
                              TextStyle(color: Color(0xFFB0B0B0), fontSize: 15),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Padding(
                    padding:
                    EdgeInsets.only(bottom: 15, left: 15, right: 15, top: 15),
                    child: FlatButton(
                      child: Text(
                        'Вернуться на главную',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      color: Color(0xFF09B44D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.only(
                          left: 80, top: 20, right: 80, bottom: 20),
                      onPressed: () {
                        homeScreenKey = new GlobalKey<HomeScreenState>();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => RestaurantGetBloc(),
                                  child: new HomeScreen(),
                                )),
                                (Route<dynamic> route) => false);
                      },
                    ),
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }
}