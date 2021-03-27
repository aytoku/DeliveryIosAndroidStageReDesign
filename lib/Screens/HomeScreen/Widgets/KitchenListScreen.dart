import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/HomeScreen/Bloc/restaurant_get_event.dart';
import 'package:flutter_app/Screens/HomeScreen/Model/AllStoreCategories.dart';
import 'package:flutter_app/Screens/HomeScreen/Widgets/Filter.dart';
import 'package:flutter_app/data/global_variables.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../data/data.dart';

class KitchenListScreen extends StatefulWidget {

  List<AllStoreCategories> categories;
  FilterState parent;
  KitchenListScreen(this.categories, this.parent, {Key key}) : super(key: key);

  @override
  KitchenListScreenState createState() {
    return new KitchenListScreenState(categories, parent);
  }
}

class KitchenListScreenState extends State<KitchenListScreen>{
  KitchenListScreenState(this.categories, this.parent);
  FilterState parent;
  List<AllStoreCategories> categories;
  bool hasChanges;

  // получаем категории с сервака
  Widget getCategories(){
    return Container(
      padding: EdgeInsets.only(bottom: 0, left: 8, right: 8, top: 0),
      height: 490,
      child: ListView(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 15),
              child: Text(
                'Кухни',
                style: TextStyle(
                    color: AppColor.textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: List.generate(categories.length,(index){
                return InkWell(
                  child: Padding(
                      padding: const EdgeInsets.only(top: 10.0, left: 8, right: 5, bottom: 10),
                      child: Container(
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 9.0, right: 10),
                              child: (!parent.selectedKitchens[index]) ? SvgPicture.asset('assets/svg_images/kitchen_unselected.svg') : SvgPicture.asset('assets/svg_images/kitchen_selected.svg'),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                categories[index].name,
                                style:
                                    TextStyle(color: AppColor.textColor, fontSize: 18),
                              ),
                            )
                          ],
                        ),
                      )
                  ),
                  onTap: (){
                    setState(() {
                      hasChanges = true;
                      parent.selectedKitchens[index] = !parent.selectedKitchens[index];
                    });
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    parent.selectedKitchens = List.generate(categories.length, (index) => AllStoreCategoriesData.selectedStoreCategories.contains(categories[index]));
    hasChanges = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        getCategories(),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: FlatButton(
                child: Text('Применить',
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white)),
                color: (hasSelectedItems()) ? AppColor.mainColor : AppColor.elementsColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.only(left: 120, top: 20, right: 120, bottom: 20),
                onPressed: () async {
                  parent.selectedCategoryFromHomeScreen = false;
                  List<AllStoreCategories> selectedCats = List<AllStoreCategories>();
                  for(int i = 0; i<parent.selectedKitchens.length; i++){
                    if(parent.selectedKitchens[i])
                      selectedCats.add(categories[i]);
                  }
                  parent.parent.restaurantGetBloc.add(CategoryFilterApplied(selectedCategoryFromHomeScreen: parent.selectedCategoryFromHomeScreen, categories: selectedCats));
                  Navigator.pop(context);
                  //parent.setState(() {});
                },
              ),
            ),
          ),
        )
      ],
    );
  }

  bool hasSelectedItems(){
    try{
      // var selectedItem = parent.selectedKitchens.firstWhere((element) => element);
      return hasChanges;
    }catch(e){
      return false;
    }
  }
}