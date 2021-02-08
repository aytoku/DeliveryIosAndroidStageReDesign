import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/Screens/AuthScreen/View/auth_screen.dart';
import 'package:flutter_app/Screens/CartScreen/API/clear_cart.dart';
import 'package:flutter_app/Screens/CartScreen/API/decriment_cart_item.dart';
import 'package:flutter_app/Screens/CartScreen/API/delete_item_from_cart.dart';
import 'package:flutter_app/Screens/CartScreen/API/increment_cart_item_count.dart';
import 'package:flutter_app/Screens/CartScreen/Model/CartModel.dart';
import 'package:flutter_app/Screens/CartScreen/Widgets/Counter.dart';
import 'package:flutter_app/Screens/CartScreen/Widgets/PriceField.dart';
import 'package:flutter_app/Screens/CartScreen/Widgets/TotalPrice.dart';
import 'package:flutter_app/Screens/HomeScreen/Model/FilteredStores.dart';
import 'package:flutter_app/Screens/HomeScreen/View/home_screen.dart';
import 'package:flutter_app/Screens/OrderConfirmationScreen/View/address_screen.dart';
import 'package:flutter_app/Screens/OrdersScreen/Model/order.dart';
import 'package:flutter_app/Screens/RestaurantScreen/View/restaurant_screen.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/models/ResponseData.dart';
import 'package:flutter_app/models/RestaurantDataItems.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:io' show Platform;

import '../../../Amplitude/amplitude.dart';
import 'cart_screen.dart';
import 'empty_cart_screen.dart';


class CartPageScreen extends StatefulWidget {
  final FilteredStores restaurant;
  CartPageScreen({
    Key key,
    this.restaurant,
  }) : super(key: key);

  @override
  CartPageState createState() => CartPageState(restaurant);
}

class CartPageState extends State<CartPageScreen> {
  final FilteredStores restaurant;

  int selectedPageId = 0;
  GlobalKey<CartScreenState> cartTakeAwayScreenKey = new GlobalKey<CartScreenState>();
  GlobalKey<CartScreenState> cartScreenKey = new GlobalKey<CartScreenState>();
  TotalPrice totalPriceWidget = new TotalPrice(key: new GlobalKey(),);

  int selectedPaymentId = 0;

  CartPageState(this.restaurant);

  PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.black, // Color for Android
        statusBarBrightness: Brightness.dark // Dark == white status bar -- for IOS.
    ));
  }


  @override
  Widget build(BuildContext context) {
    FocusNode focusNode;
    double totalPrice = 0;
    // currentUser.cartModel.cart.forEach(
    //         (Order order) {
    //       if(order.food.variants != null && order.food.variants.length > 0 && order.food.variants[0].price != null){
    //         totalPrice += order.quantity * (order.food.price + order.food.variants[0].price);
    //       }else{
    //         totalPrice += order.quantity * order.food.price;
    //       }
    //       double toppingsCost = 0;
    //       if(order.food.toppings != null){
    //         order.food.toppings.forEach((element) {
    //           toppingsCost += order.quantity * element.price;
    //         });
    //         totalPrice += toppingsCost;
    //       }
    //     }
    // );
    var cartScreen = CartScreen(restaurant: restaurant, key: cartScreenKey, parent: this, isTakeAwayScreen: false,);
    var cartTakeAwayScreen = CartScreen(restaurant: restaurant, key: cartTakeAwayScreenKey, parent: this, isTakeAwayScreen: true,);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarBrightness: Brightness.light
      ),
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40, bottom: 15),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                     InkWell(
                         onTap: () => Navigator.pop(context),
                         child: Container(
                             height: 40,
                             width: 60,
                             child: Padding(
                               padding: EdgeInsets.only(
                                   top: 12, bottom: 12, right: 25),
                               child: SvgPicture.asset(
                                   'assets/svg_images/arrow_left.svg'),
                             ))),
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Text(
                          'Корзина',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3F3F3F)),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(right: 13),
                          child: GestureDetector(
                            child: SvgPicture.asset(
                                'assets/svg_images/del_basket.svg'),
                            onTap: () {
                              if(Platform.isIOS){
                                return showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.65),
                                      child: Stack(
                                        children: [
                                          Dialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                            child: InkWell(
                                              child: Container(
                                                height: 50,
                                                width: 100,
                                                child: Center(
                                                  child: Text("Очистить корзину",
                                                    style: TextStyle(
                                                        color: Color(0xFFFF3B30),
                                                        fontSize: 20
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              onTap: () async {
                                                currentUser.cartModel = await clearCart(necessaryDataForAuth.device_id);
                                                setState(() {
                                                  AmplitudeAnalytics.analytics.logEvent('remove_from_cart_all');
                                                });
                                                Navigator.pushReplacement(
                                                  context,
                                                  new MaterialPageRoute(
                                                    builder: (context) =>
                                                    new EmptyCartScreen(restaurant: restaurant),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 120),
                                            child: Dialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                              child: InkWell(
                                                child: Container(
                                                  height: 50,
                                                  width: 100,
                                                  child: Center(
                                                    child: Text("Отмена",
                                                      style: TextStyle(
                                                          color: Color(0xFF007AFF),
                                                          fontSize: 20
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                onTap: (){
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                );
                              }else{
                                return showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 0),
                                      child: Dialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(15.0))),
                                        child: Container(
                                            height: 130,
                                            width: 300,
                                            child: Column(
                                              children: <Widget>[
                                                InkWell(
                                                  child: Container(
                                                    padding: EdgeInsets.only(top: 20, bottom: 20),
                                                    child: Center(
                                                      child: Text("Очистить корзину",
                                                        style: TextStyle(
                                                            color: Color(0xFFFF3B30),
                                                            fontSize: 20
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  onTap: () async {
                                                    currentUser.cartModel = await clearCart(necessaryDataForAuth.device_id);
                                                    setState(() {
                                                      AmplitudeAnalytics.analytics.logEvent('remove_from_cart_all');
                                                    });
                                                    Navigator.pushReplacement(
                                                      context,
                                                      new MaterialPageRoute(
                                                        builder: (context) =>
                                                        new EmptyCartScreen(restaurant: restaurant),
                                                      ),
                                                    );
                                                  },
                                                ),
                                                Divider(
                                                  height: 1,
                                                  color: Colors.grey,
                                                ),
                                                InkWell(
                                                  child: Container(
                                                    padding: EdgeInsets.only(top: 20, bottom: 20),
                                                    child: Center(
                                                      child: Text("Отмена",
                                                        style: TextStyle(
                                                            color: Color(0xFF007AFF),
                                                            fontSize: 20
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  onTap: (){
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                            )),
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          )),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  width: 350,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: Color(0xFF09B44D),
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        child: Padding(
                          padding: EdgeInsets.only(left: 0,
                              right: 0),
                          child: Container(
                            height: 40,
                            width: 176,
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(4), bottomLeft: Radius.circular(4)),
                              color: (selectedPageId == 0) ? Color(0xFF09B44D) : Colors.white,
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 0, right: 0, top: 0),
                              child: Center(
                                child: Text(
                                  'Доставка',
                                  style: TextStyle(
                                      color: (selectedPageId == 0) ? Colors.white : Color(0xFF09B44D), fontSize: 15),
                                ),
                              ),
                            ),
                          ),
                        ),
                        onTap: () async {
                          if (await Internet.checkConnection()) {
                            _controller.jumpToPage(0);
                          } else {
                            noConnection(context);
                          }
                        },
                      ),
                      GestureDetector(
                        child: Padding(
                          padding: EdgeInsets.only(left: 0,
                              right: 0),
                          child: Container(
                            height: 40,
                            width: 172,
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.only(topRight: Radius.circular(4), bottomRight: Radius.circular(4)),
                              color: (selectedPageId == 1) ? Color(0xFF09B44D) : Colors.white,
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 0, right: 0, top: 0),
                              child: Center(
                                child: Text(
                                  'Самовывоз',
                                  style: TextStyle(
                                      color: (selectedPageId == 1) ? Colors.white : Color(0xFF09B44D), fontSize: 15),
                                ),
                              ),
                            ),
                          ),
                        ),
                        onTap: () async {
                          if (await Internet.checkConnection()) {
                            _controller.jumpToPage(1);
                          } else {
                            noConnection(context);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _controller,
                  children: [cartScreen, cartTakeAwayScreen],
                  onPageChanged: (int pageId) {
                    setState(() {
                      selectedPageId = pageId;
                    });
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            spreadRadius: 1
                        )
                      ]
                  ),
                  child: Padding(
                    padding:
                    EdgeInsets.only(top: 15, right: 15, left: 15, bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Column(
                            children: [
                              totalPriceWidget,
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  (currentUser.cartModel.cookingTime != null)? '~' + '${currentUser.cartModel.cookingTime ~/ 60} мин' : '',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        FlatButton(
                          child: Text('Далее',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white)),
                          color: Color(0xFF09B44D),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.only(
                              left: 70, top: 20, right: 70, bottom: 20),
                          onPressed: () async {
                            if (await Internet.checkConnection()) {
                              if (currentUser.isLoggedIn) {
                                if(selectedPageId == 0){
                                  Navigator.of(context).push(
                                      PageRouteBuilder(
                                          pageBuilder: (context, animation, anotherAnimation) {
                                            return AddressScreen(restaurant: restaurant, isTakeAwayOrderConfirmation: false);
                                          },
                                          transitionDuration: Duration(milliseconds: 300),
                                          transitionsBuilder:
                                              (context, animation, anotherAnimation, child) {
                                            return SlideTransition(
                                              position: Tween(
                                                  begin: Offset(-1.0, 0.0),
                                                  end: Offset(0.0, 0.0))
                                                  .animate(animation),
                                              child: child,
                                            );
                                          }
                                      ));
                                }else{
                                  Navigator.of(context).push(
                                      PageRouteBuilder(
                                          pageBuilder: (context, animation, anotherAnimation) {
                                            return AddressScreen(restaurant: restaurant, isTakeAwayOrderConfirmation: true);
                                          },
                                          transitionDuration: Duration(milliseconds: 300),
                                          transitionsBuilder:
                                              (context, animation, anotherAnimation, child) {
                                            return SlideTransition(
                                              position: Tween(
                                                  begin: Offset(-1.0, 0.0),
                                                  end: Offset(0.0, 0.0))
                                                  .animate(animation),
                                              child: child,
                                            );
                                          }
                                      ));
                                }
                              } else {
                                Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new AuthScreen()),
                                );
                              }
                            } else {
                              noConnection(context);
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}