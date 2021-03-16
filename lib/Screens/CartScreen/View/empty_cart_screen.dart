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
          color: AppColor.themeColor,
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: 30, bottom: 10),
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
                                        'assets/svg_images/arrow_left.svg', color: AppColor.textColor,),
                                  ))),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 0, right: 40.0),
                        child: Text(
                          'Корзина',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColor.textColor),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: SvgPicture.asset(
                            ''),),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(top: 90),
                  child: Container(
                    decoration: BoxDecoration(color: AppColor.themeColor),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: Center(
                            child: SvgPicture.asset(
                                'assets/svg_images/empty_basket.svg'),
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
                                    color: AppColor.textColor),
                              )),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 100),
                          child: Center(
                            child: Text(
                              'Перейдите в список мест, чтобы\nоформить заказ заново',
                              style:
                              TextStyle(color: AppColor.additionalTextColor, fontSize: 15),
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
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Container(
                    height: 52,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: AppColor.mainColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding:
                      EdgeInsets.only(bottom: 15, left: 15, right: 15, top: 15),
                      child: GestureDetector(
                        child: Center(
                          child: Text(
                            'Вернуться на главную',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white)
                          ),
                        ),
                        onTap: () {
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
              ),
            ],
          )
      ),
    );
  }
}