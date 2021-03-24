import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/OrdersScreen/API/getClientsOrdersInProcess.dart';
import 'package:flutter_app/Screens/OrdersScreen/Model/OrdersDetailsModel.dart';
import 'package:flutter_app/Screens/OrdersScreen/View/orders_details.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OrderChecking extends StatefulWidget {
  OrderDetailsModelItem ordersDetailsItem;

  OrderChecking({Key key, this.ordersDetailsItem}) : super(key: key);
  static var state_array = [
    'created',
    'cooking',
    'ready',
    'delivery'
  ];

  @override
  OrderCheckingState createState() {
    return new OrderCheckingState(ordersDetailsItem);
  }

  static Future<List<OrderChecking>> getActiveOrder() async {
    List<OrderChecking> activeOrderList = new List<OrderChecking>();
    OrderDetailsModel initData = await getClientsOrdersInProcess();
    orderCheckingStates.clear();
    initData.orderDetailsModelItem
        .forEach((OrderDetailsModelItem element) {
      if (state_array.contains(element.state)) {
        print(element.uuid);
        GlobalKey<OrderCheckingState> key = new GlobalKey<OrderCheckingState>();
        orderCheckingStates[element.uuid] = key;
        activeOrderList.add(new OrderChecking(
          ordersDetailsItem: element,
          key: key,
        ));
      }
    });
    return activeOrderList;
  }
}

class OrderCheckingState extends State<OrderChecking> with AutomaticKeepAliveClientMixin {
  OrderDetailsModelItem ordersStoryModelItem;
  @override
  bool get wantKeepAlive => true;

  OrderCheckingState(this.ordersStoryModelItem);

  @override
  Widget build(BuildContext context) {
    var processing = ['created'
    ];
    var cooking_state = [
      'cooking',
      'ready'
    ];
    var in_the_way = ['delivery'];

    if (!OrderChecking.state_array.contains(ordersStoryModelItem.state)) {
      return Container();
    }
    return InkWell(
      hoverColor: Colors.white,
      focusColor: Colors.white,
      splashColor: Colors.white,
      highlightColor: Colors.white,
      child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4.0, // soften the shadow
                  spreadRadius: 1.0, //extend the shadow
                )
              ],
              color: AppColor.themeColor,
              borderRadius: BorderRadius.circular(17.0),
              border: Border.all(width: 1.0, color: AppColor.elementsColor)),
          child: Column(
            children: <Widget>[
              Flexible(
                child: Container(
                  margin: EdgeInsets.all(0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: 200,
                          padding: EdgeInsets.only(right: 15),
                          child: Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Align(
                              child: Text(
                                'Ваш заказ из ' +
                                    (ordersStoryModelItem.storeData != null
                                        ? ordersStoryModelItem.storeData.name
                                        : 'Пусто'),
                                style: TextStyle(
                                    fontSize: 16.0, fontWeight: FontWeight.bold, color: AppColor.textColor),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 25, left: 20, bottom: 0),
                          child: InkWell(
                            child: Container(
                              height: 30,
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                                  color: AppColor.subElementsColor),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 7, top: 7, bottom: 5),
                                    child: SvgPicture.asset('assets/svg_images/i.svg', color: AppColor.textColor,),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 10, right: 10, top: 7, bottom: 5),
                                      child: Text(
                                        'Заказ',
                                        style: TextStyle(
                                            color: AppColor.textColor, fontSize: 13),
                                      )),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) {
                                  return OrdersDetailsScreen(
                                      ordersDetailsModelItem: ordersStoryModelItem);
                                }),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 15, right: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 5, left: 5),
                        child: Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              color: AppColor.mainColor),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 15),
                                child: SvgPicture.asset(
                                    'assets/svg_images/white_clock.svg'),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text('Обработка',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10)),
                              )
                            ],
                          ),
                        ),
                      ),
                      (processing.contains(ordersStoryModelItem.state)) ? Center(
                        child: SpinKitThreeBounce(
                          color: AppColor.mainColor,
                          size: 20.0,
                        ),
                      ) : Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: SvgPicture.asset('assets/svg_images/ellipse.svg', color: AppColor.mainColor,),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: SvgPicture.asset('assets/svg_images/ellipse.svg', color: AppColor.mainColor,),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: SvgPicture.asset('assets/svg_images/ellipse.svg', color: AppColor.mainColor,),
                          ),
                        ],
                      ),
                      Padding(
                        padding: (ordersStoryModelItem.withoutDelivery) ? EdgeInsets.only(left: 20) : EdgeInsets.only(right: 5),
                        child: Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              color: (cooking_state
                                  .contains(ordersStoryModelItem.state) ||
                                  in_the_way.contains(ordersStoryModelItem.state))
                                  ? AppColor.mainColor
                                  : AppColor.subElementsColor),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 15),
                                child: (cooking_state
                                    .contains(ordersStoryModelItem.state) ||
                                    in_the_way.contains(ordersStoryModelItem.state))
                                    ? SvgPicture.asset(
                                    'assets/svg_images/white_bell.svg', color: AppColor.unselectedTextColor,)
                                    : SvgPicture.asset(
                                    'assets/svg_images/bell.svg', color: AppColor.textColor),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text('Готовится',
                                    style: (cooking_state
                                        .contains(ordersStoryModelItem.state) ||
                                        in_the_way.contains(ordersStoryModelItem.state))
                                        ? TextStyle(
                                        color: AppColor.unselectedTextColor, fontSize: 10)
                                        : TextStyle(
                                        color: AppColor.textColor,
                                        fontSize: 10)),
                              )
                            ],
                          ),
                        ),
                      ),
                      (cooking_state
                          .contains(ordersStoryModelItem.state)) ? Center(
                        child: SpinKitThreeBounce(
                          color: AppColor.mainColor,
                          size: 20.0,
                        ),
                      ) : Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: SvgPicture.asset('assets/svg_images/ellipse.svg', color: AppColor.mainColor,),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: SvgPicture.asset('assets/svg_images/ellipse.svg', color: AppColor.mainColor,),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: SvgPicture.asset('assets/svg_images/ellipse.svg', color: AppColor.mainColor,),
                          ),
                        ],
                      ),
                      (ordersStoryModelItem.withoutDelivery) ? Container() : Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              color: (in_the_way
                                  .contains(ordersStoryModelItem.state))
                                  ? AppColor.mainColor
                                  : AppColor.subElementsColor),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 18),
                                child: (in_the_way
                                    .contains(ordersStoryModelItem.state))
                                    ? SvgPicture.asset(
                                    'assets/svg_images/light_car.svg',
                                color: AppColor.unselectedTextColor,)
                                    : SvgPicture.asset(
                                    'assets/svg_images/car.svg', color: AppColor.textColor),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text('В пути',
                                    style: (in_the_way
                                        .contains(ordersStoryModelItem.state))
                                        ? TextStyle(
                                        color: AppColor.unselectedTextColor, fontSize: 10)
                                        : TextStyle(
                                        color: AppColor.textColor,
                                        fontSize: 10)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              (in_the_way.contains(ordersStoryModelItem.state) && ordersStoryModelItem.ownDelivery != null && ordersStoryModelItem.ownDelivery) ? Padding(
                  padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                  child: Text('Доставку осуществляет курьер от заведения',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14
                    ),
                  )
              ) :Container()
            ],
          )),
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) {
            return OrdersDetailsScreen(
                ordersDetailsModelItem: ordersStoryModelItem);
          }),
        );
      },
    );
  }
}