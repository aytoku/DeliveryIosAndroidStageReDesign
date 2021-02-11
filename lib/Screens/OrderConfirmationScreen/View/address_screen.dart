import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/Screens/CartScreen/View/cart_page_view.dart';
import 'package:flutter_app/Screens/HomeScreen/Model/FilteredStores.dart';
import 'package:flutter_app/Screens/HomeScreen/View/home_screen.dart';
import 'package:flutter_app/Screens/OrderConfirmationScreen/API/create_order.dart';
import 'package:flutter_app/Screens/OrderConfirmationScreen/Widgets/AddressSelector.dart';
import 'package:flutter_app/Screens/OrderConfirmationScreen/Widgets/DestinationPointsAddressSelector.dart';
import 'package:flutter_app/Screens/OrderConfirmationScreen/Widgets/OrderSuccessScreen.dart';
import 'package:flutter_app/Screens/OrderConfirmationScreen/Widgets/PromoText.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/models/InitialAddressModel.dart';
import 'package:flutter_app/models/my_addresses_model.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../data/data.dart';

class AddressScreen extends StatefulWidget {
  MyFavouriteAddressesModel addedAddress;
  List<MyFavouriteAddressesModel> myAddressesModelList;
  bool isTakeAwayOrderConfirmation;

  AddressScreen(
      {Key key, this.restaurant, this.addedAddress, this.myAddressesModelList, this.isTakeAwayOrderConfirmation})
      : super(key: key);
  final FilteredStores restaurant;

  @override
  AddressScreenState createState() =>
      AddressScreenState(restaurant, addedAddress, isTakeAwayOrderConfirmation, myAddressesModelList: myAddressesModelList);
}

class AddressScreenState extends State<AddressScreen>
    with AutomaticKeepAliveClientMixin {

  InitialAddressModel selectedAddress; // Последний выбранный адрес
  final FilteredStores restaurant;
  GlobalKey<DestinationPointsSelectorState> destinationPointsSelectorStateKey =
  GlobalKey();
  bool isTakeAwayOrderConfirmation;
  //CreateOrder createOrder;
  GlobalKey<CartPageState> cartPageKey = GlobalKey();

  List<MyFavouriteAddressesModel> myAddressesModelList;

  String cash_image = 'assets/svg_images/dollar_bills.svg';
  String card_image = 'assets/svg_images/visa.svg';
  String cash = 'Наличными';
  String card = 'Картой';
  int selectedPaymentId = 0;


  bool status1 = false;
  bool status2 = false;
  GlobalKey<ScaffoldState> _scaffoldStateKey = GlobalKey();
  TextEditingController commentField = new TextEditingController();
  TextEditingController officeField = new TextEditingController();
  TextEditingController intercomField = new TextEditingController();
  TextEditingController entranceField = new TextEditingController();
  TextEditingController floorField = new TextEditingController();
  GlobalKey<AddressSelectorState> addressSelectorKey = new GlobalKey();
  GlobalKey<PromoTextState> promoTextKey = new GlobalKey();

  TextEditingController phoneNumberController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController addressValueController;

  MyFavouriteAddressesModel addedAddress;


  AddressScreenState(this.restaurant, this.addedAddress, this.isTakeAwayOrderConfirmation, {this.myAddressesModelList});

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // addressValueController = TextEditingController(text: restaurant.destination_points[0].street + ' ' + restaurant.destination_points[0].house);
    // selectedAddress = restaurant.address[0];
  }

  showPaymentErrorAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(bottom: 0),
          child: Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            child: Container(
                height: 100,
                width: 320,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 15, top: 20, bottom: 20),
                      child: Text(
                        'Ошибка при оплате',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF424242)),
                      ),
                    ),
                    Center(
                      child: SpinKitFadingCircle(
                        color: Colors.green,
                        size: 50.0,
                      ),
                    )
                  ],
                )),
          ),
        );
      },
    );
  }

  _payment() {
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
            height: 100,
            child: _buildPaymentBottomNavigationMenu(),
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                )),
          );
        });
  }

  _buildPaymentBottomNavigationMenu() {
    return Container(
      height: 100,
      child: Column(
        children: [
          InkWell(
              child: Padding(
                padding: EdgeInsets.only(left: 20, bottom: 5, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SvgPicture.asset(cash_image),
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text(
                        cash,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 15),
                          child: (selectedPaymentId == 1) ? SvgPicture.asset('assets/svg_images/pay_circle.svg') : SvgPicture.asset('assets/svg_images/address_screen_selector.svg'),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              onTap: ()=>_selectItem("Наличными")
          ),
          InkWell(
              child: Padding(
                padding: EdgeInsets.only(left: 20, bottom: 5, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SvgPicture.asset(card_image),
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text(
                        card,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 15),
                          child: (selectedPaymentId == 0) ? SvgPicture.asset('assets/svg_images/pay_circle.svg') : SvgPicture.asset('assets/svg_images/address_screen_selector.svg'),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              onTap: ()=>_selectItem("Картой")
          ),
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(bottom: 0),
          child: Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            child: Container(
                height: 120,
                width: 320,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 10, top: 20, bottom: 20, right: 10),
                      child: Text(
                        'Отправляем ваш заказ в систему',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF424242)),
                      ),
                    ),
                    Center(
                      child: SpinKitThreeBounce(
                        color: Colors.green,
                        size: 20.0,
                      ),
                    ),
                  ],
                )),
          ),
        );
      },
    );
  }

  emptyFields(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(context).pop(true);
        });
        return Center(
          child: Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            child: Container(
              height: 50,
              width: 100,
              child: Center(
                child: Text("Введите адрес"),
              ),
            ),
          ),
        );
      },
    );
  }

  void _selectItem(String name) {
    Navigator.pop(context);
    setState(() {
      if(name.toLowerCase() == "наличными")
        selectedPaymentId = 0;
      else
        selectedPaymentId = 1;
    });
  }

  _cardPayment(double totalPrice){
    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => WebView(
              initialUrl: "https://delivery-stage.faem.ru/payment-widget.html?amount=$totalPrice",
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webController){
                Timer _timer;

                // Врубаем таймер
                const oneSec = const Duration(seconds: 1);
                _timer = new Timer.periodic(
                  oneSec, (Timer timer) async {
                  try{
                    // Получем текущий урл
                    String url = await webController.currentUrl();
                    print(url);

                    if(url == 'https://delivery-stage.faem.ru/payment-widget.html?status=success'){
                      _timer.cancel();
                      //await createOrder.sendData();
                      // currentUser.cartModel.cart.clear();
                      // currentUser.cartModel.saveData();
                      homeScreenKey = new GlobalKey<HomeScreenState>();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()),
                              (Route<dynamic> route) => false);
                      _timer.cancel();
                    }else if(url == 'https://delivery-stage.faem.ru/payment-widget.html?status=fail'){
                      Navigator.pop(context);
                      // Выводим ошибку
                      showPaymentErrorAlertDialog(context);
                      // Задержка окна
                      await Future.delayed(Duration(seconds: 2), () {
                        Navigator.of(context).pop(true);
                      });
                      _timer.cancel();
                    }

                  }
                  catch(e){
                    _timer.cancel();
                  }
                },
                );
              },
            ))
    );
  }

  void _dispatchAddress() {
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
            height: 300,
            child: _buildDispatchAddressBottomNavigationMenu(),
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                )),
          );
        });
  }

  _buildDispatchAddressBottomNavigationMenu() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
          )),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 15, top: 30, bottom: 35),
              child: Text('Адрес отправки',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
          // DestinationPointsSelector(
          //   destinationPoints: restaurant.destination_points,
          //   key: destinationPointsSelectorStateKey,
          // ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(left:15, right: 15, top: 15),
              child: InkWell(
                child: Container(
                  width: 380,
                  height: 60,
                  decoration: BoxDecoration(
                      color: Color(0xFF09B44D),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(
                    child: Text('Готово',
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
                onTap: (){
                  addressValueController.text = destinationPointsSelectorStateKey.currentState.selectedDestinationPoint.street + ' ' +
                      destinationPointsSelectorStateKey.currentState.selectedDestinationPoint.house;
                  selectedAddress = destinationPointsSelectorStateKey.currentState.selectedDestinationPoint;
                  Navigator.pop(context);
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildAddressesList(){
    if(myAddressesModelList != null){
      return Container(
          height: 220,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 20, left: 15, bottom: 15),
                  child: Text('Ваш адрес',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF424242))),
                ),
              ),
              buildAddressesListSelector(),
            ],
          )
      );
    }
    return Container(
      height: 160,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(top: 20, left: 15, bottom: 15),
              child: Text('Ваш адрес',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF424242))),
            ),
          ),
          FutureBuilder<List<MyFavouriteAddressesModel>>(
            future: MyFavouriteAddressesModel.getAddresses(),
            builder: (BuildContext context,
                AsyncSnapshot<List<MyFavouriteAddressesModel>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                myAddressesModelList = snapshot.data;
                myAddressesModelList
                    .add(new MyFavouriteAddressesModel(type: null));
                return buildAddressesListSelector();
              } else {
                return Center(
                  child: SpinKitThreeBounce(
                    color: Colors.green,
                    size: 20.0,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildAddressesListSelector(){
    return Expanded(
      child: AddressSelector(myFavouriteAddressList: myAddressesModelList, parent:  this, addressSelectorKey: addressSelectorKey),
    );
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FocusNode focusNode;
    double totalPrice = currentUser.cartModel.totalPrice + currentUser.cartModel.deliveryPrice * 1.0;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarBrightness: Brightness.light
      ),
      child: Scaffold(
        key: _scaffoldStateKey,
        resizeToAvoidBottomPadding: false,
        body:  Container(
            color: Colors.white,
            child:  Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05, bottom: 10),
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 0),
                          child: InkWell(
                            onTap: () => Navigator.of(context).push(
                                PageRouteBuilder(
                                    pageBuilder: (context, animation, anotherAnimation) {
                                      return CartPageScreen(restaurant: restaurant);
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
                                )),
                            child: Padding(
                                padding: EdgeInsets.only(right: 0),
                                child: Container(
                                    height: 40,
                                    width: 60,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: 12, bottom: 12, right: 20),
                                      child: SvgPicture.asset(
                                          'assets/svg_images/arrow_left.svg'),
                                    ))),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            "Подтверждение заказа",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF000000)),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      // Padding(
                      //   padding: EdgeInsets.only(
                      //       top: 10, left: 12, right: 12, bottom: 15),
                      //   child: (status2) ? Container(
                      //     decoration: BoxDecoration(
                      //         boxShadow: [
                      //           BoxShadow(
                      //               color: Colors.black12,
                      //               blurRadius: 2.0,
                      //               offset: Offset(0.0, 1)
                      //           )
                      //         ],
                      //         color: Color(0xFFF6F6F6),
                      //         borderRadius: BorderRadius.circular(10.0),
                      //         border: Border.all(width: 1.0, color: Colors.grey[200])),
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(10.0),
                      //       child: Column(
                      //         children: [
                      //           Container(
                      //             child: Row(
                      //               mainAxisAlignment:
                      //               MainAxisAlignment.spaceBetween,
                      //               children: <Widget>[
                      //                 Text(
                      //                   'Заказ другому человеку',
                      //                   style: TextStyle(
                      //                       color: Color(0xFF3F3F3F),
                      //                       fontSize: 15),
                      //                 ),
                      //                 Padding(
                      //                   padding: EdgeInsets.only(right: 0),
                      //                   child: FlutterSwitch(
                      //                     width: 55.0,
                      //                     height: 25.0,
                      //                     inactiveColor: Color(0xD6D6D6D6),
                      //                     activeColor: Colors.green,
                      //                     valueFontSize: 12.0,
                      //                     toggleSize: 18.0,
                      //                     value: status2,
                      //                     onToggle: (value) {
                      //                       setState(() {
                      //                         status2 = value;
                      //                       });
                      //                     },
                      //                   ),
                      //                 )
                      //               ],
                      //             ),
                      //           ),
                      //           Container(
                      //             height: 30,
                      //             child: TextField(
                      //               controller: phoneNumberController,
                      //               decoration: new InputDecoration(
                      //                 hintText: 'Номер телефона получателя',
                      //                 contentPadding: EdgeInsets.only(top: 5),
                      //                 hintStyle: TextStyle(
                      //                     fontSize: 14,
                      //                     color: Colors.grey
                      //                 ),
                      //                 border: InputBorder.none,
                      //               ),
                      //             ),
                      //           ),
                      //           Divider(color: Colors.grey,),
                      //           Container(
                      //             height: 30,
                      //             child: TextField(
                      //               controller: nameController,
                      //               decoration: new InputDecoration(
                      //                 contentPadding: EdgeInsets.only(top: 5),
                      //                 hintText: 'Имя получателя',
                      //                 hintStyle: TextStyle(
                      //                     fontSize: 14,
                      //                     color: Colors.grey
                      //                 ),
                      //                 border: InputBorder.none,
                      //                 counterText: '',
                      //               ),
                      //             ),
                      //           ),
                      //           Divider(color: Colors.grey,),
                      //         ],
                      //       ),
                      //     ),
                      //   ) : Container(
                      //     decoration: BoxDecoration(
                      //         boxShadow: [
                      //           BoxShadow(
                      //               color: Colors.black12,
                      //               blurRadius: 2.0,
                      //               offset: Offset(0.0, 1)
                      //           )
                      //         ],
                      //         color: Color(0xFFF6F6F6),
                      //         borderRadius: BorderRadius.circular(10.0),
                      //         border: Border.all(width: 1.0, color: Colors.grey[200])),
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(10.0),
                      //       child: Row(
                      //         mainAxisAlignment:
                      //         MainAxisAlignment.spaceBetween,
                      //         children: <Widget>[
                      //           Text(
                      //             'Заказ другому человеку',
                      //             style: TextStyle(
                      //                 color: Color(0xFF3F3F3F),
                      //                 fontSize: 15),
                      //           ),
                      //           Padding(
                      //             padding: EdgeInsets.only(right: 0),
                      //             child: FlutterSwitch(
                      //               width: 55.0,
                      //               height: 25.0,
                      //               inactiveColor: Color(0xD6D6D6D6),
                      //               activeColor: Colors.green,
                      //               valueFontSize: 12.0,
                      //               toggleSize: 18.0,
                      //               value: status2,
                      //               onToggle: (value) {
                      //                 setState(() {
                      //                   status2 = value;
                      //                 });
                      //               },
                      //             ),
                      //           )
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // Align(
                      //   alignment: Alignment.centerLeft,
                      //   child: Padding(
                      //     padding: EdgeInsets.only(left: 15, bottom: 15),
                      //     child: Text('Адрес отправки',
                      //         style: TextStyle(
                      //             fontSize: 18,
                      //             fontWeight: FontWeight.bold,
                      //             color: Color(0xFF424242))),
                      //   ),
                      // ),
                      // InkWell(
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(left: 15, right: 15),
                      //     child: Container(
                      //       height: 64,
                      //       decoration: BoxDecoration(
                      //           boxShadow: [
                      //             BoxShadow(
                      //                 color: Colors.black12,
                      //                 blurRadius: 2.0,
                      //                 offset: Offset(0.0, 1)
                      //             )
                      //           ],
                      //           color: Colors.white,
                      //           borderRadius: BorderRadius.circular(10.0),
                      //           border: Border.all(width: 1.0, color: Colors.grey[200])),
                      //       child: Column(
                      //         children: [
                      //           Padding(
                      //             padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                      //             child: Row(
                      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //               children: [
                      //                 Text('С какого адреса вам отправить?',
                      //                   style: TextStyle(
                      //                       fontSize: 12,
                      //                       color: Color(0xFFB8B8B8)
                      //                   ),
                      //                 ),
                      //                 Text('Изменить',
                      //                   style: TextStyle(
                      //                     fontSize: 12,
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //           Padding(
                      //             padding: const EdgeInsets.only(left: 15, top: 15),
                      //             child: Align(
                      //                 alignment: Alignment.topLeft,
                      //                 child: Container(
                      //                   height: 20,
                      //                   child: TextField(
                      //                     controller: addressValueController,
                      //                     enabled: false,
                      //                     decoration: new InputDecoration(
                      //                       border: InputBorder.none,
                      //                       counterText: '',
                      //                     ),
                      //                     style: TextStyle(
                      //                         fontSize: 16
                      //                     ),
                      //                   ),
                      //                 )
                      //             ),
                      //           )
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      //   onTap: (){
                      //     _dispatchAddress();
                      //   },
                      // ),
                      (isTakeAwayOrderConfirmation) ? Container() : buildAddressesList(),
                      (isTakeAwayOrderConfirmation) ? Container() : Padding(
                        padding: EdgeInsets.only(
                            top: 15, left: 15, bottom: 5, right: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: 60,
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        'Подъезд',
                                        style: TextStyle(
                                            color: Color(0xFFB0B0B0),
                                            fontSize: 13),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only( bottom: 0, top: 5),
                                      child: Container(
                                        height: 20,
                                        child: TextField(
                                          textCapitalization: TextCapitalization.sentences,
                                          controller: entranceField,
                                          focusNode: focusNode,
                                          decoration: new InputDecoration(
                                            border: InputBorder.none,
                                            counterText: '',
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            Container(
                              width: 60,
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        'Этаж',
                                        style: TextStyle(
                                            color: Color(0xFFB0B0B0),
                                            fontSize: 13),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only( bottom: 0, top: 5),
                                      child: Container(
                                        height: 20,
                                        child: TextField(
                                          textCapitalization: TextCapitalization.sentences,
                                          controller: floorField,
                                          focusNode: focusNode,
                                          decoration: new InputDecoration(
                                            border: InputBorder.none,
                                            counterText: '',
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            Container(
                              width: 60,
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        'Кв./офис',
                                        style: TextStyle(
                                            color: Color(0xFFB0B0B0),
                                            fontSize: 13),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only( bottom: 0, top: 5),
                                      child: Container(
                                        height: 20,
                                        child: TextField(
                                          textCapitalization: TextCapitalization.sentences,
                                          controller: officeField,
                                          focusNode: focusNode,
                                          decoration: new InputDecoration(
                                            border: InputBorder.none,
                                            counterText: '',
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            Container(
                              width: 80,
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        'Домофон',
                                        style: TextStyle(
                                            color: Color(0xFFB0B0B0),
                                            fontSize: 13),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only( bottom: 5, top: 5),
                                      child: Container(
                                        height: 20,
                                        child: TextField(
                                          textCapitalization: TextCapitalization.sentences,
                                          controller: intercomField,
                                          focusNode: focusNode,
                                          decoration: new InputDecoration(
                                            border: InputBorder.none,
                                            counterText: '',
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(top: 15),
                              child: TextFormField(
                                textCapitalization: TextCapitalization.sentences,
                                controller: commentField,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 15),
                                  hintText: 'Оставить комментарий',
                                  hintStyle: TextStyle(
                                      color: Color(0xFFE6E6E6)
                                  ),
                                  enabledBorder:  OutlineInputBorder(
                                    // width: 0.0 produces a thin "hairline" border
                                    borderSide: BorderSide(color: Colors.black26),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                            Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Container(
                                    color: Colors.white,
                                    child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Text(
                                        'Комментарий',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 15, right: 15),
                        child: Divider(color: Colors.grey),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 5, left: 17, bottom: 5, right: 17),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Стоимость',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14),
                            ),
                            Text(
                              '${currentUser.cartModel.totalPrice} \₽',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14),
                            )
                          ],
                        ),
                      ),
                      (isTakeAwayOrderConfirmation) ? Container() : Padding(
                        padding: EdgeInsets.only(
                            top: 17, left: 15, bottom: 5, right: 17),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: Row(
                                children: [
                                  Text(
                                    'Доставка',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      '30-50 мин.',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${currentUser.cartModel.deliveryPrice} \₽',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14),
                            )
                          ],
                        ),
                      ),
                     // (promoTextKey.currentState!= null && promoTextKey.currentState.title.length != null) ? Padding(
                     //   padding: EdgeInsets.only(
                     //       top: 15, left: 17, bottom: 5, right: 17),
                     //   child: Row(
                     //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     //     children: <Widget>[
                     //       Text(
                     //         'Скидка',
                     //         style: TextStyle(
                     //             color: Colors.red,
                     //             fontSize: 14),
                     //       ),
                     //       Text(
                     //         '-150 \₽',
                     //         style: TextStyle(
                     //             color: Colors.red,
                     //             fontSize: 14),
                     //       )
                     //     ],
                     //   ),
                     // ) : Container(),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 15, left: 17, bottom: 5, right: 17),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Итого',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22),
                            ),
                            Text(
                              '${(totalPrice).toStringAsFixed(0)} \₽',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Divider(color: Colors.grey),
                      ),
                      // Container(
                      //   height: 10,
                      //   color: Color(0xFAFAFAFA),
                      // ),
                      // Padding(
                      //   padding: EdgeInsets.only(
                      //       top: 10, left: 15, right: 15, bottom: 10),
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //         boxShadow: [
                      //           BoxShadow(
                      //             color: Colors.black12,
                      //             blurRadius: 4.0, // soften the shadow
                      //             spreadRadius: 1.0, //extend the shadow
                      //           )
                      //         ],
                      //         color: Colors.white,
                      //         borderRadius: BorderRadius.circular(10.0),
                      //         border: Border.all(width: 1.0, color: Colors.grey[200])),
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(10.0),
                      //       child: Row(
                      //         mainAxisAlignment:
                      //         MainAxisAlignment.spaceBetween,
                      //         children: <Widget>[
                      //           Text(
                      //             'До двери',
                      //             style: TextStyle(
                      //                 color: Color(0xFF3F3F3F),
                      //                 fontSize: 15),
                      //           ),
                      //           Padding(
                      //             padding: EdgeInsets.only(right: 0),
                      //             child: FlutterSwitch(
                      //               width: 55.0,
                      //               height: 25.0,
                      //               inactiveColor: Color(0xD6D6D6D6),
                      //               activeColor: Colors.green,
                      //               valueFontSize: 12.0,
                      //               toggleSize: 18.0,
                      //               value: status1,
                      //               onToggle: (value) {
                      //                 setState(() {
                      //                   status1 = value;
                      //                 });
                      //               },
                      //             ),
                      //           )
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // (isTakeAwayOrderConfirmation) ? Container() : Padding(
                      //   padding: EdgeInsets.only(
                      //       top: 10, left: 15, right: 15, bottom: 10),
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //         boxShadow: [
                      //           BoxShadow(
                      //               color: Colors.black12,
                      //               blurRadius: 2.0,
                      //               offset: Offset(0.0, 1)
                      //           )
                      //         ],
                      //         color: Colors.white,
                      //         borderRadius: BorderRadius.circular(10.0),
                      //         border: Border.all(width: 1.0, color: Colors.grey[200])),
                      //     child: Padding(
                      //       padding: EdgeInsets.only(
                      //           top: 10, left: 15, right: 15, bottom: 10),
                      //       child: Row(
                      //         mainAxisAlignment:
                      //         MainAxisAlignment.spaceBetween,
                      //         children: <Widget>[
                      //           Column(
                      //             children: [
                      //               Text(
                      //                 'Время доставки',
                      //                 style: TextStyle(
                      //                     color: Color(0xFF3F3F3F),
                      //                     fontSize: 15),
                      //               ),
                      //               Text(
                      //                 '30-40 мин',
                      //                 style: TextStyle(
                      //                     color: Color(0xFF3F3F3F),
                      //                     fontSize: 15),
                      //               ),
                      //             ],
                      //           ),
                      //           Text(
                      //             'Изменить',
                      //             style: TextStyle(
                      //                 color: Color(0xFF3F3F3F),
                      //                 fontSize: 15),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30, right: 10),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 10, left: 15, right: 15, bottom: 10),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: GestureDetector(
                                  child: Container(
                                    width: 160,
                                    height: 64,
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 2.0,
                                              offset: Offset(0.0, 1)
                                          )
                                        ],
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10.0),
                                        border: Border.all(width: 1.0, color: Colors.grey[200])),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: 10, left: 15, right: 20, bottom: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Column(
                                            children: [
                                              Text(
                                                "Способ оплаты",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xFFB8B8B8)),
                                              ),
                                              Text(
                                                'Наличными',
                                                // (selectedPaymentId == 1) ? card : cash,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                          // Padding(
                                          //   padding: EdgeInsets.only(left: 10),
                                          //   child: SvgPicture.asset(
                                          //       'assets/svg_images/arrow_down.svg'),
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: () async {
                                    // _payment();
                                  },
                                ),
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(right: 0),
                            //   child: PromoText(key: promoTextKey,),
                            // )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 2.0,
                              offset: Offset(0.0, 1)
                          )
                        ],
                        color: Colors.white,),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 15, left: 15, right: 15, top: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                  '${(totalPrice).toStringAsFixed(0)} \₽',
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black)),
                              Text(
                                '~30-50 мин.',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          FlatButton(
                            child: Text('Заказать',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.white)),
                            color: Color(0xFF09B44D),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.only(
                                left: 60, top: 20, right: 60, bottom: 20),
                            onPressed: () async {
                              if (await Internet.checkConnection()) {
                                // if(selectedPaymentId != 1){
                                //   showAlertDialog(context);
                                // }
                                // print(addressSelectorKey.currentState.myFavouriteAddressesModel.address.unrestrictedValue);
                                // createOrder = new CreateOrder(
                                //   address: addressSelectorKey.currentState.myFavouriteAddressesModel.address,
                                //   restaurantAddress: selectedAddress,
                                //   office: officeField.text,
                                //   floor: floorField.text,
                                //   entrance: entranceField.text,
                                //   intercom: intercomField.text,
                                //   comment: commentField.text,
                                //   // cartDataModel: currentUser.cartModel,
                                //   //restaurant: restaurant,
                                //   payment_type: (selectedPaymentId == 1) ? 'card' : 'cash',
                                //   door_to_door: status1,
                                // );
                                // if(selectedPaymentId == 1){
                                //   _cardPayment(totalPrice);
                                //   return;
                                // }
                                // await createOrder.sendData();
                                // // currentUser.cartModel.cart.clear();
                                // // currentUser.cartModel.saveData();
                                await createOrder(currentUser.cartModel.uuid);
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => OrderSuccessScreen(name: necessaryDataForAuth.name)),
                                        (Route<dynamic> route) => false);
                              } else {
                                noConnection(context);
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )
        ),),
    );
  }
}