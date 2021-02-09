import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Model/ProductDataModel.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VariantsSelector extends StatefulWidget {
  VariantGroup variantGroup;
  GlobalKey<VariantsSelectorState> key;


  VariantsSelector({this.key, this.variantGroup}) : super(key: key);

  @override
  VariantsSelectorState createState() => VariantsSelectorState(variantGroup);
}

class VariantsSelectorState extends State<VariantsSelector> {
  VariantGroup variantGroup;
  List<Variant> selectedVariants;
  List<Variant> variantsList;
  bool required;
  String groupName;

  @override
  void initState() {
    selectedVariants = new List<Variant>();
    variantsList.forEach((element) {
      if(element.variantDefault)
        selectedVariants.add(element);
    });
    super.initState();
  }

  VariantsSelectorState(this.variantGroup){
    groupName = variantGroup.name;
    variantsList = variantGroup.variants;
    required = variantGroup.required;
  }

  List<Variant> getSelectedToppings() {

    return selectedVariants;
  }

  bool hasSelectedVariants(){
    return selectedVariants.isNotEmpty;
  }

  Widget build(BuildContext context) {
    List<Widget> widgetsList = new List<Widget>();
    widgetsList.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 15, top: 15),
              child: Text(
                groupName,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 15, top: 10),
            child: Text((required) ? 'Обязательно' : 'Опционально'),
          )
        ],
      ),
    );
    if(!required){
      variantsList.forEach((element) {
        widgetsList.add( InkWell(
          child: Padding(
            padding:  EdgeInsets.only(left: 15, top: 12, bottom: 17),
            child: Row(
              children: [
                (selectedVariants.contains(element)) ? SvgPicture.asset('assets/svg_images/kitchen_selected.svg') :
                SvgPicture.asset('assets/svg_images/kitchen_unselected.svg'),
                Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    element.name,
                    style: TextStyle(color: Color(0xff424242), fontSize: 14),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: Text(
                    '+ ${element.price} \₽',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          onTap: (){
            setState(() {
              if(selectedVariants.contains(element)){
                selectedVariants.remove(element);
              }else{
                selectedVariants.add(element);
              }
            });
          },
        ));
      });
    }else{
      variantsList.forEach((element) {
        print(element.uuid);
        widgetsList.add(
            GestureDetector(
              child: Padding(
                padding:  EdgeInsets.only(top: 13, bottom: 22 , left: 15),
                child: Row(
                  children: [
                    (selectedVariants.contains(element)) ? SvgPicture.asset('assets/svg_images/checked_rest_circle.svg')
                        : SvgPicture.asset('assets/svg_images/rest_circle.svg'),
                    Padding(
                      padding: EdgeInsets.only(left: 18),
                      child: Text(element.name,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14
                        ),
                      ),
                    )
                  ],
                ),
              ),
              onTap: (){
                setState(() {
                  selectedVariants.clear();
                  selectedVariants.add(element);
                });
              },
            )
        );
      });
    }
    return Container(
      color: Colors.white,
      child: ScrollConfiguration(
        behavior: new ScrollBehavior(),
        child: SingleChildScrollView(
          child: Column(
            children: widgetsList,
          ),
        ),
      ),
    );
  }
}