import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/models/CreateModelTakeAway.dart';
import 'package:flutter_app/models/CreateOrderModel.dart';
import 'package:flutter_app/models/InitialAddressModel.dart';
import 'package:flutter_app/models/ResponseData.dart';
import 'package:flutter_app/models/my_addresses_model.dart';
import 'package:flutter_app/models/order.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../models/CreateModelTakeAway.dart';
import '../models/CreateOrderModel.dart';
import '../models/my_addresses_model.dart';
import 'auto_complete.dart';
import 'cart_screen.dart';
import 'home_screen.dart';
import 'package:flutter_app/Screens/add_address_screen.dart';

import 'restaurant_screen.dart';


class PageScreen extends StatefulWidget {
  final Records restaurant;
  List<MyFavouriteAddressesModel> myAddressesModelList;
  PageScreen({
    Key key,
    this.restaurant,
    this.myAddressesModelList
  }) : super(key: key);

  @override
  PageState createState() => PageState(restaurant, myAddressesModelList: myAddressesModelList);
}

class PageState extends State<PageScreen> {
  final Records restaurant;
  bool _color = false;
  CreateOrder createOrder;
  CreateOrderTakeAway createOrderTakeAway;

  PageState(this.restaurant, {this.myAddressesModelList});

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
                      child: CircularProgressIndicator(),
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
            height: 120,
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
      height: 120,
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
                          child: (selectedPaymentId == 1) ? SvgPicture.asset('assets/svg_images/pay_circle.svg') : SvgPicture.asset('assets/svg_images/accessed_pay_circle.svg'),
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
                          child: (selectedPaymentId == 0) ? SvgPicture.asset('assets/svg_images/pay_circle.svg') : SvgPicture.asset('assets/svg_images/accessed_pay_circle.svg'),
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
                      padding: EdgeInsets.only(left: 15, top: 20, bottom: 20),
                      child: Text(
                        'Отправляем ваш заказ в систему',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF424242)),
                      ),
                    ),
                    Center(
                      child: CircularProgressIndicator(),
                    )
                  ],
                )),
          ),
        );
      },
    );
  }


  _promoCode() {
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
            height: 120,
            child: _buildPromoCodeBottomNavigationMenu(),
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                )),
          );
        });
  }

  TextEditingController promoCodeField = new TextEditingController();

  _buildPromoCodeBottomNavigationMenu() {
    return Container(
      height: 91,
      width: 300,
      decoration: BoxDecoration(
        color: Color(0xFF67C070),
        border: Border.all(
          color: Color(0xFFE6E6E6),
        ),
        borderRadius: const BorderRadius.all(
          const Radius.circular(10.0),
        ),
      ),
      child: Column(
        children: [
          Padding(
              padding: EdgeInsets.only(top: 10),
              child: TextField(
                autofocus: true,
                controller: promoCodeField,
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.start,
                maxLength: 4,
                keyboardType: TextInputType.number,
                decoration: new InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10),),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  counterText: '',
                  contentPadding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.22),
                  hintStyle: TextStyle(
                      color: Color(0xFFC0BFC6),
                      fontSize: 14
                  ),
                  hintText: 'Введите промокод',
                ),
              )
          ),
          Container(
            height: 59,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10),),
            ),
            child: Text('Применить',
              style: TextStyle(
                fontSize: 21
              ),
            ),
          )
        ],
      ),
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


  int selectedPageId = 0;
  GlobalKey<TakeAwayState> takeAwayScreenKey = new GlobalKey<TakeAwayState>();
  GlobalKey<AddressScreenState> addressScreenKey = new GlobalKey<AddressScreenState>();

  List<MyFavouriteAddressesModel> myAddressesModelList;
  MyFavouriteAddressesModel myAddressesModel;

  String cash_image = 'assets/svg_images/dollar_bills.svg';
  String card_image = 'assets/svg_images/visa.svg';
  String cash = 'Наличными';
  String card = 'Картой';
  int selectedPaymentId = 0;

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
                      if(selectedPageId == 0)
                        await createOrder.sendData();
                      else
                        await createOrderTakeAway.sendData();
                      currentUser.cartDataModel.cart.clear();
                      currentUser.cartDataModel.saveData();
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

  @override
  Widget build(BuildContext context) {
    FocusNode focusNode;
    double totalPrice = 0;
    currentUser.cartDataModel.cart.forEach(
            (Order order) {
          if(order.food.variants != null && order.food.variants.length > 0 && order.food.variants[0].price != null){
            totalPrice += order.quantity * (order.food.price + order.food.variants[0].price);
          }else{
            totalPrice += order.quantity * order.food.price;
          }
          double toppingsCost = 0;
          if(order.food.toppings != null){
            order.food.toppings.forEach((element) {
              toppingsCost += order.quantity * element.price;
            });
            totalPrice += toppingsCost;
          }
        }
    );
    print('suka');
    var addressScreen = AddressScreen(restaurant: restaurant, key: addressScreenKey, myAddressesModelList: myAddressesModelList);
    var takeAwayScreen = TakeAway(restaurant: restaurant, key: takeAwayScreenKey,);
    bool f = false;
    GlobalKey<PromoCodeFieldState> promoCodeFieldKey = new GlobalKey();
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Column(
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
                  Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
                        child: SizedBox(
                          height: 40,
                          child: GestureDetector(
                            child: Padding(
                              padding: EdgeInsets.only(left: 0,
                                  right: 0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(40)),
                                  color: (selectedPageId == 0) ? Color(0xFFFE534F) : Colors.white,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 40, right: 40, top: 10),
                                  child: Text(
                                    'Доставка',
                                    style: TextStyle(
                                        color: (selectedPageId == 0) ? Colors.white : Color(0xFF999999), fontSize: 15),
                                  ),
                                ),
                              ),
                            ),
                            onTap: () async {
                              if (await Internet.checkConnection()) {
                                _controller.animateToPage(0,
                                    duration: Duration(seconds: 1),
                                    curve: Curves.elasticOut);
                              } else {
                                noConnection(context);
                              }
                            },
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.05),
                        child: SizedBox(
                          height: 40,
                          child: GestureDetector(
                            child: Padding(
                              padding: EdgeInsets.only(left: 0,
                                  right: 0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(40)),
                                  color: (selectedPageId == 1) ? Color(0xFFFE534F) : Colors.white,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 40, right: 40, top: 10),
                                  child: Text(
                                    'Заберу сам',
                                    style: TextStyle(
                                        color: (selectedPageId == 1) ? Colors.white : Color(0xFF999999), fontSize: 15),
                                  ),
                                ),
                              ),
                            ),
                            onTap: () async {
                              if (await Internet.checkConnection()) {
                                _controller.animateToPage(1,
                                    duration: Duration(seconds: 1),
                                    curve: Curves.elasticOut);
                              } else {
                                noConnection(context);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _controller,
                children: [addressScreen, takeAwayScreen],
                onPageChanged: (int pageId) {
                  setState(() {
                    selectedPageId = pageId;
                  });
                },
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: 10, left: 15, right: 15, bottom: 10),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: GestureDetector(
                      child: Container(
                        width: 167,
                        height: 64,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8.0, // soften the shadow
                                spreadRadius: 3.0, //extend the shadow
                              )
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(width: 1.0, color: Colors.grey[200])),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 10, left: 15, right: 15, bottom: 10),
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
                                    (selectedPaymentId == 1) ? card : cash,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
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
                  padding: EdgeInsets.only(
                      top: 10, left: 0, right: 15, bottom: 10),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: InkWell(
                      child: Container(
                        width: 140,
                        height: 64,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8.0, // soften the shadow
                                spreadRadius: 3.0, //extend the shadow
                              )
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(width: 1.0, color: Colors.grey[200])),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 10, left: 15, right: 15, bottom: 10),
                          child: (f) ? PromoCodeField(key: promoCodeFieldKey) : Center(child: Text('  Введите\nпромокод')),
                        ),
                      ),
                      onTap: () async {
                        _promoCode();
                      },
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 20, left: 15, right: 15, top: 10),
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
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                      color: Color(0xFFFE534F),
                      splashColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.only(
                          left: 60, top: 20, right: 60, bottom: 20),
                      onPressed: () async {
                        if (await Internet.checkConnection()) {
                          if (addressScreenKey.currentState.addressField.text.length >
                              0 || selectedPageId == 1) {
                            Center(
                              child: CircularProgressIndicator(),
                            );
                            if(selectedPaymentId != 1){
                              showAlertDialog(context);
                            }
                            if(selectedPageId == 0 && addressScreenKey.currentState != null) {
                              createOrder = new CreateOrder(
                                address: addressScreenKey.currentState.addressSelectorKey.currentState.myFavouriteAddressesModel.address,
                                restaurantAddress: addressScreenKey.currentState.destinationPointsSelectorStateKey.currentState.selectedDestinationPoint,
                                office: addressScreenKey.currentState.officeField
                                    .text,
                                floor: addressScreenKey.currentState.floorField.text,
                                entrance: addressScreenKey.currentState.entranceField
                                    .text,
                                intercom: addressScreenKey.currentState.intercomField
                                    .text,
                                comment: addressScreenKey.currentState.commentField
                                    .text,
                                cartDataModel: currentUser.cartDataModel,
                                restaurant: restaurant,
                                payment_type: (selectedPaymentId == 1) ? 'card' : 'cash',
                                door_to_door: addressScreenKey.currentState.status1,
                              );
                              if(selectedPaymentId == 1){
                                _cardPayment(totalPrice);
                                return;
                              }
                              print('Payment');
                              await createOrder.sendData();
                            } else if (takeAwayScreenKey.currentState != null) {
                              createOrderTakeAway =
                              new CreateOrderTakeAway(
                                  comment: (takeAwayScreenKey.currentState.status1) ? "Поем в заведении" : takeAwayScreenKey.currentState.comment,
                                  cartDataModel: currentUser.cartDataModel,
                                  restaurantAddress: takeAwayScreenKey.currentState.destinationPointsSelectorStateKey.currentState.selectedDestinationPoint,
                                  without_delivery: true,
                                  restaurant: restaurant);
                              if(selectedPaymentId == 1){
                                _cardPayment(totalPrice);
                                return;
                              }
                              await createOrderTakeAway.sendData();
                            }
                            else{
                              print('All go');
                            }
                            currentUser.cartDataModel.cart.clear();
                            currentUser.cartDataModel.saveData();
//                            homeScreenKey = new GlobalKey<HomeScreenState>();
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => OrderSuccessScreen(name: necessaryDataForAuth.name)),
                                    (Route<dynamic> route) => false);
                          }
                        } else {
                          noConnection(context);
                        }
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AddressScreen extends StatefulWidget {
  MyFavouriteAddressesModel addedAddress;
  List<MyFavouriteAddressesModel> myAddressesModelList;

  AddressScreen(
      {Key key, this.restaurant, this.addedAddress, this.myAddressesModelList})
      : super(key: key);
  final Records restaurant;

  @override
  AddressScreenState createState() =>
      AddressScreenState(restaurant, addedAddress, myAddressesModelList: myAddressesModelList);
}

class AddressScreenState extends State<AddressScreen>
    with AutomaticKeepAliveClientMixin {
  String address = 'Адрес доставки';
  String office;
  String floor;
  String comment;
  String delivery;
  InitialAddressModel selectedAddress; // Последний выбранный адрес
  final Records restaurant;
  GlobalKey<DestinationPointsSelectorState> destinationPointsSelectorStateKey =
  GlobalKey();
  CreateOrder createOrder;

  AddressScreenState(this.restaurant, this.addedAddress, {this.myAddressesModelList});

  bool f = false;
  GlobalKey<PromoCodeFieldState> promoCodeFieldKey = new GlobalKey();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    addressValueController = TextEditingController(text: restaurant.destination_points[0].street + ' ' + restaurant.destination_points[0].house);
    selectedAddress = restaurant.destination_points[0];
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
                      child: CircularProgressIndicator(),
                    )
                  ],
                )),
          ),
        );
      },
    );
  }

  _promoCode() {
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
            child: _buildPromoCodeBottomNavigationMenu(),
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                )),
          );
        });
  }

  TextEditingController promoCodeField = new TextEditingController();

  _buildPromoCodeBottomNavigationMenu() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 80, bottom: 100),
      child: Container(
        height: 40,
        width: 300,
        decoration: BoxDecoration(
          color: Color(0xFF67C070),
          border: Border.all(
            color: Color(0xFFE6E6E6),
          ),
          borderRadius: const BorderRadius.all(
            const Radius.circular(10.0),
          ),
        ),
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.only(top: 0),
                child: TextField(
                  controller: promoCodeField,
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                  maxLength: 4,
                  keyboardType: TextInputType.number,
                  decoration: new InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),),
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    counterText: '',
                    hintStyle: TextStyle(
                        color: Color(0xFFC0BFC6),
                        fontSize: 14
                    ),
                    hintText: 'Введите промокод',
                  ),
                )
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10),),
                ),
                child: Text('Применить',
                  style: TextStyle(
                      fontSize: 21,
                    color: Colors.white
                  ),
                ),
              ),
            )
          ],
        ),
      ),
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
            height: 120,
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
      height: 120,
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
                          child: (selectedPaymentId == 1) ? SvgPicture.asset('assets/svg_images/pay_circle.svg') : SvgPicture.asset('assets/svg_images/accessed_pay_circle.svg'),
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
                          child: (selectedPaymentId == 0) ? SvgPicture.asset('assets/svg_images/pay_circle.svg') : SvgPicture.asset('assets/svg_images/accessed_pay_circle.svg'),
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
                      padding: EdgeInsets.only(left: 15, top: 20, bottom: 20),
                      child: Text(
                        'Отправляем ваш заказ в систему',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF424242)),
                      ),
                    ),
                    Center(
                      child: CircularProgressIndicator(),
                    )
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


  int selectedPageId = 0;
  GlobalKey<TakeAwayState> takeAwayScreenKey = new GlobalKey<TakeAwayState>();
  GlobalKey<AddressScreenState> addressScreenKey = new GlobalKey<AddressScreenState>();

  List<MyFavouriteAddressesModel> myAddressesModelList;
  MyFavouriteAddressesModel myAddressesModel;

  String cash_image = 'assets/svg_images/dollar_bills.svg';
  String card_image = 'assets/svg_images/visa.svg';
  String cash = 'Наличными';
  String card = 'Картой';
  int selectedPaymentId = 0;

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
                      await createOrder.sendData();
                      currentUser.cartDataModel.cart.clear();
                      currentUser.cartDataModel.saveData();
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

  bool status1 = false;
  bool status2 = false;
  GlobalKey<ScaffoldState> _scaffoldStateKey = GlobalKey();
  final maxLines = 1;
  TextEditingController commentField = new TextEditingController();
  TextEditingController officeField = new TextEditingController();
  TextEditingController intercomField = new TextEditingController();
  TextEditingController entranceField = new TextEditingController();
  TextEditingController floorField = new TextEditingController();
  TextEditingController addressField = new TextEditingController();
  TextField floorTextField;
  TextField intercomTextField;
  TextField entranceTextField;
  TextField officeTextField;
  AutoComplete autoComplete;
  GlobalKey<AutoCompleteDemoState> autoCompleteKey = new GlobalKey();
  GlobalKey<AddressSelectorState> addressSelectorKey = new GlobalKey();
  bool addressScreenButton = false;

  String addressName = '';
  int deliveryPrice = 0;

  MyFavouriteAddressesModel addedAddress;

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
            height: 250,
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
      color: Colors.white,
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 15, top: 15),
              child: Text('Адрес отправки',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
          DestinationPointsSelector(
            destinationPoints: restaurant.destination_points,
            key: destinationPointsSelectorStateKey,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(left:15, right: 15, top: 15),
              child: InkWell(
                child: Container(
                  width: 340,
                  height: 60,
                  decoration: BoxDecoration(
                      color: Color(0xFF67C070),
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
        height: 200,
        child: buildAddressesListSelector()
      );
    }
    return Container(
      height: 200,
      child: FutureBuilder<List<MyFavouriteAddressesModel>>(
        future: MyFavouriteAddressesModel.getAddresses(),
        builder: (BuildContext context,
            AsyncSnapshot<List<MyFavouriteAddressesModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            myAddressesModelList = snapshot.data;
            myAddressesModelList
                .add(new MyFavouriteAddressesModel(tag: null));
            return buildAddressesListSelector();
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget buildAddressesListSelector(){
    return Column(
      children: <Widget>[
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
        Expanded(
          child: AddressSelector(myFavouriteAddressList: myAddressesModelList, parent:  this, addressSelectorKey: addressSelectorKey),
        )
      ],
    );
  }

  @override
  dispose() {
    super.dispose();
  }

  TextEditingController phoneNumberController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController addressValueController;

  @override
  Widget build(BuildContext context) {
    FocusNode focusNode;
    double totalPrice = 0;
    currentUser.cartDataModel.cart.forEach(
            (Order order) {
          if(order.food.variants != null && order.food.variants.length > 0 && order.food.variants[0].price != null){
            totalPrice += order.quantity * (order.food.price + order.food.variants[0].price);
          }else{
            totalPrice += order.quantity * order.food.price;
          }
          double toppingsCost = 0;
          if(order.food.toppings != null){
            order.food.toppings.forEach((element) {
              toppingsCost += order.quantity * element.price;
            });
            totalPrice += toppingsCost;
          }
        }
    );
    return Scaffold(
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
//                                      animation = CurvedAnimation(
//                                          curve: Curves.bounceIn, parent: animation);
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
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 15, bottom: 15),
                        child: Text('Адрес отправки',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF424242))),
                      ),
                    ),
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Container(
                          height: 64,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 8.0, // soften the shadow
                                  spreadRadius: 3.0, //extend the shadow
                                )
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(width: 1.0, color: Colors.grey[200])),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('С какого адреса вам отправить?',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFFB8B8B8)
                                      ),
                                    ),
                                    Text('Изменить',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15, top: 15),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    height: 20,
                                    child: TextField(
                                      controller: addressValueController,
                                      enabled: false,
                                      decoration: new InputDecoration(
                                        border: InputBorder.none,
                                        counterText: '',
                                      ),
                                      style: TextStyle(
                                        fontSize: 16
                                      ),
                                    ),
                                  )
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      onTap: (){
                        _dispatchAddress();
                      },
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(top: 10, left: 15),
                    //   child: Row(
                    //     children: <Widget>[
                    //       //_buildTextFormField('Адрес доставки')
                    //       Text(
                    //         'Адрес доставки',
                    //         style: TextStyle(
                    //             color: Color(0xFFB0B0B0),
                    //             fontSize: 11),
                    //       )
                    //     ],
                    //   ),
                    // ),
                    // Padding(
                    //     padding: EdgeInsets.only(left: 15, top: 5),
                    //     child: Container(
                    //       height: 40,
                    //       child: TextField(
                    //         controller: addressField,
                    //         readOnly: true,
                    //         onTap: (){
                    //           if(autoComplete.controller != null){
                    //             print('nazaho');
                    //             autoComplete.controller
                    //                 .text = addressField.text;
                    //           }
                    //           _autocomplete(autoComplete);
                    //         },
                    //         focusNode: focusNode,
                    //         decoration: new InputDecoration(
                    //           border: InputBorder.none,
                    //           counterText: '',
                    //         ),
                    //       ),
                    //     )),
                    // Padding(
                    //   padding: EdgeInsets.only(left: 15, right: 15),
                    //   child: Divider(
                    //       height: 1.0, color: Color(0xFFEDEDED)),
                    // ),
                       buildAddressesList(),
                    Padding(
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
                            width: 60,
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
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Divider(
                          height: 1.0, color: Color(0xFFEDEDED)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 15, left: 15, bottom: 5),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Комментарий',
                            style: TextStyle(
                                color: Color(0xFFB0B0B0),
                                fontSize: 13),
                          )
                        ],
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 15, bottom: 5),
                        child: Container(
                          height: 45,
                          child: TextField(
                            textCapitalization: TextCapitalization.sentences,
                            controller: commentField,
                            decoration: new InputDecoration(
                              border: InputBorder.none,
                              counterText: '',
                            ),
                          ),
                        )),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 10, left: 15, right: 15, bottom: 10),
                      child: (status2) ? Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8.0, // soften the shadow
                                spreadRadius: 3.0, //extend the shadow
                              )
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(width: 1.0, color: Colors.grey[200])),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'Заказ другому человеку',
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
                                        value: status2,
                                        onToggle: (value) {
                                          setState(() {
                                            status2 = value;
                                          });
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                child: TextField(
                                  controller: phoneNumberController,
                                  decoration: new InputDecoration(
                                    hintText: 'Номер телефона получателя',
                                    hintStyle: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey
                                    ),
                                    border: InputBorder.none,
                                    counterText: '',
                                  ),
                                ),
                              ),
                              Divider(color: Colors.grey,),
                              Container(
                                child: TextField(
                                  controller: nameController,
                                  decoration: new InputDecoration(
                                    hintText: 'Имя получателя',
                                    hintStyle: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey
                                    ),
                                    border: InputBorder.none,
                                    counterText: '',
                                  ),
                                ),
                              ),
                              Divider(color: Colors.grey,),
                            ],
                          ),
                        ),
                      ) : Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8.0, // soften the shadow
                                spreadRadius: 3.0, //extend the shadow
                              )
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(width: 1.0, color: Colors.grey[200])),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Заказ другому человеку',
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
                                  value: status2,
                                  onToggle: (value) {
                                    setState(() {
                                      status2 = value;
                                    });
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Divider(
                          height: 1.0, color: Color(0xFFEDEDED)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 15, left: 15, bottom: 5, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Стомость',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14),
                          ),
                          Text(
                            '${(totalPrice).toStringAsFixed(0)} \₽',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 15, left: 15, bottom: 5, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Доставка',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14),
                          ),
                          Text(
                            '30-50 мин.',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 15, left: 15, bottom: 5, right: 15),
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
                    Container(
                      height: 10,
                      color: Color(0xFAFAFAFA),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 10, left: 15, right: 15, bottom: 10),
                      child: Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8.0, // soften the shadow
                                spreadRadius: 3.0, //extend the shadow
                              )
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(width: 1.0, color: Colors.grey[200])),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'До двери',
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
                                  value: status1,
                                  onToggle: (value) {
                                    setState(() {
                                      status1 = value;
                                    });
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 10, left: 15, right: 15, bottom: 10),
                      child: Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8.0, // soften the shadow
                                spreadRadius: 3.0, //extend the shadow
                              )
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(width: 1.0, color: Colors.grey[200])),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 10, left: 15, right: 15, bottom: 10),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                children: [
                                  Text(
                                    'Время доставки',
                                    style: TextStyle(
                                        color: Color(0xFF3F3F3F),
                                        fontSize: 15),
                                  ),
                                  Text(
                                    '30-40 мин',
                                    style: TextStyle(
                                        color: Color(0xFF3F3F3F),
                                        fontSize: 15),
                                  ),
                                ],
                              ),
                              Text(
                                'Изменить',
                                style: TextStyle(
                                    color: Color(0xFF3F3F3F),
                                    fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 10,
                      color: Color(0xFAFAFAFA),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: 10, left: 15, right: 15, bottom: 10),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: GestureDetector(
                              child: Container(
                                width: 167,
                                height: 64,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 8.0, // soften the shadow
                                        spreadRadius: 3.0, //extend the shadow
                                      )
                                    ],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(width: 1.0, color: Colors.grey[200])),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 10, left: 15, right: 15, bottom: 10),
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
                                            (selectedPaymentId == 1) ? card : cash,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 10),
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
                          padding: EdgeInsets.only(
                              top: 10, left: 0, right: 15, bottom: 10),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: InkWell(
                              child: Container(
                                width: 140,
                                height: 64,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 8.0, // soften the shadow
                                        spreadRadius: 3.0, //extend the shadow
                                      )
                                    ],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(width: 1.0, color: Colors.grey[200])),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 10, left: 15, right: 15, bottom: 10),
                                  child: Center(child: Text('  Введите\nпромокод')),
                                ),
                              ),
                              onTap: () async {
                                _promoCode();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20, left: 15, right: 15, top: 10),
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
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                        color: Color(0xFF67C070),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.only(
                            left: 60, top: 20, right: 60, bottom: 20),
                        onPressed: () async {
                          if (await Internet.checkConnection()) {
                            if(selectedPaymentId != 1){
                              showAlertDialog(context);
                            }
                            createOrder = new CreateOrder(
                              address: addressSelectorKey.currentState.myFavouriteAddressesModel.address,
                              restaurantAddress: selectedAddress,
                              office: officeField.text,
                              floor: floorField.text,
                              entrance: entranceField.text,
                              intercom: intercomField.text,
                              comment: commentField.text,
                              cartDataModel: currentUser.cartDataModel,
                              restaurant: restaurant,
                              payment_type: (selectedPaymentId == 1) ? 'card' : 'cash',
                              door_to_door: status1,
                            );
                            if(selectedPaymentId == 1){
                              _cardPayment(totalPrice);
                              return;
                            }
                            print('Payment');
                            await createOrder.sendData();
                            currentUser.cartDataModel.cart.clear();
                            currentUser.cartDataModel.saveData();
//                            homeScreenKey = new GlobalKey<HomeScreenState>();
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
              )
            ],
          )
      ),);
  }
}

class TakeAway extends StatefulWidget {
  TakeAway({Key key, this.restaurant}) : super(key: key);
  final Records restaurant;
  String name = '';

  @override
  TakeAwayState createState() => TakeAwayState(restaurant);
}

class TakeAwayState extends State<TakeAway>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  String address = 'Адрес доставки';
  String office;
  String floor;
  String comment;
  String delivery;
  final Records restaurant;
  String name = '';
  bool _color;
  bool status1 = false;


  TakeAwayState(this.restaurant);


  _promoCode() {
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
            child: _buildPromoCodeBottomNavigationMenu(),
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                )),
          );
        });
  }

  TextEditingController promoCodeField = new TextEditingController();

  _buildPromoCodeBottomNavigationMenu() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 80, bottom: 100),
      child: Container(
        height: 40,
        width: 300,
        decoration: BoxDecoration(
          color: Color(0xFFF6F6F6),
          border: Border.all(
            color: Color(0xFF67C070),
          ),
          borderRadius: const BorderRadius.all(
            const Radius.circular(10.0),
          ),
        ),
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.only(top: 0),
                child: TextField(
                  controller: promoCodeField,
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                  maxLength: 4,
                  keyboardType: TextInputType.number,
                  decoration: new InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),),
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    counterText: '',
                    hintStyle: TextStyle(
                        color: Color(0xFFC0BFC6),
                        fontSize: 14
                    ),
                    hintText: 'Введите промокод',
                  ),
                )
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10),),
                ),
                child: Text('Применить',
                  style: TextStyle(
                      fontSize: 21,
                    color: Colors.white
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
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
                      child: CircularProgressIndicator(),
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
            height: 120,
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
      height: 120,
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
                          child: (selectedPaymentId == 1) ? SvgPicture.asset('assets/svg_images/pay_circle.svg') : SvgPicture.asset('assets/svg_images/accessed_pay_circle.svg'),
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
                          child: (selectedPaymentId == 0) ? SvgPicture.asset('assets/svg_images/pay_circle.svg') : SvgPicture.asset('assets/svg_images/accessed_pay_circle.svg'),
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
                      padding: EdgeInsets.only(left: 15, top: 20, bottom: 20),
                      child: Text(
                        'Отправляем ваш заказ в систему',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF424242)),
                      ),
                    ),
                    Center(
                      child: CircularProgressIndicator(),
                    )
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
            height: 250,
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
      color: Colors.white,
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 15, top: 15),
              child: Text('Адрес отправки',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
          DestinationPointsSelector(
            destinationPoints: restaurant.destination_points,
            key: destinationPointsSelectorStateKey,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(left:15, right: 15, top: 15),
              child: InkWell(
                child: Container(
                  width: 340,
                  height: 60,
                  decoration: BoxDecoration(
                      color: Color(0xFF67C070),
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


  int selectedPageId = 0;
  GlobalKey<TakeAwayState> takeAwayScreenKey = new GlobalKey<TakeAwayState>();
  GlobalKey<AddressScreenState> addressScreenKey = new GlobalKey<AddressScreenState>();

  List<MyFavouriteAddressesModel> myAddressesModelList;
  MyFavouriteAddressesModel myAddressesModel;

  String cash_image = 'assets/svg_images/dollar_bills.svg';
  String card_image = 'assets/svg_images/visa.svg';
  String cash = 'Наличными';
  String card = 'Картой';
  int selectedPaymentId = 0;
  bool status2 = false;

  CreateOrderTakeAway createOrderTakeAway;
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

                      await createOrderTakeAway.sendData();
                      currentUser.cartDataModel.cart.clear();
                      currentUser.cartDataModel.saveData();
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
  TextEditingController addressValueController;
  InitialAddressModel selectedAddress;

  @override
  void initState() {
    super.initState();
    addressValueController = TextEditingController(text: restaurant.destination_points[0].street + ' ' + restaurant.destination_points[0].house);
    selectedAddress = restaurant.destination_points[0];
  }

  String title = 'Наличными';
  String image = 'assets/svg_images/dollar_bills.svg';

  GlobalKey<FormState> _foodItemFormKey = GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldStateKey = GlobalKey();
  GlobalKey<AutoCompleteDemoState> destinationPointsKey = new GlobalKey();
  GlobalKey<DestinationPointsSelectorState> destinationPointsSelectorStateKey =
  GlobalKey<DestinationPointsSelectorState>();
  TextEditingController commentField = new TextEditingController();
  final maxLines = 1;
  TextEditingController phoneNumberController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();

  bool f = false;
  GlobalKey<PromoCodeFieldState> promoCodeFieldKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    double totalPrice = 0;
    currentUser.cartDataModel.cart.forEach(
            (Order order) => totalPrice += order.quantity * order.food.price);
    return Scaffold(
      key: _scaffoldStateKey,
      resizeToAvoidBottomPadding: false,
      body: Container(
          color: Colors.white,
          child: Column(
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
                                    return CartPageScreen(restaurant: restaurant,);
                                  },
                                  transitionDuration: Duration(milliseconds: 300),
                                  transitionsBuilder:
                                      (context, animation, anotherAnimation, child) {
//                                      animation = CurvedAnimation(
//                                          curve: Curves.bounceIn, parent: animation);
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
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, bottom: 15),
                        child: Text('Адрес отправки',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Container(
                          height: 64,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 8.0, // soften the shadow
                                  spreadRadius: 3.0, //extend the shadow
                                )
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(width: 1.0, color: Colors.grey[200])),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('С какого адреса вам отправить?',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFFB8B8B8)
                                      ),
                                    ),
                                    Text('Изменить',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15, top: 15),
                                child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      height: 20,
                                      child: TextField(
                                        controller: addressValueController,
                                        enabled: false,
                                        decoration: new InputDecoration(
                                          border: InputBorder.none,
                                          counterText: '',
                                        ),
                                        style: TextStyle(
                                            fontSize: 16
                                        ),
                                      ),
                                    )
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      onTap: (){
                        _dispatchAddress();
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      child: Divider(
                        height: 1,
                        color: Color(0xFFF5F5F5),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 10, left: 15, right: 15, bottom: 10),
                      child: (status2) ? Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8.0, // soften the shadow
                                spreadRadius: 3.0, //extend the shadow
                              )
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(width: 1.0, color: Colors.grey[200])),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'Заказ другому человеку',
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
                                        value: status2,
                                        onToggle: (value) {
                                          setState(() {
                                            status2 = value;
                                          });
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                child: TextField(
                                  controller: phoneNumberController,
                                  decoration: new InputDecoration(
                                    hintText: 'Номер телефона получателя',
                                    hintStyle: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey
                                    ),
                                    border: InputBorder.none,
                                    counterText: '',
                                  ),
                                ),
                              ),
                              Divider(color: Colors.grey,),
                              Container(
                                child: TextField(
                                  controller: nameController,
                                  decoration: new InputDecoration(
                                    hintText: 'Имя получателя',
                                    hintStyle: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey
                                    ),
                                    border: InputBorder.none,
                                    counterText: '',
                                  ),
                                ),
                              ),
                              Divider(color: Colors.grey,),
                            ],
                          ),
                        ),
                      ) : Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8.0, // soften the shadow
                                spreadRadius: 3.0, //extend the shadow
                              )
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(width: 1.0, color: Colors.grey[200])),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Заказ другому человеку',
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
                                  value: status2,
                                  onToggle: (value) {
                                    setState(() {
                                      status2 = value;
                                    });
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Divider(
                          height: 1.0, color: Color(0xFFEDEDED)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 15, left: 15, bottom: 5, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Стомость',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14),
                          ),
                          Text(
                            '${(totalPrice).toStringAsFixed(0)} \₽',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 15, left: 15, bottom: 5, right: 15),
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
                    Container(
                      height: 10,
                      color: Color(0xFAFAFAFA),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8.0, // soften the shadow
                              spreadRadius: 3.0, //extend the shadow
                            )
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(width: 1.0, color: Colors.grey[200])),
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 10, left: 15, right: 15, bottom: 10),
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
                                value: status1,
                                onToggle: (value) {
                                  setState(() {
                                    status1 = value;
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 15, left: 15, bottom: 5),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Комментарий',
                            style: TextStyle(
                                color: Color(0xFFB0B0B0),
                                fontSize: 13),
                          )
                        ],
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 15, bottom: 5),
                        child: Container(
                          height: 45,
                          child: TextField(
                            textCapitalization: TextCapitalization.sentences,
                            controller: commentField,
                            decoration: new InputDecoration(
                              border: InputBorder.none,
                              counterText: '',
                            ),
                          ),
                        )),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: 10, left: 15, right: 15, bottom: 10),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: GestureDetector(
                              child: Container(
                                width: 167,
                                height: 64,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 8.0, // soften the shadow
                                        spreadRadius: 3.0, //extend the shadow
                                      )
                                    ],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(width: 1.0, color: Colors.grey[200])),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 10, left: 15, right: 15, bottom: 10),
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
                                            (selectedPaymentId == 1) ? card : cash,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 10),
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
                          padding: EdgeInsets.only(
                              top: 10, left: 0, right: 15, bottom: 10),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: InkWell(
                              child: Container(
                                width: 140,
                                height: 64,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 8.0, // soften the shadow
                                        spreadRadius: 3.0, //extend the shadow
                                      )
                                    ],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(width: 1.0, color: Colors.grey[200])),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 10, left: 15, right: 15, bottom: 10),
                                  child: Center(child: Text('  Введите\nпромокод')),
                                ),
                              ),
                              onTap: () async {
                                _promoCode();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20, left: 15, right: 15, top: 10),
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
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                        color: Color(0xFF67C070),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.only(
                            left: 60, top: 20, right: 60, bottom: 20),
                        onPressed: () async {
                          if (await Internet.checkConnection()) {
                            if(selectedPaymentId != 1){
                              showAlertDialog(context);
                            }
                            createOrderTakeAway =
                            new CreateOrderTakeAway(
                                comment: (status1) ? "Поем в заведении" : comment,
                                cartDataModel: currentUser.cartDataModel,
                                restaurantAddress: selectedAddress,
                                without_delivery: true,
                                restaurant: restaurant);
                            if(selectedPaymentId == 1){
                              _cardPayment(totalPrice);
                              return;
                            }
                            await createOrderTakeAway.sendData();
                            currentUser.cartDataModel.cart.clear();
                            currentUser.cartDataModel.saveData();
//                            homeScreenKey = new GlobalKey<HomeScreenState>();
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
              )
            ],
          )
      ),);
  }
}


class AddressSelector extends StatefulWidget {
  List<MyFavouriteAddressesModel> myFavouriteAddressList;
  AddressScreenState parent;
  GlobalKey<AddressSelectorState> addressSelectorKey;

  AddressSelector({this.addressSelectorKey, this.myFavouriteAddressList, this.parent}) : super(key: addressSelectorKey);

  @override
  AddressSelectorState createState() => AddressSelectorState(myFavouriteAddressList, parent);
}

class AddressSelectorState extends State<AddressSelector> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;
  MyFavouriteAddressesModel myFavouriteAddressesModel = null;
  List<MyFavouriteAddressesModel> myFavouriteAddressList;
  AddressScreenState parent;

  AddressSelectorState(this.myFavouriteAddressList, this.parent);

  void initState() {
    if(myFavouriteAddressList.length > 0){
      myFavouriteAddressesModel = myFavouriteAddressList[0];
    }
  }


  Widget build(BuildContext context) {
    List<Widget> widgetsList = new List<Widget>();
    myFavouriteAddressList.forEach((element) {
      if(element.tag == null) {
        widgetsList.add(GestureDetector(
            child: Row(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: EdgeInsets.only(
                          top: 15, left: 30, bottom: 15),
                      child: GestureDetector(
                          child: Row(
                            children: <Widget>[
                              SvgPicture.asset(
                                  'assets/svg_images/address_screen_plus.svg'),
                              Padding(
                                padding:
                                EdgeInsets.only(left: 20),
                                child: Text(
                                  'Добавить новый адрес',
                                  style: TextStyle(
                                      fontSize: 17,
                                      color:
                                      Color(0xFF424242)),
                                ),
                              )
                            ],
                          ),
                          onTap: () async {
                            if (await Internet.checkConnection()) {
                              Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) {
                                      return new AddAddressScreen(
                                          myAddressesModel:
                                          element,
                                          parent: parent
                                      );
                                    }),
                              );
                            } else {
                              noConnection(context);
                            }
                          })),
                ),
              ],
            )));
      } else {
        widgetsList.add(
            Padding(
              padding: const EdgeInsets.only(right: 15, left: 15, bottom: 10),
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: InkWell(
                      child: Container(
                        child: Row(
                          children: [
                            (myFavouriteAddressesModel == element)
                                ? SvgPicture.asset(
                                'assets/svg_images/address_screen_selector.svg')
                                :
                            SvgPicture.asset(
                                'assets/svg_images/circle.svg'),
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.only(left: 15),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 10, bottom: 5),
                                    child: Text(
                                      element.address.street + ' ' +
                                          element.address.house,
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () async {
                        setState(() {
                          myFavouriteAddressesModel = element;
                        });
                        print('chegokogo' + element.address.unrestrictedValue);
                      },
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 20,
                    color: Colors.grey,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: InkWell(
                      child: SvgPicture.asset(
                          'assets/svg_images/edit.svg'),
                      onTap: () async {
                        if (await Internet.checkConnection()) {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) {
                                  return new AddAddressScreen(
                                    myAddressesModel: element,
                                    parent: parent,
                                  );
                                }),
                          );
                        } else {
                          noConnection(context);
                        }
                      },
                    ),
                  ),
                ],
              ),
            )
        );
      }
    });
    return Container(
      color: Colors.white,
      child: ScrollConfiguration(
        behavior: new ScrollBehavior(),
        child: SingleChildScrollView(
          child: Column(
            children: widgetsList,
          ),
        ),
      ),
    );
  }
}

class DestinationPointsSelector extends StatefulWidget {
  final List<DestinationPoints> destinationPoints;

  DestinationPointsSelector({Key key, this.destinationPoints}) : super(key: key);

  @override
  DestinationPointsSelectorState createState() {
    return new DestinationPointsSelectorState(destinationPoints);
  }

}

class DestinationPointsSelectorState extends State<DestinationPointsSelector> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;
  DestinationPoints selectedDestinationPoint;
  List<DestinationPoints> destinationPointsList;

  DestinationPointsSelectorState(this.destinationPointsList);

  @override
  void initState() {
    if(destinationPointsList.length > 0){
      selectedDestinationPoint = destinationPointsList[0];
    }
    super.initState();
  }

  Widget build(BuildContext context) {
    super.build(context);
    List<Widget> widgetsList = new List<Widget>();
    destinationPointsList.forEach((element) {
      widgetsList.add(
          Padding(
            padding: EdgeInsets.only(right: 0),
            child: ListTile(
              contentPadding: EdgeInsets.only(right: 5, left: 15),
              title: InkWell(
                child: Container(
                  child: Row(
                    children: [
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.only(left: 15),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  right: 10, bottom: 5),
                              child: Text(
                                element.unrestrictedValue,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () async {
                  setState(() {
                    selectedDestinationPoint = element;
                  });
                },
              ),
              leading: InkWell(
                child: (selectedDestinationPoint == element)
                    ? SvgPicture.asset(
                    'assets/svg_images/address_screen_selector.svg')
                    :
                SvgPicture.asset(
                    'assets/svg_images/circle.svg'),
                onTap: ()async {
                  setState(() {
                    selectedDestinationPoint = element;
                  });
                },
              )
            ),
          )
      );
    });
    return Container(
      color: Colors.white,
      child: ScrollConfiguration(
        behavior: new ScrollBehavior(),
        child: SingleChildScrollView(
          child: Column(
            children: widgetsList,
          ),
        ),
      ),
    );
  }
}

class OrderSuccessScreen extends StatefulWidget {
  final String name;

  OrderSuccessScreen({Key key, this.name}) : super(key: key);

  @override
  OrderSuccessScreenState createState() {
    return new OrderSuccessScreenState(name);
  }
}

class OrderSuccessScreenState extends State<OrderSuccessScreen> {
  final String name;

  OrderSuccessScreenState(this.name);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: (necessaryDataForAuth.name == '') ? Text('Ваш заказ принят!', style: TextStyle(
                      fontSize: 24
                  ),) : Text(name + ', ваш заказ принят! ',
                    style: TextStyle(
                        fontSize: 24
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(top: 60),
                  child: Text('Вы можете отследить его статус\nна главной странце!',
                    style: TextStyle(
                        fontSize: 18
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Padding(
                    padding:
                    EdgeInsets.only(bottom: 15, left: 15, right: 15, top: 15),
                    child: FlatButton(
                      child: Text(
                        'Продолжить',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      color: Color(0xFF67C070),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.only(
                          left: 110, top: 20, right: 110, bottom: 20),
                      onPressed: () {
                        homeScreenKey = new GlobalKey<HomeScreenState>();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => HomeScreen()),
                                (Route<dynamic> route) => false);
                      },
                    ),
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }
}

class PromoCodeField extends StatefulWidget {
  PromoCodeField({Key key}) : super(key: key);

  @override
  PromoCodeFieldState createState() {
    return new PromoCodeFieldState();
  }
}

class PromoCodeFieldState extends State<PromoCodeField> {
  PromoCodeFieldState();
  TextEditingController controller = new TextEditingController();
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 64,
      child: TextField(
        controller: controller,
        decoration: new InputDecoration(
          border: InputBorder.none,
          counterText: '',
        ),
      ),
    );
  }
}