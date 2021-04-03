import 'package:flutter/material.dart';
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
  FilteredProductCategoriesData filteredProductCategoriesData;
  GroceryCategoriesScreen({Key key, this.parentCategory, this.restaurant, this.filteredProductCategoriesData}) : super(key: key);

  @override
  GroceryCategoriesScreenState createState() {
    return new GroceryCategoriesScreenState(parentCategory, restaurant, filteredProductCategoriesData);
  }
}

class GroceryCategoriesScreenState extends State<GroceryCategoriesScreen>{

  FilteredProductCategories parentCategory;
  FilteredStores restaurant;
  FilteredProductCategoriesData filteredProductCategoriesData;
  GroceryCategoriesScreenState(this.parentCategory, this.restaurant, this.filteredProductCategoriesData);


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
                  Navigator.pop(context);
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Text(parentCategory.name,
                            style: TextStyle(
                                fontSize: 24
                            ),
                          ),
                        )
                    ),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: List.generate(filteredProductCategoriesData.filteredProductCategories.length, (index){
                          return InkWell(
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                                  child: Text(filteredProductCategoriesData.filteredProductCategories[index].name),
                                )
                            ),
                            onTap: () async{
                              var categoriesFilter = await getFilteredProductCategories(
                                  restaurant.uuid,
                                  filteredProductCategoriesData.filteredProductCategories[index].uuid,
                                  necessaryDataForAuth.city.uuid);
                              if(categoriesFilter.filteredProductCategories.isEmpty){
                                selectedCategoriesUuid = filteredProductCategoriesData.filteredProductCategories[index].uuid;
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
                                        parentCategory: filteredProductCategoriesData.filteredProductCategories[index],
                                        filteredProductCategoriesData: categoriesFilter
                                    ))
                                );
                              }
                            },
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}