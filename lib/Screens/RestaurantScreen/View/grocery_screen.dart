import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/HomeScreen/Bloc/restaurant_get_bloc.dart';
import 'package:flutter_app/Screens/HomeScreen/Model/FilteredStores.dart';
import 'package:flutter_app/Screens/HomeScreen/View/home_screen.dart';
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

  _buildFoodCategoryList() {
    if(restaurant.productCategoriesUuid.length>0)
      return categoryList;
    else
      return Container(height: 0);
  }

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
                padding: EdgeInsets.only( top: 40),
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
          Expanded(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: restaurant.productCategoriesUuid.length,
              itemBuilder: (context, index) {
                var productCategory = restaurant.productCategoriesUuid[index];
                return InkWell(
                  hoverColor: AppColor.themeColor,
                  focusColor: AppColor.themeColor,
                  splashColor: AppColor.themeColor,
                  highlightColor: AppColor.themeColor,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
                      child: Row(
                        children: [
                          Image.network(productCategory.url),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text(productCategory.name,
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
                                    '228',
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
                    selectedCategoriesUuid = productCategory;
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
                padding: EdgeInsets.only( top: 40),
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
                return Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: ListView(
                    children: List.generate(snapshot.data.filteredProductCategories.length, (index){
                      return InkWell(
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Text(snapshot.data.filteredProductCategories[index].name)
                        ),
                        onTap: (){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context)=> ChildCategoriesScreen(
                                restaurant: restaurant,
                                parentCategory: snapshot.data.filteredProductCategories[index],
                              ))
                          );
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


class ChildCategoriesScreen extends StatefulWidget {

  FilteredProductCategories parentCategory;
  FilteredStores restaurant;
  ChildCategoriesScreen({Key key, this.parentCategory, this.restaurant}) : super(key: key);

  @override
  ChildCategoriesScreenState createState() {
    return new ChildCategoriesScreenState(parentCategory, restaurant);
  }
}

class ChildCategoriesScreenState extends State<ChildCategoriesScreen>{

  FilteredProductCategories parentCategory;
  FilteredStores restaurant;
  ChildCategoriesScreenState(this.parentCategory, this.restaurant);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        child: Column(
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
                  padding: EdgeInsets.only( top: 40),
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
            FutureBuilder<FilteredProductCategoriesData>(
              future: getFilteredProductCategories(
                  restaurant.uuid,
                  parentCategory.uuid,
                  necessaryDataForAuth.city.uuid),
              builder: (BuildContext context,
                  AsyncSnapshot<FilteredProductCategoriesData> snapshot){
                if(snapshot.connectionState ==
                    ConnectionState.done &&
                    snapshot.data.filteredProductCategories.length > 0){
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Column(
                      children: [
                        Text(parentCategory.name),
                        Expanded(
                          child: ListView(
                            children: List.generate(snapshot.data.filteredProductCategories.length, (index){
                              return InkWell(
                                child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Text(snapshot.data.filteredProductCategories[index].name)
                                ),
                                onTap: (){
                                  setState(() {

                                  });
                                },
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  );
                }else{
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}