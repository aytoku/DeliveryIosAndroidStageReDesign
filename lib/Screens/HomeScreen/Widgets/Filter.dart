import 'package:flutter/material.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/Screens/HomeScreen/API/getAllStoreCategories.dart';
import 'package:flutter_app/Screens/HomeScreen/Bloc/restaurant_get_event.dart';
import 'package:flutter_app/Screens/HomeScreen/Model/AllStoreCategories.dart';
import 'package:flutter_app/Screens/HomeScreen/View/home_screen.dart';
import 'package:flutter_app/Screens/HomeScreen/Widgets/DistancePriority.dart';
import 'package:flutter_app/Screens/HomeScreen/Widgets/KitchenListScreen.dart';
import 'package:flutter_app/Screens/HomeScreen/Widgets/Priority.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Список с фильтрами

class Filter extends StatefulWidget {
  HomeScreenState parent;
  GlobalKey<FilterState> key;

  Filter(this.parent, {this.key}) : super(key: key);

  @override
  FilterState createState() {
    return new FilterState(parent);
  }
}

class FilterState extends State<Filter> with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin{
  FilterState(this.parent);

  HomeScreenState parent;
  KitchenListScreen kitchenListScreen;
  bool selectedCategoryFromHomeScreen;// Выбранные категории
  List<bool> selectedKitchens; // Квадратики с галочками
  List<AllStoreCategories> restaurantCategories; // Фулл список категорий
  ScrollController catScrollController;
  GlobalKey<KitchenListScreenState> kitchenListKey;


  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    selectedCategoryFromHomeScreen = false;
    kitchenListKey = new GlobalKey();
  }

  @override
  void dispose(){
    super.dispose();
  }

  // Фильтр по предпочтениям

  _priorityFilter() {
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
            height: 430,
            child: _buildPriorityFilterNavigationMenu(),
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                )),
          );
        });
  }

  _buildPriorityFilterNavigationMenu() {
    return Container(
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 15, left: 20, bottom: 15),
              child: Text(
                'Отобразить сначала',
                style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
          PriorityScreen(),
        ],
      ),
    );
  }


  // Фильтр по кухням

  _kitchensFilter(List<AllStoreCategories> categories) {
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
            height: 600,
            child: _buildKitchensFilterNavigationMenu(categories),
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                )),
          );
        });
  }

  _buildKitchensFilterNavigationMenu(List<AllStoreCategories> categories) {
    return Container(
      height: 610,
      padding: EdgeInsets.only(top: 25),
      child: kitchenListScreen,
    );
    return Container(
      height: 610,
      child: Column(
        children: [
          // Expanded(
          //   child: Align(
          //     alignment: Alignment.topLeft,
          //     child: Padding(
          //       padding: const EdgeInsets.only(top: 15.0, left: 15),
          //       child: Text(
          //         'Кухни',
          //         style: TextStyle(
          //             color: Color(0xFF000000),
          //             fontSize: 20,
          //             fontWeight: FontWeight.bold
          //         ),
          //       ),
          //     ),
          //   ),
          // ),


        ],
      ),
    );
  }


  // Фильтр по расстоянию
  _distanceFilter() {
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
            height: 400,
            child: _buildDistanceFilterNavigationMenu(),
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                )),
          );
        });
  }

  _buildDistanceFilterNavigationMenu() {
    return Container(
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 20),
              child: Text(
                'Показывать с отдаленностью',
                style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
          DistancePriorityScreen()
        ],
      ),
    );
  }


  // Фильтр по категориям(те же самые что и в фильтре по кухням)
  List<Widget> _buildRestaurantCategoriesList(List<AllStoreCategories> categories){
    List<Widget> result = new List<Widget>();
    result.add(Row(
      children: [
        // GestureDetector(
        //   child: Padding(
        //     padding: const EdgeInsets.only(left: 20),
        //     child: Container(
        //       height: 45,
        //       decoration: BoxDecoration(
        //           color: Color(0xFFF6F6F6),
        //           borderRadius: BorderRadius.circular(10)
        //       ),
        //       child: Padding(
        //         padding: const EdgeInsets.all(5.0),
        //         child: SvgPicture.asset('assets/svg_images/union.svg'),
        //       ),
        //     ),
        //   ),
        //   onTap: () async {
        //     if (await Internet.checkConnection()) {
        //       _priorityFilter();
        //     } else {
        //       noConnection(context);
        //     }
        //   },
        // ),
        //
        // GestureDetector(
        //   child: Padding(
        //       padding:
        //       EdgeInsets.only(left: 10, right: 5),
        //       child: Container(
        //         height: 45,
        //         decoration: BoxDecoration(
        //             borderRadius: BorderRadius.all(Radius.circular(10)),
        //             color: Color(0xFFF6F6F6)),
        //         child: Padding(
        //             padding: EdgeInsets.only(left: 15, right: 15),
        //             child: Center(
        //               child: Row(
        //                 children: [
        //                   Text(
        //                     "По расстоянию",
        //                     style: TextStyle(
        //                         color: Color(0xFF424242),
        //                         fontSize: 15),
        //                   ),
        //                   Padding(
        //                     padding: const EdgeInsets.only(left: 8.0),
        //                     child: SvgPicture.asset('assets/svg_images/arrow_down'),
        //                   )
        //                 ],
        //               ),
        //             )),
        //       )),
        //   onTap: () async {
        //     if (await Internet.checkConnection()) {
        //       _distanceFilter();
        //     } else {
        //       noConnection(context);
        //     }
        //   },
        // ),
        Container(
          height: 60,
          child: Stack(
            children: [
              GestureDetector(
                child: Padding(
                    padding:
                    EdgeInsets.only(left: 20, right: 5,),
                    child: Center(
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: (!selectedCategoryFromHomeScreen && AllStoreCategoriesData.selectedStoreCategories.length > 0)
                                ? AppColor.mainColor : AppColor.subElementsColor),
                        child: Padding(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Кухни",
                                    style: TextStyle(
                                        color: (!selectedCategoryFromHomeScreen
                                            && AllStoreCategoriesData.selectedStoreCategories.length > 0)
                                              ? AppColor.unselectedTextColor: AppColor.unselectedTextColor,
                                        fontSize: 15),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: SvgPicture.asset('assets/svg_images/arrow_down',
                                      color: (!selectedCategoryFromHomeScreen
                                                && AllStoreCategoriesData.selectedStoreCategories.length > 0)
                                                 ? AppColor.textColor: AppColor.textColor,
                                    ),
                                  )
                                ],
                              ),
                            )
                        ),
                      ),
                    ),
                ),
                onTap: () async {
                  if (await Internet.checkConnection()) {
                    _kitchensFilter(categories);
                  } else {
                    noConnection(context);
                  }
                },
              ),
              (AllStoreCategoriesData.selectedStoreCategories.length != 0 && !selectedCategoryFromHomeScreen)
                  ? Padding(
                padding: const EdgeInsets.only(left: 95, bottom: 23),
                child: Container(
                    width: 23,
                    height: 23,
                    padding: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColor.themeColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 2.0, // soften the shadow
                            spreadRadius: 1.0, //extend the shadow
                          )
                        ],
                    ),
                    child: Center(
                      child: Text('${AllStoreCategoriesData.selectedStoreCategories.length}',
                        style: TextStyle(
                            fontSize: 14
                        ),
                      ),
                    )
                ),
              ): Container()
            ],
          ),
        ),
      ],
    ));
    categories.forEach((element) {
      result.add(Container(
        height: 60,
        child: Container(
          height: 45,
          child: GestureDetector(
            child: Padding(
                padding:
                EdgeInsets.only(
                  left: 5,
                  right: 5,
                top: 7,
                  bottom:7
                ),
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: (!AllStoreCategoriesData.selectedStoreCategories.contains(element)
                          || !selectedCategoryFromHomeScreen)
                          ? AppColor.elementsColor
                          : AppColor.mainColor),
                  child: Padding(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Center(
                        child: Text(
                          element.name[0].toUpperCase() + element.name.substring(1),
                          style: TextStyle(
                              color: (!AllStoreCategoriesData.selectedStoreCategories.contains(element)|| !selectedCategoryFromHomeScreen)
                                  ? AppColor.unselectedTextColor
                                  : AppColor.unselectedTextColor,
                              fontSize: 15),
                        ),
                      )),
                )),
            onTap: () async {
              if (await Internet.checkConnection()) {
                selectedCategoryFromHomeScreen = true;
                parent.restaurantGetBloc.add(CategoryFilterApplied(category: element, selectedCategoryFromHomeScreen: selectedCategoryFromHomeScreen));
              } else {
                noConnection(context);
              }
            },
          ),
        ),
      ));
    });
    return result;
  }



  // список категорий
  Future<Widget> _buildRestaurantCategories() async{
    restaurantCategories = (await getAllStoreCategories(selectedCity.uuid)).allStoreCategoriesList;
    kitchenListScreen = KitchenListScreen(restaurantCategories, this,key: kitchenListKey);
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Container(
        height: 60,
        child: ListView(
            controller: catScrollController,
            scrollDirection: Axis.horizontal,
            children: _buildRestaurantCategoriesList(restaurantCategories)
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    if(restaurantCategories != null)
      return Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Container(
          height: 60,
          child: ListView(
              controller: catScrollController,
              scrollDirection: Axis.horizontal,
              children: _buildRestaurantCategoriesList(restaurantCategories)
          ),
        ),
      );
    return Container(
      child: FutureBuilder<Widget>(
        future: _buildRestaurantCategories(),
        builder: (BuildContext context,
            AsyncSnapshot<Widget> snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            return snapshot.data;
          }
          return Container(width: 0.0, height: 60,);
        },
      ),
    );
  }
}