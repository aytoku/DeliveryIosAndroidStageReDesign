import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/Screens/CartScreen/View/cart_page_view.dart';
import 'package:flutter_app/Screens/HomeScreen/Model/FilteredStores.dart';
import 'package:flutter_app/Screens/HomeScreen/View/home_screen.dart';
import 'package:flutter_app/Screens/MyAddressesScreen/Model/InitialAddressModel.dart';
import 'package:flutter_app/Screens/MyAddressesScreen/Model/my_addresses_model.dart';
import 'package:flutter_app/Screens/OrderConfirmationScreen/API/create_order.dart';
import 'package:flutter_app/Screens/OrderConfirmationScreen/Model/PaymentMethod.dart';
import 'package:flutter_app/Screens/OrderConfirmationScreen/Widgets/AddressSelector.dart';
import 'package:flutter_app/Screens/OrderConfirmationScreen/Widgets/DeliveryInfo.dart';
import 'package:flutter_app/Screens/OrderConfirmationScreen/Widgets/DeliveryTotalPrice.dart';
import 'package:flutter_app/Screens/OrderConfirmationScreen/Widgets/DestinationPointsAddressSelector.dart';
import 'package:flutter_app/Screens/OrderConfirmationScreen/Widgets/OrderSuccessScreen.dart';
import 'package:flutter_app/Screens/OrderConfirmationScreen/Widgets/PaymentButton.dart';
import 'package:flutter_app/Screens/OrderConfirmationScreen/Widgets/PromoText.dart';
import 'package:flutter_app/Screens/PaymentScreen/API/sber_API.dart';
import 'package:flutter_app/Screens/PaymentScreen/Model/SberGooglePayment.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:mad_pay/mad_pay.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../data/data.dart';
import '../../../data/globalVariables.dart';

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
  GlobalKey<DestinationPointsSelectorState> destinationPointsSelectorStateKey;
  bool isTakeAwayOrderConfirmation;
  //CreateOrder createOrder;
  GlobalKey<CartPageState> cartPageKey;

  List<MyFavouriteAddressesModel> myAddressesModelList;

  String cash_image;
  String card_image;
  String cash;
  String card;
  PaymentMethod selectedPaymentMethod;
  List<PaymentMethod> paymentMethods;


  bool eatInStore = false;
  GlobalKey<ScaffoldState> _scaffoldStateKey;
  TextEditingController commentField;
  GlobalKey<AddressSelectorState> addressSelectorKey;
  GlobalKey<PromoTextState> promoTextKey;
  GlobalKey<PaymentButtonState> paymentButtonKey;
  SberGooglePayment sberGooglePayment;

  // TextEditingController phoneNumberController;
  // TextEditingController nameController;
  TextEditingController addressValueController;

  bool isAddressSelected = false;

  MyFavouriteAddressesModel addedAddress;

  double initHeight = 200;
  int paymentsMethodCount = 0;

  TextEditingController officeField;
  TextEditingController intercomField;
  TextEditingController entranceField;
  TextEditingController floorField;


  AddressScreenState(this.restaurant, this.addedAddress, this.isTakeAwayOrderConfirmation, {this.myAddressesModelList});

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    destinationPointsSelectorStateKey = GlobalKey();
    cartPageKey = GlobalKey();
    cash_image = 'assets/svg_images/dollar_bills.svg';
    card_image = 'assets/svg_images/visa.svg';
    cash = 'Наличными';
    card = 'Картой';
    entranceField = new TextEditingController();
    floorField = new TextEditingController();
    intercomField = new TextEditingController();
    officeField = new TextEditingController();
    _scaffoldStateKey = GlobalKey();
    commentField = new TextEditingController();
    addressValueController = new TextEditingController();
    addressSelectorKey = new GlobalKey();
    promoTextKey = new GlobalKey();
    // phoneNumberController = new TextEditingController();
    // nameController = new TextEditingController();
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

    // получение либо дефолтного способа оплаты, либо замена его на
    // альтернативный
    selectedPaymentMethod = necessaryDataForAuth.selectedPaymentMethod;
    if(restaurant.paymentTypes.isNotEmpty){
      bool isDefaultMethodAvailable = restaurant.paymentTypes.indexWhere((element) => element == selectedPaymentMethod.outputTag) != -1;
      if(!isDefaultMethodAvailable){ // если дефолтный метод не доступен
        int newPaymentMethodIndex = paymentMethods.indexWhere((element) => element.outputTag == restaurant.paymentTypes[0]); // находим доступный
        if(newPaymentMethodIndex != -1)
          selectedPaymentMethod = paymentMethods[newPaymentMethodIndex];
      }
    }
    // addressValueController = TextEditingController(text: restaurant.destination_points[0].street + ' ' + restaurant.destination_points[0].house);
    // selectedAddress = restaurant.address[0];
  }


  emptyAddress(BuildContext context) {
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
                child: Text("Введите адрес"),
              ),
            ),
          ),
        );
      },
    );
  }

  failedPayment(BuildContext context) {
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
                child: Text("Оплата не прошла"),
              ),
            ),
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
            height: 130,
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
      height: 130,
      child: ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        children: List.generate(
            paymentMethods.length, (index){
              if(!restaurant.paymentTypes.contains(paymentMethods[index].outputTag)){
                return Container();
              }
              return InkWell(
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, bottom: 5, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SvgPicture.asset(paymentMethods[index].image),
                        Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Text(
                            paymentMethods[index].name,
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
                              child: (selectedPaymentMethod != paymentMethods[index]) ?
                              SvgPicture.asset('assets/svg_images/pay_circle.svg') :
                              SvgPicture.asset('assets/svg_images/address_screen_selector.svg'),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  onTap: ()=>_selectItem(paymentMethods[index])
              );
        })
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
                        color: AppColor.mainColor,
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

  void _selectItem(PaymentMethod paymentMethod) {
    Navigator.pop(context);
    setState(() {
      selectedPaymentMethod = paymentMethod;
    });
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
          color: AppColor.themeColor,
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
                      color: AppColor.mainColor,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(
                    child: Text('Готово',
                      style: TextStyle(
                          fontSize: 24,
                          color: AppColor.textColor
                      ),
                    ),
                  ),
                ),
                onTap: (){
                  /*addressValueController.text = destinationPointsSelectorStateKey.currentState.selectedDestinationPoint.street + ' ' +
                      destinationPointsSelectorStateKey.currentState.selectedDestinationPoint.house;
                  selectedAddress = destinationPointsSelectorStateKey.currentState.selectedDestinationPoint;
                  Navigator.pop(context);*/
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
          height: 120,
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
    }else{
      return FutureBuilder<List<MyFavouriteAddressesModel>>(
        future: MyFavouriteAddressesModel.getAddresses(),
        builder: (BuildContext context,
            AsyncSnapshot<List<MyFavouriteAddressesModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            myAddressesModelList = snapshot.data;
            myAddressesModelList
                .add(new MyFavouriteAddressesModel(type: null));
            return Container(
              height: 120,
              // height: initHeight + 15 * myAddressesModelList.length,
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
                  buildAddressesListSelector()
                ],
              ),
            );
          } else {
            return Column(
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
                Center(
                  child: SpinKitThreeBounce(
                    color: AppColor.mainColor,
                    size: 20.0,
                  ),
                ),
              ],
            );
          }
        },
      );
    }
  }

  Widget buildAddressesListSelector(){
    return Expanded(
      child: AddressSelector(myFavouriteAddressList: myAddressesModelList, parent:  this, addressSelectorKey: addressSelectorKey),
    );
  }



  @override
  Widget build(BuildContext context) {
    addressSelectorKey = new GlobalKey();
    paymentButtonKey = new GlobalKey();
    FocusNode focusNode;
    // количество доступных методов оплаты
    paymentsMethodCount = 0;
    paymentMethods.forEach((element) {
      if(restaurant.paymentTypes.contains(element.outputTag))
        paymentsMethodCount++;
    });

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarBrightness: Brightness.light
      ),
      child: Scaffold(
        key: _scaffoldStateKey,
        resizeToAvoidBottomInset: false,
        body:  GestureDetector(
          child: Container(
              color: AppColor.themeColor,
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
                              hoverColor: AppColor.themeColor,
                              focusColor: AppColor.themeColor,
                              splashColor: AppColor.themeColor,
                              highlightColor: AppColor.themeColor,
                              onTap: () => Navigator.pop(context),
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
                      physics: BouncingScrollPhysics(),
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
                        Container(
                          height: 5,
                        ),
                        (isTakeAwayOrderConfirmation) ? Container() : Padding(
                          padding: EdgeInsets.only(
                              top: 10, left: 20, bottom: 0, right: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: 60,
                                child: Padding(
                                    padding: EdgeInsets.only( bottom: 0, top: 5),
                                    child: Container(
                                      height: 20,
                                      child: TextField(
                                        textCapitalization: TextCapitalization.sentences,
                                        controller: entranceField,
                                        maxLength: 3,
                                        keyboardType: TextInputType.number,
                                        focusNode: focusNode,
                                        decoration: new InputDecoration(
                                          hintText: 'Подъезд',
                                          hintStyle: TextStyle(
                                              color: Color(0xFFB0B0B0),
                                              fontSize: 13),
                                          border: InputBorder.none,
                                          counterText: '',
                                        ),
                                      ),
                                    )),
                              ),
                              Container(
                                width: 60,
                                child: Padding(
                                    padding: EdgeInsets.only( bottom: 0, top: 5),
                                    child: Container(
                                      height: 20,
                                      child: TextField(
                                        textCapitalization: TextCapitalization.sentences,
                                        controller: floorField,
                                        keyboardType: TextInputType.number,
                                        focusNode: focusNode,
                                        maxLength: 2,
                                        decoration: new InputDecoration(
                                          hintText: 'Этаж',
                                          hintStyle: TextStyle(
                                              color: Color(0xFFB0B0B0),
                                              fontSize: 13),
                                          border: InputBorder.none,
                                          counterText: '',
                                        ),
                                      ),
                                    )),
                              ),
                              Container(
                                width: 60,
                                child: Padding(
                                    padding: EdgeInsets.only( bottom: 0, top: 5),
                                    child: Container(
                                      height: 20,
                                      child: TextField(
                                        textCapitalization: TextCapitalization.sentences,
                                        controller: officeField,
                                        maxLength: 6,
                                        focusNode: focusNode,
                                        keyboardType: TextInputType.number,
                                        decoration: new InputDecoration(
                                          hintText: 'Кв./офис',
                                          hintStyle: TextStyle(
                                              color: Color(0xFFB0B0B0),
                                              fontSize: 13),
                                          border: InputBorder.none,
                                          counterText: '',
                                        ),
                                      ),
                                    )),
                              ),
                              Container(
                                width: 80,
                                child: Padding(
                                    padding: EdgeInsets.only( bottom: 0, top: 5),
                                    child: Container(
                                      height: 20,
                                      child: TextField(
                                        textCapitalization: TextCapitalization.sentences,
                                        controller: intercomField,
                                        maxLength: 6,
                                        keyboardType: TextInputType.number,
                                        focusNode: focusNode,
                                        decoration: new InputDecoration(
                                          hintText: 'Домофон',
                                          hintStyle: TextStyle(
                                              color: Color(0xFFB0B0B0),
                                              fontSize: 13),
                                          border: InputBorder.none,
                                          counterText: '',
                                        ),
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
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
                                      color: AppColor.themeColor,
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
                                '${currentUser.cartModel.totalPrice.toStringAsFixed(0)} \₽',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14),
                              )
                            ],
                          ),
                        ),
                        (isTakeAwayOrderConfirmation) ? Container() : Padding(
                          padding: EdgeInsets.only(
                              top: 17, left: 18, bottom: 5, right: 17),
                          child: DeliveryInfo(parent: this,)
                        ),
                        Visibility(
                          visible: (currentUser.cartModel.promotion == null ||
                          currentUser.cartModel.promotion.uuid == '') ? false : true,
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 15, left: 17, bottom: 5, right: 17),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Скидка',
                                  style:
                                  TextStyle(color: Colors.red, fontSize: 14),
                                ),
                                Text(
                                  (currentUser.cartModel.promotion == null) ? '' : '-${currentUser.cartModel.promotion.amount} \₽',
                                  style:
                                  TextStyle(color: Colors.red, fontSize: 14),
                                )
                              ],
                            ),
                          ),
                        ),
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
                              DeliveryTotalPrice(parent: this),
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
                        (isTakeAwayOrderConfirmation && restaurant.type == 'restaurant') ? Padding(
                          padding: EdgeInsets.only(
                              top: 10, left: 15, right: 15, bottom: 10),
                          child: Container(
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
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Поем в заведении',
                                    style: TextStyle(
                                        color: Color(0xFF3F3F3F),
                                        fontSize: 15),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 0),
                                    child: FlutterSwitch(
                                      width: 55.0,
                                      height: 25.0,
                                      inactiveColor: Color(0xD6D6D6D6),
                                      activeColor: Colors.green,
                                      valueFontSize: 12.0,
                                      toggleSize: 18.0,
                                      value: eatInStore,
                                      onToggle: (value) {
                                        setState(() {
                                          eatInStore = value;
                                        });
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ) : Container(),
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
                        (paymentsMethodCount == 1) ?

                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10, left: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text('Способ оплаты',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: AppColor.additionalTextColor),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5, right: 8),
                                      child: Text(selectedPaymentMethod.name),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: PromoText(
                                    key: promoTextKey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )

                            : Padding(
                          padding: const EdgeInsets.only(bottom: 30, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          color: AppColor.themeColor,
                                          borderRadius: BorderRadius.circular(10.0),
                                          border: Border.all(width: 1.0, color: Colors.grey[200])),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 0, left: 0, right: 20, bottom: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(bottom: 8.0, left: 15, top: 10),
                                                  child: Text(
                                                    "Способ оплаты",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Color(0xFFB8B8B8)),
                                                  ),
                                                ),
                                                Align(
                                                  alignment: Alignment.bottomLeft,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 17),
                                                    child: Text(
                                                      selectedPaymentMethod.name,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 10, top: 12),
                                              child: SvgPicture.asset(
                                                  'assets/svg_images/arrow_down.svg'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    onTap: () async {
                                       _payment();

                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: PromoText(
                                  key: promoTextKey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: PaymentButton(
                      parent: this,
                      key: paymentButtonKey,
                      onTap: () async {
                        if (await Internet.checkConnection()) {
                          if(isTakeAwayOrderConfirmation){
                            showAlertDialog(context);
                            await createOrder(
                                currentUser.cartModel.uuid,
                                isTakeAwayOrderConfirmation,
                                false,
                              (restaurant.type == 'restaurant') ? eatInStore : false,
                                null,
                                '',
                                '',
                                '',
                                '',
                                commentField.text,
                            );
                          } else {
                            if(addressSelectorKey.currentState.myFavouriteAddressesModel.address == null
                                && !isTakeAwayOrderConfirmation){
                              emptyAddress(context);
                              return;
                            }
                            if(selectedPaymentMethod == paymentMethods[1]){
                              await makePayment();
                            }else if(selectedPaymentMethod == paymentMethods[0]){
                              showAlertDialog(context);
                              await createOrder(
                                  currentUser.cartModel.uuid,
                                  false,
                                  false,
                                  eatInStore,
                                  addressSelectorKey.currentState.myFavouriteAddressesModel.address,
                                  entranceField.text,
                                  floorField.text,
                                  officeField.text,
                                  intercomField.text,
                                  commentField.text
                              );
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => OrderSuccessScreen(name: necessaryDataForAuth.name)),
                                      (Route<dynamic> route) => false);
                            }
                          }

                          // if(selectedPaymentMethod == paymentMethods[0]){
                          //   Navigator.of(context).pushAndRemoveUntil(
                          //       MaterialPageRoute(
                          //           builder: (context) => OrderSuccessScreen(name: necessaryDataForAuth.name)),
                          //           (Route<dynamic> route) => false);
                          // }else{ // если не наличка
                          //   await makePayment();
                          // }

                        } else {
                          noConnection(context);
                        }
                      },
                    )
                  )
                ],
              )
          ),
          onTap: (){
            FocusScope.of(context).requestFocus(new FocusNode());
          },
        ),),
    );
  }

  Future<bool> makePayment() async{
    if(Platform.isAndroid){
      SberAPI.amount = (currentUser.cartModel.totalPrice * 100).round();
    }
     SberAPI.orderNumber = currentUser.cartModel.id;

    Map<String, String> req = await madPayment();
    var result;
    if(Platform.isIOS){
     result  = await SberAPI.applePay(req, currentUser.cartModel.uuid);
    }else{
      result = await SberAPI.googlePay(req, currentUser.cartModel.uuid);
    }
    if(result.success){
      showAlertDialog(context);
      await createOrder(
          currentUser.cartModel.uuid,
          false,
          false,
          eatInStore,
          addressSelectorKey.currentState.myFavouriteAddressesModel.address,
          entranceField.text,
          floorField.text,
          officeField.text,
          intercomField.text,
          commentField.text
      );
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => OrderSuccessScreen(name: necessaryDataForAuth.name)),
              (Route<dynamic> route) => false);
    }else if(result == null || result.success == false){
      failedPayment(context);
    }
    // if(result.success){
    //   // if(result.data.acsUrl != null){
    //   //   Navigator.of(context).push(
    //   //       MaterialPageRoute(
    //   //           builder: (context) => WebView(
    //   //             onPageFinished: (String url) {
    //   //               print(url);
    //   //               if(url == "https://3dsec.sberbank.ru/payment/merchants/root/errors_ru.html"){ // здесь когда-нибудь вставить саксес и еррор урлы
    //   //                 Navigator.of(context).pushAndRemoveUntil(
    //   //                     MaterialPageRoute(
    //   //                         builder: (context) => OrderSuccessScreen(name: necessaryDataForAuth.name)),
    //   //                         (Route<dynamic> route) => false);
    //   //               }
    //   //             },
    //   //             initialUrl: new Uri.dataFromString(
    //   //                 _loadHTML(result.data.acsUrl,
    //   //                     result.data.paReq,
    //   //                     result.data.termUrl
    //   //                 ), mimeType: 'text/html').toString(),
    //   //             javascriptMode: JavascriptMode.unrestricted,
    //   //             onWebViewCreated: (WebViewController webController){
    //   //             },
    //   //           ))
    //   //   );
    //   //   return result.success;
    //   // }
    //   Navigator.of(context).pushAndRemoveUntil(
    //       MaterialPageRoute(
    //           builder: (context) => OrderSuccessScreen(name: necessaryDataForAuth.name)),
    //           (Route<dynamic> route) => false);
    //
    // }
    return result.success;
  }

  Future<Map<String, String>> madPayment() async{
    final MadPay pay = MadPay();
    await pay.checkPayments();
    await pay.checkActiveCard(
      paymentNetworks: <PaymentNetwork>[
        PaymentNetwork.visa,
        PaymentNetwork.mastercard,
      ],
    );

    List<PaymentItem> paymentItems = [];
    currentUser.cartModel.items.forEach((item) {
      paymentItems.add(PaymentItem(name: item.product.name, price: item.totalItemPrice));
    });
    paymentItems.add(PaymentItem(name: "Доставка", price: currentUser.cartModel.deliveryPrice + 1));


    final Map<String, String> req =
        await pay.processingPayment(
      google: GoogleParameters(
        gatewayName: 'sberbank',
        gatewayMerchantId: 'T1513081007',
      ),
      apple: AppleParameters(
        merchantIdentifier: 'merchant.applePayFaem.com',
      ),
      currencyCode: 'RUB',
      countryCode: 'RU',
      paymentItems: paymentItems,
      paymentNetworks: <PaymentNetwork>[
        PaymentNetwork.visa,
        PaymentNetwork.mastercard,
      ],
    );
    print(req);
    return req;
  }

  // String _loadHTML(String acsUrl, String paReq, String termUrl){
  //   return '''
  //     <html>
  //       <body onload="document.form.submit()" >
  //         <form name="form" action="$acsUrl" method="post" >
  //             <input type="hidden" name="TermUrl" value="$termUrl" >
  //             <input type="hidden" name="PaReq" value="$paReq" >
  //         </form>
  //       </body>
  //     </html>
  //   ''';
  // }
}