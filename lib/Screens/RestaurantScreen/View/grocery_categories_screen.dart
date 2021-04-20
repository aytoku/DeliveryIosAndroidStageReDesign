import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../data/data.dart';
import '../../../data/globalVariables.dart';
import '../../HomeScreen/Model/FilteredStores.dart';
import '../API/get_filtered_product_categories.dart';
import '../Model/FilteredProductCategories.dart';
import 'restaurant_screen.dart';

class GroceryCategoriesScreen extends StatefulWidget {

  FilteredProductCategories parentCategory;
  FilteredStores restaurant;
  GroceryCategoriesScreen({Key key, this.parentCategory, this.restaurant}) : super(key: key);

  @override
  GroceryCategoriesScreenState createState() {
    return new GroceryCategoriesScreenState(parentCategory, restaurant);
  }
}

class GroceryCategoriesScreenState extends State<GroceryCategoriesScreen>{

  FilteredProductCategories parentCategory;
  FilteredStores restaurant;
  FilteredProductCategoriesData filteredProductCategoriesData;
  GroceryCategoriesScreenState(this.parentCategory, this.restaurant);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<FilteredProductCategoriesData>(
        future: getFilteredProductCategories(
            restaurant.uuid,
            parentCategory.uuid,
            necessaryDataForAuth.city.uuid),
        builder: (BuildContext context,
            AsyncSnapshot<FilteredProductCategoriesData> snapshot){
          if(snapshot.connectionState ==
              ConnectionState.done){
            if(snapshot.data.filteredProductCategories.isEmpty){
              selectedCategoriesUuid = parentCategory;
              return RestaurantScreen(restaurant: restaurant);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) {
                  return RestaurantScreen(restaurant: restaurant);
                }),
              );
            }

            filteredProductCategoriesData = snapshot.data;
            return  Container(
              child: Column(
                children: [
                  // Align(
                  //   alignment: Alignment.topLeft,
                  //   child: InkWell(
                  //     hoverColor: AppColor.themeColor,
                  //     focusColor: AppColor.themeColor,
                  //     splashColor: AppColor.themeColor,
                  //     highlightColor: AppColor.themeColor,
                  //     onTap: () {
                  //       Navigator.pop(context);
                  //     },
                  //     child: Padding(
                  //       padding: EdgeInsets.only( top: 40),
                  //       child: Container(
                  //           height: 40,
                  //           width: 60,
                  //           child: Padding(
                  //             padding: EdgeInsets.only(
                  //                 top: 12, bottom: 12, right: 10),
                  //             child: SvgPicture.asset(
                  //                 'assets/svg_images/arrow_left.svg'),
                  //           )),),
                  //   ),
                  // ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        children: [
                          // Align(
                          //     alignment: Alignment.topLeft,
                          //     child: Padding(
                          //       padding: const EdgeInsets.only(top: 10, bottom: 10),
                          //       child: Text(parentCategory.name,
                          //         style: TextStyle(
                          //             fontSize: 24
                          //         ),
                          //       ),
                          //     )
                          // ),
                          Expanded(
                            child: ListView(
                              padding: EdgeInsets.zero,
                              children: List.generate(filteredProductCategoriesData.filteredProductCategories.length, (index){
                                return InkWell(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15, right: 15),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                                height: 70,
                                                width: 50,
                                                padding: EdgeInsets.only(top: 8, bottom: 8),
                                                child: Image.network(
                                                  (filteredProductCategoriesData.filteredProductCategories[index].meta.images != null)?
                                                  filteredProductCategoriesData.filteredProductCategories[index].meta.images[0]:
                                                  '',
                                                  fit: BoxFit.cover,
                                                )
                                            ),
                                            Container(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(15),
                                                  child: Text(filteredProductCategoriesData.filteredProductCategories[index].name),
                                                )
                                            ),
                                          ],
                                        ),
                                        Container(
                                            padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                                            decoration: BoxDecoration(
                                                color: Color(0xFFEEEEEE),
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                            child: Text(
                                              filteredProductCategoriesData.filteredProductCategories[index].count.toString(),
                                              style: TextStyle(
                                                  color: Color(0xFF4D9D46)
                                              ),
                                            ))
                                      ],
                                    ),
                                  ),
                                  onTap: () async{
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context)=> GroceryCategoriesScreen(
                                            restaurant: restaurant,
                                            parentCategory: filteredProductCategoriesData.filteredProductCategories[index]
                                        ))
                                    );
                                  },
                                );
                              }),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          }else{
            return Center(
              child: SpinKitFadingCircle(
                color: AppColor.mainColor,
                size: 50.0,
              ),
            );
          }
        },
      ),
    );
  }
}