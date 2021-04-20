import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/Screens/CartScreen/Widgets/PriceField.dart';
import 'package:flutter_app/Screens/HomeScreen/Bloc/restaurant_get_bloc.dart';
import 'package:flutter_app/Screens/HomeScreen/Model/FilteredStores.dart';
import 'package:flutter_app/Screens/HomeScreen/View/home_screen.dart';
import 'package:flutter_app/Screens/RestaurantScreen/API/add_variant_to_cart.dart';
import 'package:flutter_app/Screens/RestaurantScreen/API/getProductData.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Model/ProductDataModel.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Model/ProductsByStoreUuid.dart';
import 'package:flutter_app/Screens/RestaurantScreen/View/restaurant_screen.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/DiscountType.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/ProductDescCounter.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/ProductMenu/ItemDesc.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/VariantSelector.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../../data/data.dart';
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

class MenuItemState extends State<MenuItem> with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin{
  final ProductsByStoreUuid restaurantDataItems;
  final RestaurantScreenState parent;
  double _scale;
  AnimationController _controller;


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
  void initState() {
    // TODO: implement initState
    super.initState();
    lock = false;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 100,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
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


  _dayOff() {
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
            height: 250,
            child: _dayOffBottomNavigationMenu(parent.restaurant),
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                )),
          );
        });
  }


  _dayOffBottomNavigationMenu(FilteredStores restaurant) {
    Standard standard = parent.restaurant.workSchedule.getCurrentStandard();
    return Container(
      decoration: BoxDecoration(
          color: AppColor.themeColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
          )),
      child: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 30),
            child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Text('К сожалению, заведение не доступно.',
                      style: TextStyle(
                          fontSize: 16
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text((standard!= null) ? "Заведение откроется в ${standard.beginningTime} часов" : '',
                      style: TextStyle(
                          fontSize: 16
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10,left: 15, right: 15, bottom: 25),
            child: Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  child: Container(
                    height: 52,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColor.mainColor
                    ),
                    child: Center(
                      child: Text(
                        "Далее",
                        style:
                        TextStyle(color: AppColor.textColor, fontSize: 16),
                      ),
                    ),
                  ),
                  onTap: ()async {
                    homeScreenKey = new GlobalKey<HomeScreenState>();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) => RestaurantGetBloc(),
                              child: new HomeScreen(),
                            )),
                            (Route<dynamic> route) => false);
                  },
                )
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    bool isScheduleAvailable = parent.restaurant.workSchedule.isAvailable();
    //isScheduleAvailable = false;
    bool available = parent.restaurant.available.flag != null ? parent.restaurant.available.flag : true;
    super.build(context);
    GlobalKey<MenuItemCounterState> menuItemCounterKey = new GlobalKey();
    if(parent.restaurant.type == 'restaurant'){
      return Transform.scale(
        scale: _scale,
        child: Container(
          color: AppColor.themeColor,
          child: Padding(
            padding: EdgeInsets.only(top: 10.0, left: 15, right: 15,
                bottom:  10),
            child: Center(
                child: GestureDetector(
                  // onTapDown: _onTapDown,
                  //   onTapUp: _onTapUp,
                    onTap: () async {
                      if (await Internet.checkConnection()) {
                        if(!available || !isScheduleAvailable){
                          _dayOff();
                        }else{
                          onPressedButton(restaurantDataItems, menuItemCounterKey);
                        }
                        // Navigator.push(context, MaterialPageRoute(builder: (context)=> PB()));
                      } else {
                        noConnection(context);
                      }
                    },
                    child: Container(
                      height: 152,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12.withOpacity(0.05),
                            blurRadius: 7.0, // soften the shadow
                            spreadRadius: 3.0, //extend the shadow
                          )
                        ],
                        color: AppColor.themeColor,
                        // border: Border.all(width: 1.0, color: Colors.grey[200]),
                        borderRadius: BorderRadius.circular(12),
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
                                          height: 110,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(top: 10.0, left: 15, bottom: 25),
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
                          Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: Stack(
                                      children: [
                                        Image.asset('assets/images/food.png',
                                          fit: BoxFit.cover,
                                          height:
                                          MediaQuery.of(context).size.height,
                                          width: 168,
                                        ),
                                        Image.network(
                                          getImage((restaurantDataItems
                                              .meta.images !=
                                              null)
                                              ? restaurantDataItems.meta.images[0]
                                              : ''),
                                          fit: BoxFit.cover,
                                          height:
                                          MediaQuery.of(context).size.height,
                                          width: 168,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: restaurantDataItems.meta.oldPrice == 0 ? false : true,
                                child: DiscountTapeWidget(price: restaurantDataItems.price, oldPrice: restaurantDataItems.meta.oldPrice,),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ))),
          ),
        ),
      );
    }else {
      return GestureDetector(
        // onTapDown: _onTapDown,
        // onTapUp: _onTapUp,
        // onLongPressEnd: _onLongPressEnd,
        // onHorizontalDragEnd: _onDragUpdate,
        child: Transform.scale(
          scale: _scale,
          child: Container(
            // margin: EdgeInsets.only(left: 10, right: 10),
            height: 250,
            decoration: BoxDecoration(
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.black12,
              //     blurRadius: 4.0, // soften the shadow
              //     spreadRadius: 1.0, //extend the shadow
              //   )
              // ],
              color: AppColor.themeColor,
              border: Border.all(width: 0.5, color: AppColor.unselectedBorderFieldColor.withOpacity(0.3)),
              // borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Column(
                children: [
                  Container(
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Stack(
                        children: [
                          Image.asset('assets/images/food.png',
                            fit: BoxFit.cover,
                            height:
                            MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                          ),
                          Image.network(
                            getImage((restaurantDataItems.meta.images != null) ? restaurantDataItems.meta.images[0] : ''),
                            fit: BoxFit.cover,
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ],
                      ),),
                  ),
                  Container(
                    height: 125,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        color: Colors.transparent
                    ),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 2, top: 12),
                            child: Text(
                              restaurantDataItems.name,
                              maxLines: 3,
                              style: TextStyle(
                                  fontSize: 16.0, color: Color(0xFF3F3F3F), ),
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 2.0, bottom: 0, top: 5),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              padding: EdgeInsets.only(right: 0),
                              child: Text(
                                restaurantDataItems.meta.description,
                                style: TextStyle(
                                    fontSize: 10.0,
                                    color: AppColor.textColor.withOpacity(0.6), ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                        ),
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
          ),
        ),
        onTap: () async {
          if (await Internet.checkConnection()) {
            if(!available || !isScheduleAvailable){
              _dayOff();
            }else{
              onPressedButton(restaurantDataItems, menuItemCounterKey);
            }
            // Navigator.push(context, MaterialPageRoute(builder: (context)=> PB()));
          } else {
            noConnection(context);
          }
        },
      );
    }
  }


  void onPressedButton(ProductsByStoreUuid food, GlobalKey<MenuItemCounterState> menuItemCounterKey) {


    bool isScheduleAvailable = parent.restaurant.workSchedule.isAvailable();
    Standard standard = parent.restaurant.workSchedule.getCurrentStandard();
    bool available = parent.restaurant.available.flag != null ? parent.restaurant.available.flag : true;


    GlobalKey<PriceFieldState> priceFieldKey =
    new GlobalKey<PriceFieldState>();

    if(!available || !isScheduleAvailable){
      _dayOff();
    }

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
                      color: AppColor.themeColor,
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
                                Center(child: Image.asset('assets/images/food.png')),
                                Image.network(
                                  getImage((restaurantDataItems.meta.images != null) ? restaurantDataItems.meta.images[0] : ''),
                                  fit: BoxFit.fill,

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
                              // Align(
                              //   alignment: Alignment.topLeft,
                              //   child: Padding(
                              //     padding: EdgeInsets.only(top: 20, bottom: 10, left: 16),
                              //     child: Text(restaurantDataItems.name,
                              //       style: TextStyle(
                              //           fontSize: 24
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              // (restaurantDataItems.meta.description != "" &&
                              //     restaurantDataItems.meta.description != null)
                              //     ? Padding(
                              //   padding:
                              //   EdgeInsets.only(left: 15, top: 10, bottom: 10),
                              //   child: Align(
                              //     alignment: Alignment.topLeft,
                              //     child: Text(
                              //       restaurantDataItems.meta.description,
                              //       style: TextStyle(
                              //           color: Color(0xFFB0B0B0), fontSize: 13),
                              //     ),
                              //   ),
                              // )
                              //     : Container(
                              //   height: 0,
                              // ),
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
                                          color: AppColor.themeColor,
                                        ),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(top: (productsDescription.product.meta.description != "" &&
                                                  productsDescription.product.meta.description != null) ? 14 : 0),
                                              child: Container(
                                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                                decoration: (productsDescription.variantGroups != null) ? BoxDecoration(
                                                  color: AppColor.themeColor,
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
                                                                        fontSize: 16.0,
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
                                                              child: Stack(
                                                                children: [
                                                                  Container(
                                                                    height: 52,
                                                                    decoration: BoxDecoration(
                                                                      color: AppColor.mainColor,
                                                                      borderRadius: BorderRadius.circular(10),
                                                                    ),
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.only(left: 15, right: 15),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            "Добавить",
                                                                            style:
                                                                            TextStyle(color: AppColor.textColor, fontSize: 18),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Material(
                                                                    type: MaterialType.transparency,
                                                                    child: InkWell(
                                                                      splashColor: AppColor.unselectedBorderFieldColor.withOpacity(0.5),
                                                                      child: Ink(
                                                                        child: Container(
                                                                          height: 52,
                                                                          decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(10),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      onTap: () async {
                                                                        if (await Internet.checkConnection()) {
                                                                          try{
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
                                                                              Navigator.pop(context);
                                                                              menuItemCounterKey.currentState.refresh();
                                                                              setState(() {

                                                                              });

                                                                              // Добавляем паддинг в конец
                                                                              if(parent.itemsPaddingKey.currentState != null){
                                                                                parent.itemsPaddingKey.currentState.setState(() {

                                                                                });
                                                                              }

                                                                              parent.showAlertDialog(context);
                                                                              if(parent.basketButtonStateKey.currentState != null){
                                                                                parent.basketButtonStateKey.currentState.refresh();
                                                                              }
                                                                            }
                                                                          }finally{
                                                                            lock = false;
                                                                            await Vibrate.canVibrate;
                                                                          }
                                                                        } else {
                                                                          noConnection(context);
                                                                        }
                                                                      },
                                                                    ),
                                                                  ),
                                                                ],
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
                                      color: AppColor.themeColor
                                  ),
                                  child: Center(
                                    child: SpinKitFadingCircle(
                                      color: AppColor.mainColor,
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


  void _otTap() {
    _controller.forward();
    _controller.reverse();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onLongPressEnd(LongPressEndDetails details) {
    _controller.reverse();
  }

  void _onDragUpdate(DragEndDetails details) {
    _controller.reverse();
  }

}

