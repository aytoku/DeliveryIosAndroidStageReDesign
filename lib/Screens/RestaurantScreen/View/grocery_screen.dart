import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/HomeScreen/Bloc/restaurant_get_bloc.dart';
import 'package:flutter_app/Screens/HomeScreen/Model/FilteredStores.dart';
import 'package:flutter_app/Screens/HomeScreen/View/home_screen.dart';
import 'package:flutter_app/Screens/RestaurantScreen/View/grocery_categories_screen.dart';
import 'package:flutter_app/Screens/RestaurantScreen/View/restaurant_screen.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/ProductCategories/CategoryList.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Model/FilteredProductCategories.dart';
import 'package:flutter_app/Screens/RestaurantScreen/API/get_filtered_product_categories.dart';

class GroceryScreen extends StatefulWidget {
  GroceryScreen({
    this.key,
    this.restaurant
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
  String parentUuid;
  GroceryScreenState(this.restaurant);

  _restInfo() {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20),
            )),
        context: context,
        builder: (context) {
          return Container(
            height: 300,
            child: _buildRestInfoNavigationMenu(),
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                )),
          );
        });
  }

  _buildRestInfoNavigationMenu() {
//    DateTime now = DateTime.now();
//    int currentTime = now.hour*60+now.minute;
//    int dayNumber  = now.weekday-1;
//    int work_ending = restaurant.work_schedule[dayNumber].work_ending;
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, top: 30),
            child: Align(
                alignment: Alignment.topLeft,
                child: Text(restaurant.name,
                  style: TextStyle(
                      color: Color(0xFF424242),
                      fontSize: 21,
                      fontWeight: FontWeight.bold
                  ),
                )
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, top: 20),
            child: Align(
                alignment: Alignment.topLeft,
                child: Text('Адрес',
                  style: TextStyle(
                      color: AppColor.additionalTextColor,
                      fontSize: 14
                  ),
                )
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, top: 10),
            child: Align(
                alignment: Alignment.topLeft,
                child: Text(restaurant.address.unrestrictedValue,
                  style: TextStyle(
                      fontSize: 14
                  ),
                )
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, top: 20),
            child: Align(
                alignment: Alignment.topLeft,
                child: Text("Время доставки",
                  style: TextStyle(
                      color: AppColor.additionalTextColor,
                      fontSize: 14
                  ),
                )
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, top: 10),
            child: Align(
                alignment: Alignment.topLeft,
                child: Text('${restaurant.meta.avgDeliveryTime}',
                  style: TextStyle(
                      fontSize: 14
                  ),
                )
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, top: 20),
            child: Align(
                alignment: Alignment.topLeft,
                child: Text('Кухни',
                  style: TextStyle(
                      color: AppColor.additionalTextColor,
                      fontSize: 14
                  ),
                )
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, top: 10),
            child: Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: List.generate(restaurant.storeCategoriesUuid.length, (index){
                    return Text(restaurant.storeCategoriesUuid[index].name + ' ');
                  }),
                )
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColor.themeColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: InkWell(
              hoverColor: AppColor.themeColor,
              focusColor: AppColor.themeColor,
              splashColor: AppColor.themeColor,
              highlightColor: AppColor.themeColor,
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
              child: Padding(
                padding: EdgeInsets.only(top: 40),
                child: Container(
                    height: 40,
                    width: 60,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 12, bottom: 12, right: 10),
                      child: SvgPicture.asset(
                          'assets/svg_images/arrow_left.svg'),
                    )),),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24.0, bottom: 17),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    this.restaurant.name,
                    style: TextStyle(
                        fontSize: 24,
                        color: Color(0xFF3F3F3F)),
                  ),
                ),
                InkWell(
                  hoverColor: AppColor.themeColor,
                  focusColor: Colors.white,
                  splashColor: Colors.white,
                  highlightColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 3.0),
                    child: SvgPicture.asset(
                        'assets/svg_images/rest_info.svg'),
                  ),
                  onTap: (){
                    _restInfo();
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
                            child: Text(restaurant.meta.rating.toString(),
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
                            '~' +  '${restaurant.meta.avgDeliveryTime}',
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
                      child: Text('${restaurant.meta.avgDeliveryPrice}',
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
              padding: EdgeInsets.only(top: 30, left: 15),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text('Категории',
                  style: TextStyle(
                      fontSize: 24
                  ),
                ),
              )
          ),
          FutureBuilder<FilteredProductCategoriesData>(
            future: getFilteredProductCategories(
                restaurant.uuid,
                parentUuid,
                necessaryDataForAuth.city.uuid),
            builder: (BuildContext context,
                AsyncSnapshot<FilteredProductCategoriesData> snapshot){
              if(snapshot.connectionState ==
                  ConnectionState.done &&
                  snapshot.data.filteredProductCategories.length > 0){
                return Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: List.generate(snapshot.data.filteredProductCategories.length, (index){
                      return InkWell(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  height: 70,
                                  width: 50,
                                  padding: EdgeInsets.only(top: 8, bottom: 8),
                                  child: Image.network(
                                    snapshot.data.filteredProductCategories[index].meta.images[0],
                                    fit: BoxFit.cover,
                                  )
                              ),
                              Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Text(snapshot.data.filteredProductCategories[index].name),
                                  )
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                                decoration: BoxDecoration(
                                  color: Color(0xFFEEEEEE),
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                  child: Text(
                                      snapshot.data.filteredProductCategories[index].count.toString(),
                                    style: TextStyle(
                                      color: Color(0xFF4D9D46)
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        onTap: () async{
                         var categoriesFilter = await getFilteredProductCategories(
                              restaurant.uuid,
                             snapshot.data.filteredProductCategories[index].uuid,
                              necessaryDataForAuth.city.uuid);
                         if(categoriesFilter.filteredProductCategories.isEmpty){
                           selectedCategoriesUuid = snapshot.data.filteredProductCategories[index];
                           Navigator.push(
                             context,
                             MaterialPageRoute(builder: (_) {
                               return RestaurantScreen(restaurant: restaurant);
                             }),
                           );
                         }else{
                           Navigator.push(context,
                               MaterialPageRoute(builder: (context)=> GroceryCategoriesScreen(
                                   restaurant: restaurant,
                                   parentCategory: snapshot.data.filteredProductCategories[index],
                                   filteredProductCategoriesData: categoriesFilter
                               ))
                           );
                         }
                        },
                      );
                    }),
                  ),
                );
              }else{
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }
}