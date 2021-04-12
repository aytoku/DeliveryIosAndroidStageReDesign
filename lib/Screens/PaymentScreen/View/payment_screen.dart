import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Config/config.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/Screens/AuthScreen/View/auth_screen.dart';
import 'package:flutter_app/Screens/HomeScreen/Bloc/restaurant_get_bloc.dart';
import 'package:flutter_app/Screens/HomeScreen/View/home_screen.dart';
import 'package:flutter_app/Screens/OrderConfirmationScreen/Model/PaymentMethod.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class PaymentScreen extends StatefulWidget {
  @override
  PaymentScreenState createState() => PaymentScreenState();
}

class PaymentScreenState extends State<PaymentScreen> {

  bool isSelected = false;
  bool change = false;
  List<PaymentMethod> paymentMethods;
  PaymentMethod selectedPaymentMethod;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    paymentMethods = [
      PaymentMethod(
        name: "Наличными",
        image: "assets/svg_images/dollar_bills.svg",
        tag: "cash",
        outputTag: "cash"
      ),
      PaymentMethod(
          name: (Platform.isIOS) ? "ApplePay" : "GooglePay",
          image: (Platform.isIOS) ? "assets/svg_images/apple_pay.svg"
          : "assets/svg_images/google_pay.svg",
          tag: "virtualCardPayment",
          outputTag: "card"
      ),
    ];
    // paymentMethods = [
    //   {
    //     "name": "Наличными",
    //     "image": "assets/svg_images/dollar_bills.svg",
    //     "tag": "cash"
    //   },
    //   {
    //     "name": (Platform.isIOS) ? "ApplePay" : "GooglePay",
    //     "image": (Platform.isIOS) ? "assets/svg_images/apple_pay.svg"
    //         : "assets/svg_images/google_pay.svg",
    //     "tag": "virtualCardPayment"
    //   },
    // ];
    selectedPaymentMethod = necessaryDataForAuth.selectedPaymentMethod;
  }

  void addPaymentCard() {
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
            height: 370,
            child: buildAddPaymentCardBottomNavigationMenu(),
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                )),
          );
        });
  }

  buildAddPaymentCardBottomNavigationMenu() {
    return Container(
      decoration: BoxDecoration(
          color: AppColor.themeColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
          )),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 15, right: 15),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 218,
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
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30, left: 15, bottom: 5),
                      child: Text('Номер карты',
                        style: TextStyle(
                            color: AppColor.additionalTextColor,
                            fontSize: 14
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 20,
                    child: Padding(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: TextField(
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.number,
                        maxLength: 16,
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          counterText: '',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, left: 15, right: 15),
                    child: Divider(height: 1.0, color: Color(0xFFEDEDED)),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 30, left: 0, bottom: 5),
                                    child: Text('Срок действия',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 20,
                                    width: 110,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 5, right: 0),
                                      child: TextField(
                                        textCapitalization: TextCapitalization.sentences,
                                        keyboardType: TextInputType.number,
                                        maxLength: 5,
                                        decoration: new InputDecoration(
                                          border: InputBorder.none,
                                          counterText: '',
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0, left: 15, right: 15),
                                    child: Container(
                                        width: 100,
                                        child: Divider(height: 1.0, color: Color(0xFFEDEDED))),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 30, right: 60, bottom: 5),
                                    child: Text('CVV',
                                      style: TextStyle(
                                          color: AppColor.additionalTextColor,
                                          fontSize: 14
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 20,
                                    width: 110,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 5, right: 0),
                                      child: TextField(
                                        textCapitalization: TextCapitalization.sentences,
                                        keyboardType: TextInputType.number,
                                        maxLength: 3,
                                        decoration: new InputDecoration(
                                          border: InputBorder.none,
                                          counterText: '',
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0, left: 15, right: 15),
                                    child: Container(
                                        width: 100,
                                        child: Divider(height: 1.0, color: Color(0xFFEDEDED))),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(left:15, right: 15, top: 15, bottom: 15),
                child: InkWell(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 52,
                    decoration: BoxDecoration(
                        color: Color(0xFF09B44D),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(
                      child: Text('Добавить карту',
                        style: TextStyle(
                            fontSize: 16,
                            color: AppColor.textColor
                        ),
                      ),
                    ),
                  ),
                  onTap: (){
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Column(
          children: <Widget>[
            Container(
              height: 88,
              padding: EdgeInsets.only(top: 40),
              decoration: BoxDecoration(
                color: AppColor.themeColor,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5.0,
                      offset: Offset(0, 1)
                  )
                ],
              ),
              child: Stack(
                children: <Widget>[
                  InkWell(
                    child: Padding(
                        padding: EdgeInsets.only(),
                        child: Container(
                            height: 40,
                            width: 50,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 12, bottom: 12, right: 0),
                              child: SvgPicture.asset(
                                  'assets/svg_images/arrow_left.svg'),
                            ))),
                    onTap: () async {
                      if (await Internet.checkConnection()) {
                        homeScreenKey = new GlobalKey<HomeScreenState>();
                        Navigator.of(context).pushAndRemoveUntil(
                            PageRouteBuilder(
                                pageBuilder: (context, animation, anotherAnimation) {
                                  return BlocProvider(
                                    create: (context) => RestaurantGetBloc(),
                                    child: new HomeScreen(),
                                  );
                                },
                                transitionDuration: Duration(milliseconds: 300),
                                transitionsBuilder:
                                    (context, animation, anotherAnimation, child) {
                                  return SlideTransition(
                                    position: Tween(
                                        begin: Offset(1.0, 0.0),
                                        end: Offset(0.0, 0.0))
                                        .animate(animation),
                                    child: child,
                                  );
                                }
                            ), (Route<dynamic> route) => false);
                      } else {
                        noConnection(context);
                      }
                    },
                  ),
                  Center(
                    child: Text(
                      "Способы оплаты",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(right: 20),
                  //   child: Align(
                  //     alignment: Alignment.centerRight,
                  //     child: InkWell(
                  //       child: Text(
                  //         (!change) ? "Изменить" : "Готово",
                  //         style: TextStyle(
                  //             fontSize: 14),
                  //       ),
                  //       onTap: (){
                  //         setState(() {
                  //           change = !change;
                  //         });
                  //       },
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15, top: 15, bottom: 15),
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(right: 15, left: 15, bottom: 30, top: 30),
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
                    children: [
                      Container(
                        height: 110,
                        child: ListView(
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.zero,
                          children: List.generate(paymentMethods.length, (index){
                            return Column(
                              children: [
                                InkWell(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      children: [
                                        Flexible(
                                            flex: 1,
                                            child: SvgPicture.asset(paymentMethods[index].image)),
                                        Flexible(
                                          flex: 7,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left: 20),
                                                child: Text(paymentMethods[index].name),
                                              ),
                                              (selectedPaymentMethod == paymentMethods[index]) ?
                                              SvgPicture.asset('assets/svg_images/home_selected_item.svg')
                                                  :
                                              SvgPicture.asset('assets/svg_images/home_unselected_item.svg'),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () async{
                                    setState(() {
                                      selectedPaymentMethod = paymentMethods[index];
                                    });
                                    necessaryDataForAuth.selectedPaymentMethod = selectedPaymentMethod;
                                    await NecessaryDataForAuth.saveData();
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20, left: 60, bottom: 20),
                                  child: Divider(color: Color(0xFFC4C4C4), height: 1,),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 30),
                      //   child: Align(
                      //     alignment: Alignment.bottomCenter,
                      //     child: GestureDetector(
                      //       child: Container(
                      //         width: MediaQuery.of(context).size.width,
                      //         height: 48,
                      //         decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(10),
                      //             color: Color(0xFF09B44D)
                      //         ),
                      //         child: Center(
                      //             child: Text('Добавить карту',
                      //               style: TextStyle(
                      //                   color: AppColor.textColor,
                      //                   fontSize: 16
                      //               ),
                      //             )
                      //         ),
                      //       ),
                      //       onTap: (){
                      //         addPaymentCard();
                      //       },
                      //     ),
                      //   ),
                      // ),
                    ],
                  )
              ),
            ),
          ],
        ));
  }
}