import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/HomeScreen/Model/AllStoreCategories.dart';
import 'package:flutter_app/Screens/HomeScreen/Widgets/Filter.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

  // получаем категории с сервака
  Widget getCategories(){
    return Container(
      padding: EdgeInsets.only(bottom: 0, left: 8, right: 8, top: 0),
      height: 490,
      child: ListView(
        padding: EdgeInsets.zero,
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
                        child: Text(categories[index].name,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18
                          ),
                        ),
                      )
                    ],
                  ),
                )
            ),
            onTap: (){
              setState(() {
                parent.selectedKitchens[index] = !parent.selectedKitchens[index];
              });
            },
          );
        }),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    parent.selectedKitchens = List.generate(categories.length, (index) => parent.categoryUuid.contains(categories[index].uuid));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        getCategories(),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: FlatButton(
              child: Text('Применить',
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white)),
              color: (haveSelectedItems()) ? Color(0xFF09B44D) : Color(0xF3F3F3F3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.only(left: 120, top: 20, right: 120, bottom: 20),
              onPressed: () async {
                parent.categoryUuid.clear();
                for(int i = 0; i<parent.selectedKitchens.length; i++){
                  if(parent.selectedKitchens[i])
                    parent.categoryUuid.add(categories[i].uuid);
                }
                parent.selectedCategoryFromHomeScreen = false;
                parent.applyFilters();
                Navigator.pop(context);
                parent.setState(() {});
              },
            ),
          ),
        )
      ],
    );
  }

  bool haveSelectedItems(){
    try{
      var selectedItem = parent.selectedKitchens.firstWhere((element) => element);
      return true;
    }catch(e){
      return false;
    }
  }
}