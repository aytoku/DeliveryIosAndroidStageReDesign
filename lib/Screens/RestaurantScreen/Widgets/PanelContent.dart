import 'package:flutter/material.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/Screens/CartScreen/Widgets/PriceField.dart';
import 'package:flutter_app/Screens/RestaurantScreen/API/add_variant_to_cart.dart';
import 'package:flutter_app/Screens/RestaurantScreen/API/getProductData.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Model/ProductDataModel.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Model/ProductsByStoreUuid.dart';
import 'package:flutter_app/Screens/RestaurantScreen/View/restaurant_screen.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/ProductDescCounter.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/ProductMenu/Item.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/ProductMenu/ItemCounter.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/VariantSelector.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PanelContent extends StatefulWidget {
  RestaurantScreenState parent;
  MenuItemState menuItem;

  PanelContent({key, this.parent, this.menuItem
  }) : super(key: key);

  @override
  PanelContentState createState() {
    return new PanelContentState(parent, menuItem);
  }
}

class PanelContentState extends State<PanelContent>{


  PanelContentState(this.parent, this.menuItem);

  RestaurantScreenState parent;
  ProductsByStoreUuid restaurantDataItems;
  MenuItemState menuItem;
  GlobalKey<PriceFieldState> priceFieldKey =
  new GlobalKey<PriceFieldState>();
  ProductsDataModel productsDescription;
  List<VariantsSelector> variantsSelectors;

  @override
  Widget build(BuildContext context) {


    if(menuItem == null)
      return Container(height: 200);

    restaurantDataItems = menuItem.restaurantDataItems;

    GlobalKey<MenuItemCounterState> menuItemCounterKey = new GlobalKey();
    return FutureBuilder<ProductsDataModel>(
      future: getProductDescription(restaurantDataItems.uuid),
      builder: (BuildContext context,
          AsyncSnapshot<ProductsDataModel> snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          productsDescription = snapshot.data;
          variantsSelectors = getVariantGroups(productsDescription);
        }


        if(productsDescription != null){
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                )),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: 1,
                    controller: parent.sc,
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context ,int index){
                      return Stack(
                        children: [
                          Container(
                            height: 220,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                                color: Colors.white
                            ),
                            child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                    bottomLeft: Radius.circular(0),
                                    bottomRight: Radius.circular(0)),
                                child: Stack(
                                  children: <Widget>[
                                    Image.network(
                                      getImage(restaurantDataItems.meta.images[0]),
                                      fit: BoxFit.fill,
                                      height: 220,
                                      width: MediaQuery.of(context).size.width,
                                    ),
                                    Align(
                                        alignment: Alignment.topRight,
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 10, right: 15),
                                          child: GestureDetector(
                                            child: SvgPicture.asset(
                                                'assets/svg_images/bottom_close.svg'),
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ))
                                  ],
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 180),
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(12),
                                      topRight: const Radius.circular(12),
                                    )),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(12),
                                        topRight: const Radius.circular(12),
                                      )),
                                  child:

                                  Stack(
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                topLeft: const Radius.circular(12),
                                                topRight: const Radius.circular(12),
                                              )),
                                          child: Column(
                                            children: [
                                              Container(
                                                child: Column(
                                                  children: [
                                                    Align(
                                                      alignment: Alignment.topLeft,
                                                      child: Padding(
                                                        padding: EdgeInsets.only(top: 20, bottom: 20, left: 16),
                                                        child: Text(restaurantDataItems.name,
                                                          style: TextStyle(
                                                              fontSize: 24
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    (productsDescription.meta.description != "" &&
                                                        productsDescription.meta.description != null)
                                                        ? Padding(
                                                      padding:
                                                      EdgeInsets.only(left: 15, top: 20, bottom: 10),
                                                      child: Align(
                                                        alignment: Alignment.topLeft,
                                                        child: Text(
                                                          productsDescription.meta.description,
                                                          style: TextStyle(
                                                              color: Color(0xFFB0B0B0), fontSize: 13),
                                                        ),
                                                      ),
                                                    )
                                                        : Container(
                                                      height: 0,
                                                    ),
                                                    Divider(height: 0, color: Color(0xFFE6E6E6),),
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
                                                    Column(
                                                        children: variantsSelectors
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 14),
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
                                  padding: EdgeInsets.only(right: 5, left: 8),
                                  child: ProductDescCounter(
                                      key: parent.counterKey,
                                      priceFieldKey: priceFieldKey
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 2,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 6, right: 8, bottom: 0),
                                  child: GestureDetector(
                                    child: Container(
                                      width: 212,
                                      height: 52,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF09B44D),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Добавить",
                                          style:
                                          TextStyle(color: Colors.white, fontSize: 18),
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
                                            && productsDescription.storeUuid != currentUser.cartModel.storeUuid){
                                          print(productsDescription.storeUuid.toString() + "!=" + currentUser.cartModel.storeUuid.toString());
                                          parent.showCartClearDialog(context, cartProduct, menuItemCounterKey);
                                        } else {
                                          currentUser.cartModel = await addVariantToCart(cartProduct, necessaryDataForAuth.device_id, parent.counterKey.currentState.counter);
                                          parent.panelController.close();
                                          menuItem.setState(() {

                                          });

                                          // parent.basketButtonStateKey.currentState.refresh();
                                          // parent.counterKey.currentState.refresh();
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
          );
        }
        else{
          return Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Center(
              child: SpinKitFadingCircle(
                color: Colors.green,
                size: 50.0,
              ),
            ),
          );
        }
      },
    );
  }

  Future<ProductsDataModel> getProductDescription(String uuid) async{
    if(productsDescription != null)
      return productsDescription;
    else
      return await getProductData(uuid);
  }

  List<VariantsSelector> getVariantGroups(ProductsDataModel productsDescription){
    List<VariantsSelector> result = new List<VariantsSelector>();
    productsDescription.variantGroups.forEach((element) {
      result.add(VariantsSelector(key: new GlobalKey<VariantsSelectorState>(), variantGroup: element,));
    });
    return result;
  }
}