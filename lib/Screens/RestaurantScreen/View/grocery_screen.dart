import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/HomeScreen/Bloc/restaurant_get_bloc.dart';
import 'package:flutter_app/Screens/HomeScreen/Model/FilteredStores.dart';
import 'package:flutter_app/Screens/HomeScreen/View/home_screen.dart';
import 'package:flutter_app/Screens/RestaurantScreen/View/restaurant_screen.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/ProductCategories/CategoryList.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/grocery_item.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/data/global_variables.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GroceryScreen extends StatefulWidget {
  GroceryScreen({
    this.key
  }) : super(key: key);
  final GlobalKey<GroceryScreenState> key;
  FilteredStores restaurant;

  @override
  GroceryScreenState createState() {
    return new GroceryScreenState(restaurant);
  }
}

class GroceryScreenState extends State<GroceryScreen>{

  FilteredStores restaurant;
  CategoryList categoryList;
  GroceryScreenState(restaurant);

  _buildFoodCategoryList() {
    if(restaurant.productCategoriesUuid.length>0)
      return categoryList;
    else
      return Container(height: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15, top: 60),
            child: Align(
              alignment: Alignment.topLeft,
                child: InkWell(
                    child: SvgPicture.asset('assets/svg_images/arrow_left.svg'),
                  onTap: (){
                    homeScreenKey = new GlobalKey<HomeScreenState>();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) => RestaurantGetBloc(),
                              child: new HomeScreen(),
                            )),
                            (Route<dynamic> route) => false);
                  },
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25.0, bottom: 20),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    'Наш',
                    style: TextStyle(
                        fontSize: 21,
                        color: Color(0xFF3F3F3F)),
                  ),
                ),
                InkWell(
                  hoverColor: Colors.white,
                  focusColor: Colors.white,
                  splashColor: Colors.white,
                  highlightColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 3.0),
                    child: SvgPicture.asset(
                        'assets/svg_images/rest_info.svg'),
                  ),
                  onTap: (){

                  },
                ),
              ],
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Container(
                  height: 26,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFFEFEFEF)
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 5, bottom: 5, right: 10, left: 10),
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/svg_images/star.svg',
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text('4,7',
                              style: TextStyle(
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Container(
                  height: 26,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFFEFEFEF)
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(left:10, right: 10, top: 5, bottom: 5),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: SvgPicture.asset('assets/svg_images/rest_car.svg',
                            ),
                          ),
                          Text(
                            '~' +  '10 мин',
                            style: TextStyle(
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 15),
                child: Container(
                  height: 26,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFFEFEFEF)
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(left:10, right: 10, top: 5, bottom: 5),
                      child: Text('150 руб',
                        style: TextStyle(
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 25, left: 15),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text('Категории',
                style: TextStyle(
                  fontSize: 24
                ),
              ),
            )
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: 2,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/svg_images/pizza.svg'),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text('Фрукты',
                              style: TextStyle(
                                fontSize: 14
                              ),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                height: 27,
                                width: 56,
                                decoration: BoxDecoration(
                                  color: Color(0xFFEEEEEE),
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                child: Center(
                                  child: Text(
                                    '2',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF4D9D46)
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) {
                        return RestaurantScreen(restaurant: restaurant);
                      }),
                    );
                  },
                );
              },
            )
          )
        ],
      ),
    );
  }
}