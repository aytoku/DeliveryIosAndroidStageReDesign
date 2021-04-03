import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/Screens/ChatScreen/View/chat_screen.dart';
import 'package:flutter_app/Screens/HomeScreen/Bloc/restaurant_get_bloc.dart';
import 'package:flutter_app/Screens/HomeScreen/View/home_screen.dart';
import 'package:flutter_app/Screens/OrdersScreen/API/cancel_order.dart';
import 'package:flutter_app/Screens/OrdersScreen/Model/OrdersDetailsModel.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'dart:io' show Platform;

class OrdersDetailsScreen extends StatefulWidget {
  final OrderDetailsModelItem ordersDetailsModelItem;

  OrdersDetailsScreen({Key key, this.ordersDetailsModelItem}) : super(key: key);

  @override
  OrdersDetailsScreenState createState() =>
      OrdersDetailsScreenState(ordersDetailsModelItem);
}

class OrdersDetailsScreenState extends State<OrdersDetailsScreen> {
  final OrderDetailsModelItem ordersDetailsModelItem;

  bool status1 = false;
  var processing = ['created'
  ];
  var cooking_state = [
    'cooking',
    'ready'
  ];
  var in_the_way = ['delivery'];

  Map<String,String> statusIcons = {
    'cooking':'assets/svg_images/bell.svg',
    'ready':'assets/svg_images/bell.svg',
    'delivery':'assets/svg_images/car.svg',
    'created':'assets/svg_images/state_clock.svg',
    'cancelled':'assets/svg_images/order_cancel.svg',
    'finished':'assets/svg_images/delivered.svg',
  };

  Map<String,String> statusTitles = {
    'cooking':'Готовится',
    'ready':'Готовится',
    'delivery':'В пути',
    'created':'Обработка',
    'cancelled' : "Отменен",
    'finished' : "Доставлен"
  };


  OrdersDetailsScreenState(this.ordersDetailsModelItem);


  showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          child: Container(
              height: 150,
              width: 320,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 10, top: 20, bottom: 20, right: 10),
                    child: Center(
                      child: Text(
                        'Отмена заказа',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF424242)),
                      ),
                    ),
                  ),
                  Center(
                    child: SpinKitThreeBounce(
                      color: AppColor.mainColor,
                      size: 20.0,
                    ),
                  ),
                ],
              )),
        );
      },
    );
  }

  showNoCancelAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).pop(true);
        });
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          child: Container(
              height: 100,
              width: 320,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 15, top: 20, bottom: 20, right: 15),
                    child: Text(
                      'Вы не можете отменить заказ',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF424242)),
                    ),
                  ),
                ],
              )),
        );
      },
    );
  }


  List<Widget> _buildListItems(){
    double totalPrice = ordersDetailsModelItem.totalPrice.toDouble();
    var format = new DateFormat('  HH:mm    dd.MM.yyyy');
    List<Widget> result = new List<Widget>();
    if(ordersDetailsModelItem == null || ordersDetailsModelItem.items == null){
      return List<Container>();
    }
    result.add(Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 14, bottom: 10, top: 15),
      child: Container(
        height: 190,
        padding: EdgeInsets.only(right: 10, left: 15),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4.0, // soften the shadow
                spreadRadius: 1.0, //extend the shadow
              )
            ],
            color: AppColor.themeColor,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(width: 1.0, color: Colors.grey[200])),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    (ordersDetailsModelItem.storeData != null)
                        ? ordersDetailsModelItem.storeData.name
                        : 'Пусто',
                    style: TextStyle(fontSize: 18, color: Color(0xFF000000)),
                  ),
                  Text(
                    '${ordersDetailsModelItem.totalPrice.toStringAsFixed(0)} \₽',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: SvgPicture.asset('assets/svg_images/clock.svg'),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 0, top: 0, right: 15),
                          child: Text(
                            format.format(ordersDetailsModelItem.createdAt),
                            style: TextStyle(fontSize: 12, color: Color(0xFFB0B0B0)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Text(statusTitles[ordersDetailsModelItem.state],
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 5),
                        child: SvgPicture.asset(statusIcons[ordersDetailsModelItem.state]),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 0, right: 0),
              child: Divider(color: Color(0xFFE6E6E6),),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Адрес доставки',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF3F3F3F),),
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10, right: 0),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      (ordersDetailsModelItem.deliveryAddress != null)
                          ?  ordersDetailsModelItem.deliveryAddress.unrestrictedValue
                          : 'Пусто',
                      style: TextStyle(fontSize: 12, color: Color(0xFFB0B0B0),),
                      textAlign: TextAlign.start,
                    )
                )
            ),
            // Align(
            //   alignment: Alignment.centerLeft,
            //   child: (in_the_way
            //       .contains(ordersStoryModelItem.state)) ? Padding(
            //     padding: EdgeInsets.only(right: 0, bottom: 5, left: 0),
            //     child: Text('Курьер на' + ' ' + ordersStoryModelItem.driver.color + ' ' + ordersStoryModelItem.driver.car + ' ' + ordersStoryModelItem.driver.regNumber,
            //       style: TextStyle(color: Color(0xFF000000), fontSize: 14, fontWeight: FontWeight.w500)),
            //   ) : Container(height: 0),
            // ),
            // (in_the_way.contains(ordersDetailsModelItem.state)) ? GestureDetector(
            //   child: Padding(
            //       padding: EdgeInsets.only(top: 10, bottom: 10, left: 0, right: 0),
            //       child: Container(
            //         width: MediaQuery.of(context).size.width,
            //         height: 42,
            //         decoration: BoxDecoration(
            //             borderRadius: BorderRadius.all(Radius.circular(10)),
            //             color: Color(0xFFF6F6F6)),
            //         child: Padding(
            //           padding: EdgeInsets.only(top: 5, right: 10, bottom: 5, left: 10),
            //           child: Stack(
            //             children: <Widget>[
            //               Padding(
            //                 padding: EdgeInsets.only(left: 75, top: 5),
            //                 child: SvgPicture.asset('assets/svg_images/message_icon.svg'),
            //               ),
            //               Padding(
            //                 padding: EdgeInsets.only(right: 20, top: 3, left: 110),
            //                 child: Text(
            //                   'Чат с курьером',
            //                   style: TextStyle(
            //                     fontSize: 18,
            //                   ),
            //                 ),
            //               ),
            //               FutureBuilder(future: ordersDetailsModelItem.hasNewMessage(),
            //                 builder: (BuildContext context, AsyncSnapshot snapshot) {
            //                   if(snapshot.connectionState == ConnectionState.done && snapshot.data){
            //                     return Align(
            //                       alignment: Alignment.topRight,
            //                       child: Padding(
            //                         padding: EdgeInsets.only(right: 189, bottom: 0),
            //                         child: SvgPicture.asset('assets/svg_images/chat_circle.svg'),
            //                       ),
            //                     );
            //                   }
            //                   return Container(height: 0);
            //                 },
            //               ),
            //             ],
            //           ),
            //         ),
            //       )
            //   ),
            //   onTap: (){
            //     Navigator.pushReplacement(
            //       context,
            //       new MaterialPageRoute(
            //         builder: (context) => new ChatScreen(order_uuid: ordersDetailsModelItem.uuid, key: chatKey),
            //       ),
            //     );
            //   },
            // ):
            // Container(height: 0,),
          ],
        ),
      ),
    ));
    ordersDetailsModelItem.items.forEach((item) {
      result.add(Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10, left: 15),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      child: Image.network(
                        getImage((item.product.meta.images == null || item.product.meta.images.length == 0) ? '' : item.product.meta.images[0]),
                        fit: BoxFit.cover,
                        height: 70,
                        width: 70,
                      ),),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 100, right: 60),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              item.product.name,
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontSize: 14.0,
                                  color: Color(0xFF000000)),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                        (item.variantGroups != null)
                            ? Container(
                          child: Column(
                            children: List.generate(
                                item.variantGroups.length,
                                    (index){
                                  return Column(
                                      children: List.generate(
                                          item.variantGroups[index].variants.length,
                                              (variantsIndex){
                                            return Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding: const EdgeInsets.only(bottom: 0.0),
                                                child: Text(item.variantGroups[index].variants[variantsIndex].name,
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
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 15),
                            child: Text(
                              '${(item.totalItemPrice.toStringAsFixed(0))} \₽',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 18),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: EdgeInsets.only(left: 0, right: 16, top: 30),
                            child: Text(
                              '${item.count}шт',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
          ),
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Divider(color: Color(0xFFE6E6E6)),
          ),
        ],
      ));
    });
    double own_delivery_price = ordersDetailsModelItem.totalPrice * 1.0;
    (ordersDetailsModelItem.ownDelivery != null && ordersDetailsModelItem.ownDelivery) ? result.add(Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 15, bottom: 20, top: 10),
              child: Text(
                'Итого',
                style: TextStyle(
                    fontSize: 18.0,
                    color: Color(0xFF000000)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 15, bottom: 20),
              child: Text('${own_delivery_price.toStringAsFixed(0)} \₽',
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Color(0xFF000000))),
            )
          ],
        ),
        Container(height: 10, color: Color(0xF3F3F3F3),),
        Padding(
            padding: EdgeInsets.only(left: 15, top: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Доставка оплачивается отдельно",
                  style: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 14),
                ),
              ],
            )
        ),
        Container(
          height: MediaQuery.of(context).size.height,
        )
      ],
    ),) : result.add(Column(
      children: [
        Padding(
            padding: EdgeInsets.only(left: 15, top: 10, bottom: 10, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Доставка",
                  style: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 18),
                ),
                Padding(
                  padding: EdgeInsets.only(),
                  child: Text(
                    (ordersDetailsModelItem.deliveryPrice.toStringAsFixed(0)).toString() + ' \₽',
                    style: TextStyle(
                        color: Colors.black, fontSize: 18),
                  ),
                ),
              ],
            )
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 15, bottom: 20, top: 10),
              child: Text(
                'Итого',
                style: TextStyle(
                    fontSize: 18.0,
                    color: Color(0xFF000000)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 15, bottom: 20),
              child: Text('${totalPrice.toStringAsFixed(0)} \₽',
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Color(0xFF000000))),
            )
          ],
        )
      ],
    ),);

    return result;
  }


  callTo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(bottom: 0),
          child: Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            child: Container(
                height: 190,
                width: 315,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                      child: Center(
                        child: Text(
                          'Кому вы хотите позвонить?',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF424242)),
                        ),
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                    InkWell(
                      child: Container(
                        child: Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 20),
                            child: Center(
                              child: Text(
                                'В заведение',
                                style: TextStyle(
                                    fontSize: 17, color: Color(0xFF424242)),
                              ),
                            ),
                        ),
                      ),
                      onTap: () {
                        // launch("tel://" + ordersDetailsModelItem.storeData.phone);
                      },
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                    InkWell(
                      child: Container(
                        child: Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 20),
                            child: Center(
                              child: Text(
                                'Водителю',
                                style: TextStyle(
                                    fontSize: 17, color: Color(0xFF424242)),
                              ),
                            ),
                        ),
                      ),
                      onTap: () {
                        // launch("tel://" + ordersDetailsModelItem.driver.phone);
                      },
                    )
                  ],
                )),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    double totalPrice = 134;
    var state_array = [
      'created',
      'cooking',
      'ready',
      'delivery',
    ];
    var not_cancel_state = [
      'cooking',
      'ready',
      'delivery',
    ];
    // TODO: implement build
    return Scaffold(
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 30, bottom: 10),
              child: Row(
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: InkWell(
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                              height: 40,
                              width: 60,
                              child: Padding(
                                padding:
                                EdgeInsets.only(top: 12, bottom: 12, right: 10),
                                child:  SvgPicture.asset(
                                    'assets/svg_images/arrow_left.svg'),
                              ))),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Flexible(
                    flex: 6,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(right: 40),
                        child: Text(
                          "Детали заказа",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3F3F3F)),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: Divider(height: 1.0, color: Colors.grey),
            ),
            Expanded(
              child: ListView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
                children: _buildListItems(),
              ),
            ),
            Center(
              child: Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 15, right: 10, left: 10),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: (!state_array.contains(ordersDetailsModelItem.state)) ?
                    Container()
                    // GestureDetector(
                    //   child: Container(
                    //       height: 50,
                    //       width: 300,
                    //       decoration: BoxDecoration(
                    //         color: Color(0xFF09B44D),
                    //         borderRadius: BorderRadius.circular(10.0),
                    //       ),
                    //       child: Center(
                    //         child: Text(
                    //           'Повторить заказ',
                    //           style: TextStyle(
                    //             color: Colors.white,
                    //             fontSize: 18,),
                    //         ),
                    //       )),
                    //   onTap: () async {
                    //     // if (await Internet.checkConnection()) {
                    //     //   Records restaurant = ordersStoryModelItem.productsData.store;
                    //     //   currentUser.cartDataModel.cart.clear();
                    //     //   ordersStoryModelItem.productsData.products
                    //     //       .forEach((Product element) {
                    //     //     FoodRecords foodItem =
                    //     //     FoodRecords.fromFoodRecordsStory(element);
                    //     //     Order order = new Order(
                    //     //         restaurant: restaurant,
                    //     //         food: foodItem,
                    //     //         date: DateTime.now().toString(),
                    //     //         quantity: element.number,
                    //     //         isSelected: false);
                    //     //     currentUser.cartDataModel.cart.add(order);
                    //     //   });
                    //     //   Navigator.push(
                    //     //     context,
                    //     //     new MaterialPageRoute(builder: (context) {
                    //     //       return new CartPageScreen(restaurant: restaurant);
                    //     //     }),
                    //     //   );
                    //     // } else {
                    //     //   noConnection(context);
                    //     // }
                    //   },
                    // )

                        : (!not_cancel_state.contains(ordersDetailsModelItem.state)) ?  GestureDetector(
                      child: Container(
                          height: 50,
                          width: 340,
                          decoration: BoxDecoration(
                            color: Color(0xFFFE534F),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Center(
                            child: Text(
                              'Отменить заказ',
                              style: TextStyle(
                                color: AppColor.textColor,
                                fontSize: 18,),
                            ),
                          )),
                      onTap: () async {
                        if (await Internet.checkConnection()) {
                          if(Platform.isIOS){
                            return showDialog(
                                context: context,
                                builder: (BuildContext context){
                                  return Padding(
                                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.62),
                                    child: CupertinoActionSheet(
                                      title: Padding(
                                        padding: EdgeInsets.only(top: 10, bottom: 10),
                                        child: Text('Вы действительно хотите отменить заказ?',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black
                                          ),
                                        ),
                                      ),
                                      actions: [
                                        CupertinoActionSheetAction(
                                          child: Text("Отменить заказ",
                                            style: TextStyle(
                                                color: Color(0xFFFF3B30),
                                                fontSize: 20
                                            ),
                                          ),
                                          onPressed: () async {
                                            showAlertDialog(context);
                                            await cancelOrder(ordersDetailsModelItem.uuid);
                                            homeScreenKey = new GlobalKey();
                                            Navigator.of(context).pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                    builder: (context) => BlocProvider(
                                                      create: (context) => RestaurantGetBloc(),
                                                      child: new HomeScreen(),
                                                    )),
                                                    (Route<dynamic> route) => false);
                                          },
                                        ),
                                      ],
                                      cancelButton: CupertinoActionSheetAction(
                                        child: Text("Вернуться назад",
                                          style: TextStyle(
                                              color: Color(0xFF007AFF),
                                              fontSize: 20
                                          ),
                                        ),
                                        onPressed: (){
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  );
                                }
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
                                        height: 210,
                                        width: 300,
                                        child: Column(
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(top: 15, bottom: 15),
                                              child: Center(
                                                child: Text('Вы действительно хотите отменить заказ?',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.black
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            Divider(
                                              height: 1,
                                              color: Colors.grey,
                                            ),
                                            InkWell(
                                              child: Container(
                                                padding: EdgeInsets.only(top: 20, bottom: 20),
                                                child: Center(
                                                  child: Text("Отменить заказ",
                                                    style: TextStyle(
                                                        color: Color(0xFFFF3B30),
                                                        fontSize: 20
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              onTap: () async {
                                                showAlertDialog(context);
                                                await cancelOrder(ordersDetailsModelItem.uuid);
                                                homeScreenKey = new GlobalKey();
                                                Navigator.of(context).pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (context) => BlocProvider(
                                                          create: (context) => RestaurantGetBloc(),
                                                          child: new HomeScreen(),
                                                        )),
                                                        (Route<dynamic> route) => false);
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
                                                  child: Text("Вернуться назад",
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
                        } else {
                          noConnection(context);
                        }
                      },
                    ): (in_the_way.contains(ordersDetailsModelItem.state)) ? Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 10, bottom: 0, right: 5, left: 5),
                            child: (in_the_way.contains(ordersDetailsModelItem.state))
                                ? Container(
                              height: 52,
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(11)),
                                  color: AppColor.mainColor),
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 5, right: 0, bottom: 5, left: 0),
                                  child:  Center(
                                    child: Text(
                                      'Позвонить',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: AppColor.textColor
                                      ),
                                    ),
                                  )
                              ),
                            )
                                : Container(),
                          ),
                          onTap: () {
                            if(Platform.isIOS){
                              return showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Padding(
                                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.55),
                                    child: CupertinoActionSheet(
                                      title: Padding(
                                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                                        child: Text('Кому вы хотите позвонить?',
                                          style: TextStyle(
                                              fontSize: 20,
                                            color: Colors.black
                                          ),
                                        ),
                                      ),
                                      actions: [
                                        CupertinoActionSheetAction(
                                          child: Text("В заведение",
                                            style: TextStyle(
                                                color: Color(0xFF007AFF),
                                                fontSize: 20
                                            ),
                                          ),
                                          onPressed: () async {
                                            // launch("tel://" + ordersDetailsModelItem.productsData.store.phone);
                                          },
                                        ),
                                        CupertinoActionSheetAction(
                                          child: Text("Водителю",
                                            style: TextStyle(
                                                color: Color(0xFF007AFF),
                                                fontSize: 20
                                            ),
                                          ),
                                          onPressed: () async {
                                            // launch("tel://" + ordersDetailsModelItem.driver.phone);
                                          },
                                        ),
                                      ],
                                      cancelButton: CupertinoActionSheetAction(
                                        child: Text("Отмена",
                                          style: TextStyle(
                                              color: Color(0xFFDC634A),
                                              fontSize: 20
                                          ),
                                        ),
                                        onPressed: (){
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                            callTo(context);
                          },
                        )) : Container(),
                  )),
            ),
            // Center(
            //   child: Padding(
            //       padding: EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 10),
            //       child: Align(
            //         alignment: Alignment.bottomCenter,
            //         child: (!state_array.contains(ordersDetailsModelItem.state)) ? GestureDetector(
            //           child: Container(
            //               height: 50,
            //               width: 350,
            //               decoration: BoxDecoration(
            //                 color: Color(0xFFDC634A),
            //                 borderRadius: BorderRadius.circular(10.0),
            //               ),
            //               child: Center(
            //                 child: Text(
            //                   'Удалить данные о заказе',
            //                   style: TextStyle(
            //                     color: Colors.white,
            //                     fontSize: 18,),
            //                 ),
            //               )),
            //         ) : Container(height: 0,),
            //       )),
            // )
          ],
        ));
  }
}