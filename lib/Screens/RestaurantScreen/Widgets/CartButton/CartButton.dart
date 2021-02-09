import 'package:flutter/material.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/Screens/CartScreen/View/cart_page_view.dart';
import 'package:flutter_app/Screens/CartScreen/View/empty_cart_screen.dart';
import 'package:flutter_app/Screens/HomeScreen/Model/FilteredStores.dart';
import 'package:flutter_app/Screens/RestaurantScreen/View/restaurant_screen.dart';
import 'package:flutter_app/data/data.dart';

import 'CartButtonCounter.dart';

class CartButton extends StatefulWidget {
  final FilteredStores restaurant;

  CartButton({Key key, this.restaurant}) : super(key: key);

  @override
  CartButtonState createState() {
    return new CartButtonState(restaurant);
  }
}

class CartButtonState extends State<CartButton> {
  GlobalKey<CartButtonCounterState> buttonCounterKey = new GlobalKey();
  final FilteredStores restaurant;

  CartButtonState(this.restaurant);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // if (currentUser.cartModel.cart != null &&
    //     (currentUser.cartModel.cart.length == 0 ||
    //         currentUser.cartModel.cart[0].restaurant.uuid !=
    //             restaurant.uuid)) {
    //   return Container();
    // }
    if(currentUser.cartModel == null ||
        currentUser.cartModel.items == null ||
          currentUser.cartModel.items.length < 1){
      return Container();
    }else{
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 85,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4.0, // soften the shadow
              spreadRadius: 1.0, //extend the shadow
            )
          ],
        ),
        child: Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.only(top: 15, bottom: 5),
            //   child: Center(
            //     child: Text('До бесплатной доставки осталось 250\₽',
            //       style: TextStyle(
            //           fontSize: 12
            //       ),
            //     ),
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.all(10),
              child: FlatButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF09B44D),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              (currentUser.cartModel.cookingTime != null)? '${currentUser.cartModel.cookingTime ~/ 60} мин' : '',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )),
                    Flexible(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: 15,
                          ),
                          child: Text('Корзина',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white)),
                        )),
                    Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF09B44D),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: new CartButtonCounter(
                            key: buttonCounterKey,
                          ),
                        ))
                  ],
                ),
                color: Color(0xFF09B44D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
                onPressed: () async {
                  if (await Internet.checkConnection()) {
                    if (currentUser.cartModel.items.length == 0) {
                      Navigator.of(context).push(
                          PageRouteBuilder(
                              pageBuilder: (context, animation, anotherAnimation) {
                                return EmptyCartScreen(restaurant: restaurant);
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
                    } else {
                      Navigator.of(context).push(
                          PageRouteBuilder(
                              pageBuilder: (context, animation, anotherAnimation) {
                                return CartPageScreen(restaurant: restaurant);
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
                    noConnection(context);
                  }
                },
              ),
            ),
          ],
        ),
      );
    }
  }

  void refresh() {
    setState(() {});
  }
}