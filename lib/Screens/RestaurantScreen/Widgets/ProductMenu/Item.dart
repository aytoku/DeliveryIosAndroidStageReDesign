import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/Screens/CartScreen/Widgets/PriceField.dart';
import 'package:flutter_app/Screens/RestaurantScreen/API/add_variant_to_cart.dart';
import 'package:flutter_app/Screens/RestaurantScreen/API/getProductData.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Model/ProductDataModel.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Model/ProductsByStoreUuid.dart';
import 'package:flutter_app/Screens/RestaurantScreen/View/restaurant_screen.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/ProductDescCounter.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/ProductMenu/ItemDesc.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/VariantSelector.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/data/global_variables.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../../data/data.dart';
import 'ItemCounter.dart';

class MenuItem extends StatefulWidget {
  MenuItem({this.key, this.restaurantDataItems, this.parent}) : super(key: key);
  final GlobalKey<MenuItemState> key;
  final RestaurantScreenState parent;
  final ProductsByStoreUuid restaurantDataItems;

  @override
  MenuItemState createState() {
    return new MenuItemState(restaurantDataItems, parent);
  }
  static List<MenuItem> fromFoodRecordsList(List<ProductsByStoreUuid> foodRecordsList, RestaurantScreenState parent) {
    List<MenuItem> result = new List<MenuItem>();
    foodRecordsList.forEach((element) {
      result.add(new MenuItem(parent: parent, restaurantDataItems: element, key: new GlobalKey<MenuItemState>()));
    });
    return result;
  }
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    if(restaurantDataItems.productCategories != null && restaurantDataItems.productCategories.isNotEmpty)
      return "cat: " + restaurantDataItems.productCategories[0].name;
    else
      return "В итеме каты нал";
  }
}

class MenuItemState extends State<MenuItem> with AutomaticKeepAliveClientMixin{
  final ProductsByStoreUuid restaurantDataItems;
  final RestaurantScreenState parent;
  bool cartBottomPadding = false;


  MenuItemState(this.restaurantDataItems, this.parent);

  showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(context).pop(true);
        });
        return Padding(
          padding: EdgeInsets.only(bottom: 500),
          child: Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            child: Container(
              height: 50,
              width: 100,
              child: Center(
                child: Text("Товар добавлен в коризну"),
              ),
            ),
          ),
        );
      },
    );
  }


  @override
  bool get wantKeepAlive => true;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    if(restaurantDataItems.productCategories != null && restaurantDataItems.productCategories.isNotEmpty)
      return "cat: " + restaurantDataItems.productCategories[0].name;
    else
      return "В итеме каты нал";
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    GlobalKey<MenuItemCounterState> menuItemCounterKey = new GlobalKey();
    if(parent.restaurant.type == 'restaurant'){
      return Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.only(top: 15.0, left: 15, right: 15,
              bottom: (cartBottomPadding) ? MediaQuery.of(context).size.height * 0.15 : 15),
          child: Center(
              child: GestureDetector(
                  onTap: () async {
                    if (await Internet.checkConnection()) {
                      onPressedButton(restaurantDataItems, menuItemCounterKey);
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=> PB()));
                    } else {
                      noConnection(context);
                    }
                  },
                  child: Container(
                    height: 153,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4.0, // soften the shadow
                          spreadRadius: 1.0, //extend the shadow
                        )
                      ],
                      color: Colors.white,
                      border: Border.all(width: 1.0, color: Colors.grey[200]),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFFFFFF),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15)),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        height: 100,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 10.0, left: 15, bottom: 5),
                                              child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  restaurantDataItems.name,
                                                  maxLines: 3,
                                                  style: TextStyle(
                                                      fontSize: 16.0, color: Color(0xFF3F3F3F), fontWeight: FontWeight.w700),
                                                  textAlign: TextAlign.start,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            MenuItemDesc(foodRecords: restaurantDataItems, parent: this)
                                          ],
                                        ),
                                      ),
                                      MenuItemCounter(foodRecords: restaurantDataItems, menuItemCounterKey: menuItemCounterKey, parent: this)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(15),
                                bottomRight: Radius.circular(15)),
                            child: Image.network(
                              getImage((restaurantDataItems.meta.images != null) ? restaurantDataItems.meta.images[0] : ''),
                              fit: BoxFit.cover,
                              height: MediaQuery.of(context).size.height,
                              width: 168,
                            ),),
                        )
                      ],
                    ),
                  ))),
        ),
      );
    }else {
      return GestureDetector(
        child: Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          height: 250,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4.0, // soften the shadow
                spreadRadius: 1.0, //extend the shadow
              )
            ],
            color: Colors.white,
            border: Border.all(width: 1.0, color: Colors.grey[200]),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Container(
                height: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10)),
                  child: Image.network(
                    getImage((restaurantDataItems.meta.images != null) ? restaurantDataItems.meta.images[0] : ''),
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                  ),),
              ),
              Container(
                height: 108,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    color: Color(0xFFFAFAFA)
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 14, top: 12),
                        child: Text(
                          restaurantDataItems.name,
                          maxLines: 3,
                          style: TextStyle(
                              fontSize: 16.0, color: Color(0xFF3F3F3F), fontWeight: FontWeight.w700),
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    MenuItemDesc(foodRecords: restaurantDataItems, parent: this),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: MenuItemCounter(
                            foodRecords: restaurantDataItems,
                            menuItemCounterKey: menuItemCounterKey,
                            parent: this),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        onTap: () async {
          if (await Internet.checkConnection()) {
            onPressedButton(restaurantDataItems, menuItemCounterKey);
            // Navigator.push(context, MaterialPageRoute(builder: (context)=> PB()));
          } else {
            noConnection(context);
          }
        },
      );
    }
  }


  void onPressedButton(ProductsByStoreUuid food, GlobalKey<MenuItemCounterState> menuItemCounterKey) {

    DateTime now = DateTime.now();
    int currentTime = now.hour*60+now.minute;
    int dayNumber  = now.weekday-1;

//    int work_beginning = parent.restaurant.work_schedule[dayNumber].work_beginning;
//    int work_ending = parent.restaurant.work_schedule[dayNumber].work_ending;
//    bool day_off = parent.restaurant.work_schedule[dayNumber].day_off;
//    bool available = parent.restaurant.available != null ? parent.restaurant.available : true;


    GlobalKey<PriceFieldState> priceFieldKey =
    new GlobalKey<PriceFieldState>();


    if(restaurantDataItems.type == 'single'){
      if(parent.panelContentKey.currentState != null)
        parent.panelContentKey.currentState.setState(() {
          parent.panelContentKey.currentState.menuItem = null;
        });

      showModalBottomSheet(
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(12),
                topRight: const Radius.circular(12),
              )),
          context: context,
          builder: (context) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(12),
                    topRight: const Radius.circular(12),
                  )
              ),
              child: Wrap(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Align(
                        alignment: Alignment.topCenter,
                        child: SvgPicture.asset('assets/svg_images/close_button.svg')),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(12),
                          topRight: const Radius.circular(12),
                        )
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(0)),
                            child: Stack(
                              children: <Widget>[
                                Image.network(
                                  getImage((restaurantDataItems.meta.images != null) ? restaurantDataItems.meta.images[0] : ''),
                                  fit: BoxFit.fill,
                                  height:300,
                                  width: MediaQuery.of(context).size.width,
                                ),
                                // Align(
                                //     alignment: Alignment.topRight,
                                //     child: Padding(
                                //       padding: EdgeInsets.only(top: 10, right: 15),
                                //       child: GestureDetector(
                                //         child: SvgPicture.asset(
                                //             'assets/svg_images/bottom_close.svg'),
                                //         onTap: () {
                                //           Navigator.pop(context);
                                //         },
                                //       ),
                                //     ))
                              ],
                            )),
                        Container(
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 20, bottom: 10, left: 16),
                                  child: Text(restaurantDataItems.name,
                                    style: TextStyle(
                                        fontSize: 24
                                    ),
                                  ),
                                ),
                              ),
                              (restaurantDataItems.meta.description != "" &&
                                  restaurantDataItems.meta.description != null)
                                  ? Padding(
                                padding:
                                EdgeInsets.only(left: 15, top: 10, bottom: 10),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    restaurantDataItems.meta.description,
                                    style: TextStyle(
                                        color: Color(0xFFB0B0B0), fontSize: 13),
                                  ),
                                ),
                              )
                                  : Container(
                                height: 0,
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.only(left: 15, top: 15, bottom: 15, right: 15),
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //     children: [
                              //       Column(
                              //         children: [
                              //           Text('Белки',
                              //             style: TextStyle(
                              //                 color: Color(0xFF7D7D7D),
                              //                 fontSize: 14
                              //             ),
                              //           ),
                              //           Text((productsDescription!= null) ? productsDescription.meta.energyValue.protein.toString(): '',
                              //             style: TextStyle(
                              //                 color: Color(0xFF7D7D7D),
                              //                 fontSize: 14
                              //             ),
                              //           ),
                              //         ],
                              //       ),
                              //       Padding(
                              //         padding: EdgeInsets.only(left: 30),
                              //         child: Column(
                              //           children: [
                              //             Text('Жиры',
                              //               style: TextStyle(
                              //                   color: Color(0xFF7D7D7D),
                              //                   fontSize: 14
                              //               ),
                              //             ),
                              //             Text((productsDescription!= null) ? productsDescription.meta.energyValue.fat.toString(): '',
                              //               style: TextStyle(
                              //                   color: Color(0xFF7D7D7D),
                              //                   fontSize: 14
                              //               ),
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //       Padding(
                              //         padding: EdgeInsets.only(left: 30),
                              //         child: Column(
                              //           children: [
                              //             Text('Углеводы',
                              //               style: TextStyle(
                              //                   color: Color(0xFF7D7D7D),
                              //                   fontSize: 14
                              //               ),
                              //             ),
                              //             Text((productsDescription!= null) ? productsDescription.meta.energyValue.carbohydrates.toString() :"",
                              //               style: TextStyle(
                              //                   color: Color(0xFF7D7D7D),
                              //                   fontSize: 14
                              //               ),
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //       Padding(
                              //         padding: EdgeInsets.only(left: 30),
                              //         child: Column(
                              //           children: [
                              //             Text('Ккал',
                              //               style: TextStyle(
                              //                   color: Color(0xFF7D7D7D),
                              //                   fontSize: 14
                              //               ),
                              //             ),
                              //             Text((productsDescription!= null) ? productsDescription.meta.energyValue.calories.toString(): '',
                              //               style: TextStyle(
                              //                   color: Color(0xFF7D7D7D),
                              //                   fontSize: 14
                              //               ),
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        FutureBuilder<ProductsDataModel>(
                          future: getProductData(restaurantDataItems.uuid),
                          builder: (BuildContext context,
                              AsyncSnapshot<ProductsDataModel> snapshot){
                            if(snapshot.connectionState == ConnectionState.done){
                              ProductsDataModel productsDescription = snapshot.data;

                              List<VariantsSelector> variantsSelectors = getVariantGroups(productsDescription);

                              return Container(
                                child: Stack(
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(top: (productsDescription.product.meta.description != "" &&
                                                  productsDescription.product.meta.description != null) ? 14 : 0),
                                              child: Container(
                                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                                decoration: (productsDescription.variantGroups != null) ? BoxDecoration(
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black12,
                                                      blurRadius: 4.0, // soften the shadow
                                                      spreadRadius: 1.0, //extend the shadow
                                                    )
                                                  ],
                                                ) : null,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: <Widget>[
                                                        Expanded(child: Padding(
                                                          padding: const EdgeInsets.only(left: 20, right: 10, top: 10),
                                                          child: Container(
                                                            child: RichText(text:
                                                            TextSpan(
                                                                children: <TextSpan>[
                                                                  TextSpan(text: restaurantDataItems.name,
                                                                    style: TextStyle(
                                                                        fontSize: 15.0,
                                                                        color: Color(0xFF000000)),),
                                                                ]
                                                            )
                                                            ),
                                                          ),
                                                        )),
                                                        Padding(
                                                          padding: EdgeInsets.only(right: 20, top: 8),
                                                          child: PriceField(key: priceFieldKey, restaurantDataItems: restaurantDataItems),
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 4.0,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(top: 10, bottom: 5),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: <Widget>[
                                                          Flexible(
                                                            flex: 1,
                                                            child: Padding(
                                                              padding: EdgeInsets.only(left: 16),
                                                              child: ProductDescCounter(
                                                                  key: parent.counterKey,
                                                                  priceFieldKey: priceFieldKey
                                                              ),
                                                            ),
                                                          ),
                                                          Flexible(
                                                            flex: 2,
                                                            child: Padding(
                                                              padding: EdgeInsets.only(left: 8, right: 16),
                                                              child: GestureDetector(
                                                                child: Container(
                                                                  height: 52,
                                                                  decoration: BoxDecoration(
                                                                    color: mainColor,
                                                                    borderRadius: BorderRadius.circular(10),
                                                                  ),
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.only(left: 64, right: 64),
                                                                    child: Center(
                                                                      child: Text(
                                                                        "Добавить",
                                                                        style:
                                                                        TextStyle(color: Colors.white, fontSize: 18),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                onTap: () async {
                                                                  if (await Internet.checkConnection()) {
                                                                    ProductsDataModel cartProduct = ProductsDataModel.fromJson(productsDescription.toJson());
                                                                    bool hasErrors = false;
                                                                    cartProduct.variantGroups = new List<VariantGroup>();
                                                                    variantsSelectors.forEach((variantGroupSelector) {
                                                                      if(variantGroupSelector.key.currentState.hasSelectedVariants()){
                                                                        cartProduct.variantGroups.add(VariantGroup.fromJson(variantGroupSelector.variantGroup.toJson()));
                                                                        cartProduct.variantGroups.last.variants = variantGroupSelector.key.currentState.selectedVariants;
                                                                      } else if(variantGroupSelector.key.currentState.required) {
                                                                        hasErrors = true;
                                                                        variantGroupSelector.key.currentState.setState(() {
                                                                          variantGroupSelector.key.currentState.error = true;
                                                                        });
                                                                      }
                                                                    });

                                                                    if(hasErrors){
                                                                      return;
                                                                    }

                                                                    if(currentUser.cartModel != null && currentUser.cartModel.items != null
                                                                        && currentUser.cartModel.items.length > 0
                                                                        && productsDescription.product.storeUuid != currentUser.cartModel.storeUuid){
                                                                      print(productsDescription.product.storeUuid.toString() + "!=" + currentUser.cartModel.storeUuid.toString());
                                                                      parent.showCartClearDialog(context, cartProduct, menuItemCounterKey, this);
                                                                    } else {
                                                                      currentUser.cartModel = await addVariantToCart(cartProduct, necessaryDataForAuth.device_id, parent.counterKey.currentState.counter);
                                                                      menuItemCounterKey.currentState.refresh();
                                                                      Navigator.pop(context);
                                                                      setState(() {

                                                                      });
                                                                      parent.showAlertDialog(context);
                                                                      if(parent.basketButtonStateKey.currentState != null){
                                                                        parent.basketButtonStateKey.currentState.refresh();
                                                                      }
                                                                    }
                                                                  } else {
                                                                    noConnection(context);
                                                                  }
                                                                },
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
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
                              return Padding(
                                padding: const EdgeInsets.only(top: 40),
                                child: Container(
                                  height: 80,
                                  decoration: BoxDecoration(
                                      color: Colors.white
                                  ),
                                  child: Center(
                                    child: SpinKitFadingCircle(
                                      color: Colors.green,
                                      size: 50.0,
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          });

    }else{
      if(parent.panelContentKey.currentState != null)
        parent.panelContentKey.currentState.setState(() {
          parent.panelContentKey.currentState.reset();
          parent.panelContentKey.currentState.menuItem = this;
          parent.panelContentKey.currentState.menuItemCounterKey = menuItemCounterKey;
        });
      parent.panelController.open();
    }
  }

  List<VariantsSelector> getVariantGroups(ProductsDataModel productsDescription){
    List<VariantsSelector> result = new List<VariantsSelector>();
    productsDescription.variantGroups.forEach((element) {
      result.add(VariantsSelector(key: new GlobalKey<VariantsSelectorState>(), variantGroup: element,));
    });
    return result;
  }
}