
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/CartScreen/View/cart_page_view.dart';
import 'package:flutter_app/Screens/CartScreen/Widgets/Counter.dart';
import 'package:flutter_app/Screens/CartScreen/Widgets/PriceField.dart';
import 'package:flutter_app/Screens/CartScreen/Widgets/TotalPrice.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../Amplitude/amplitude.dart';
import '../../../data/data.dart';
import '../../../data/data.dart';
import '../../HomeScreen/Model/FilteredStores.dart';
import '../../RestaurantScreen/View/restaurant_screen.dart';
import '../API/clear_cart.dart';
import '../API/delete_item_from_cart.dart';
import '../Model/CartModel.dart';
import 'empty_cart_screen.dart';

class CartScreen extends StatefulWidget {
  CartScreen({Key key, this.restaurant, this.parent, this.isTakeAwayScreen}) : super(key: key);
  final FilteredStores restaurant;
  CartPageState parent;
  bool isTakeAwayScreen;

  @override
  CartScreenState createState() => CartScreenState(restaurant, parent, isTakeAwayScreen);
}

class CartScreenState extends State<CartScreen> {
  String title;
  String category;
  String description;
  String price;
  String discount;
  CartPageState parent;
  final FilteredStores restaurant;
  GlobalKey<ScaffoldState> _scaffoldStateKey = GlobalKey();
  GlobalKey<TotalPriceState> totalPriceKey;
  List<TotalPrice> totalPrices;
  double total;
  bool delete = false;
  bool isTakeAwayScreen;


  CartScreenState(this.restaurant, this.parent, this.isTakeAwayScreen);

  _buildList() {
    if(currentUser.cartModel == null
        || currentUser.cartModel.items == null
          || currentUser.cartModel.items.length == 0){
      return Container();
    }
    return Expanded(
      child: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: currentUser.cartModel.items.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index < currentUser.cartModel.items.length) {
            Item order = currentUser.cartModel.items[index];
            return Dismissible(
              key: Key(currentUser.cartModel.items[index].product.uuid),
              background: Container(
                  alignment: AlignmentDirectional.centerEnd,
                  color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: SvgPicture.asset('assets/svg_images/del_basket.svg'),
                  )
              ),
              onDismissed: (direction) async {
                AmplitudeAnalytics.analytics.logEvent('remove_from_cart ', eventProperties: {
                  'uuid': currentUser.cartModel.items[index].product.uuid
                });
                await deleteItemFromCart(necessaryDataForAuth.device_id, currentUser.cartModel.items[index].id);
                currentUser.cartModel.items.removeAt(index);
                setState(() {
                  if(parent.totalPriceWidget.key.currentState != null){
                    parent.totalPriceWidget.key.currentState.setState(() {

                    });
                  }
                });
                if (currentUser.cartModel.items.length == 0) {
                  Navigator.pushReplacement(
                    context,
                    new MaterialPageRoute(
                      builder: (context) =>
                      new EmptyCartScreen(restaurant: restaurant),
                    ),
                  );
                }
              },
              direction: DismissDirection.endToStart,
              child: Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                child: _buildCartItem(order, index),
              ),
            );
          }
          return Padding(
              padding: EdgeInsets.all(15.0),
              child: Column(
                children: <Widget>[
                  (isTakeAwayScreen) ? Container() : Container(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: [
                              Text(
                                'Доставка',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    color: Color(0xFF000000)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0, top: 5),
                                child: Text(
                                  (currentUser.cartModel.cookingTime != null)? '~' + '${currentUser.cartModel.cookingTime ~/ 60} мин' : '',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            (currentUser.cartModel.deliveryPrice != null)? '~' + '${currentUser.cartModel.deliveryPrice} \₽' : '',
                            style: TextStyle(
                                fontSize: 18.0,
                                color: Color(0xFF000000)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20, top: 20),
                    child: Divider(
                      height: 1,
                      color: Color(0xFFE6E6E6),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Итого',
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Color(0xFF000000)),
                        ),
                        Text((currentUser.cartModel.totalPrice != null)? '~' + '${currentUser.cartModel.totalPrice} \₽' : '')
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20, top: 20),
                    child: Divider(
                      height: 1,
                      color: Color(0xFFE6E6E6),
                    ),
                  ) ,
                  SizedBox(height: 80.0)
                ],
              ));
        },
        separatorBuilder: (BuildContext context, int index) {
          return Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Divider(
                height: 1,
                color: Color(0xFFE6E6E6),
              )
          );
        },
      ),
    );
  }

  _buildCartItem(Item order, int index) {
    GlobalKey<CounterState> counterKey = new GlobalKey();
    GlobalKey<PriceFieldState> priceFieldKey =
    new GlobalKey<PriceFieldState>();
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      child: Stack(
        children: [
          // Align(
          //   alignment: Alignment.topLeft,
          //   child: ClipRRect(
          //     borderRadius: BorderRadius.only(
          //         bottomLeft: Radius.circular(10),
          //         topLeft: Radius.circular(10),
          //         topRight: Radius.circular(10),
          //         bottomRight: Radius.circular(10)),
          //     child: Image.network(
          //       getImage((order.product.meta.images != null && order.product.meta.images.length != 0) ? order.product.meta.images[0] : null ),
          //       fit: BoxFit.cover,
          //       height: 70,
          //       width: 70,
          //     ),),
          // ),
          Padding(
            padding: EdgeInsets.only(left: 85),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      order.product.name,
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 14.0,
                          color: Color(0xFF000000)),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                (order.variantGroups != null)
                    ? Container(
                      child: Column(
                  children: List.generate(
                        order.variantGroups.length,
                            (index){
                          return Column(
                              children: List.generate(
                                  order.variantGroups[index].variants.length,
                                      (variantsIndex){
                                    return Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom: 0.0),
                                        child: Text(order.variantGroups[index].variants[variantsIndex].name,
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 10
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                              )
                          );
                        }
                  ),
                ),
                    ) : Container(height: 0,),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Counter(
                          key: counterKey,
                          priceFieldKey: priceFieldKey,
                          order: order,
                          totalPriceList: totalPrices,
                          parent: this,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5, right: 2),
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
                                                width: 700,
                                                child: Center(
                                                  child: Text("Удалить",
                                                    style: TextStyle(
                                                        color: Color(0xFFFF3B30),
                                                        fontSize: 20
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              onTap: () async {
                                                currentUser.cartModel = await deleteItemFromCart(necessaryDataForAuth.device_id, order.id);
                                                Navigator.pop(context);
                                                setState(() {
                                                  // if(parent.totalPriceWidget.key.currentState != null){
                                                  //   parent.totalPriceWidget.key.currentState.setState(() {
                                                  //
                                                  //   });
                                                  // }
                                                });
                                                if (currentUser.cartModel.items.length == 0) {
                                                  Navigator.pushReplacement(
                                                    context,
                                                    new MaterialPageRoute(
                                                      builder: (context) =>
                                                      new EmptyCartScreen(restaurant: restaurant),
                                                    ),
                                                  );
                                                }
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
                                                  width: 700,
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
                                showDialog(
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
                                                      child: Text("Удалить",
                                                        style: TextStyle(
                                                            color: Color(0xFFFF3B30),
                                                            fontSize: 20
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  onTap: () async {
                                                    currentUser.cartModel = await deleteItemFromCart(necessaryDataForAuth.device_id, order.id);
                                                    Navigator.pop(context);
                                                    setState(() {
                                                      // if(parent.totalPriceWidget.key.currentState != null){
                                                      //   parent.totalPriceWidget.key.currentState.setState(() {
                                                      //
                                                      //   });
                                                      // }
                                                    });
                                                    if (currentUser.cartModel.items.length == 0) {
                                                      Navigator.pushReplacement(
                                                        context,
                                                        new MaterialPageRoute(
                                                          builder: (context) =>
                                                          new EmptyCartScreen(restaurant: restaurant),
                                                        ),
                                                      );
                                                    }
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
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Column(
              children: [
                PriceField(key: priceFieldKey, order: order),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    totalPrices = new List<TotalPrice>();
    totalPrices.add(new TotalPrice(key: new GlobalKey(),));
    totalPrices.add(new TotalPrice(key: new GlobalKey(),));
    totalPrices.add(parent.totalPriceWidget);
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => RestaurantScreen(restaurant: restaurant,)),
                (Route<dynamic> route) => route.isFirst);
        return false;
      },
      child: new Scaffold(
        key: _scaffoldStateKey,
        body: Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                _buildList(),
              ],
            )),
      ),
    );
  }
}