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
import 'auto_complete.dart';
import 'home_screen.dart';


class PageScreen extends StatefulWidget {
  final Records restaurant;

  PageScreen({
    Key key,
    this.restaurant,
  }) : super(key: key);

  @override
  PageState createState() => PageState(restaurant);
}

class PageState extends State<PageScreen> {
  final Records restaurant;
  bool _color = false;
  CreateOrder createOrder;
  CreateOrderTakeAway createOrderTakeAway;

  PageState(this.restaurant);

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
    var addressScreen = AddressScreen(restaurant: restaurant, key: addressScreenKey,);
    var takeAwayScreen = TakeAway(restaurant: restaurant, key: takeAwayScreenKey,);
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
                              "Оформление заказа",
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
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 10, left: 20),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Способ оплаты",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFB0B0B0)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            GestureDetector(
              child: Padding(
                padding: EdgeInsets.only(left: 20, bottom: 5),
                child: Container(
                  child: Row(
                    children: <Widget>[
                      (selectedPaymentId == 1) ? SvgPicture.asset(card_image) : SvgPicture.asset(cash_image),
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Text(
                          (selectedPaymentId == 1) ? card : cash,
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
                            child: SvgPicture.asset('assets/svg_images/arrow_right.svg'),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              onTap: () async {
                _payment();
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 20, left: 15, right: 15, top: 10),
                child: FlatButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                          flex: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFE32636),
                              borderRadius:
                              BorderRadius.all(Radius.circular(5)),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                '30-50 мин.',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )),
                      Flexible(
                          flex: 0,
                          child: Padding(
                            padding: EdgeInsets.only(right: 20, left: 5),
                            child: Text('Оформить',
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white)),
                          )),
                      Flexible(
                          flex: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFE32636),
                              borderRadius:
                              BorderRadius.all(Radius.circular(5)),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                  '${(totalPrice).toStringAsFixed(0)} \₽',
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white)),
                            ),
                          )),
                    ],
                  ),
                  color: Color(0xFFFE534F),
                  splashColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.only(
                      left: 10, top: 10, right: 10, bottom: 10),
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
                            address: addressScreenKey.currentState.selectedAddress,
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
                        homeScreenKey = new GlobalKey<HomeScreenState>();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()),
                                (Route<dynamic> route) => false);
                      } else {
                        emptyFields(context);
                      }
                    } else {
                      noConnection(context);
                    }
                  },
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
  MyFavouriteAddressesModel myAddressesModel;

  AddressScreen(
      {Key key, this.restaurant, this.myAddressesModel})
      : super(key: key);
  final Records restaurant;

  @override
  AddressScreenState createState() =>
      AddressScreenState(restaurant, myAddressesModel);
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
  GlobalKey<DestinationPointsSelectorState>();

  GlobalKey<AutoCompleteDemoState> destinationPointsKey;

  AddressScreenState(this.restaurant, this.myAddressesModel);

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Инициализируем автокомплит
    destinationPointsKey = new GlobalKey();
    autoComplete = new AutoComplete(destinationPointsKey, 'Введите адрес',
        onSelected:() { // И навешием событие на выбор адреса
          // Переносим выбранный адрес в основной текстфилд
          addressField.text = destinationPointsKey.currentState
              .searchTextField.textFieldConfiguration.controller
              .text;
          // Заполняем последний выбранный адрес
          selectedAddress = destinationPointsKey.currentState.selectedValue;
          Navigator.pop(context);
        }
    );
  }

  bool status1 = false;
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

  String addressName = '';
  int deliveryPrice = 0;

  List<MyFavouriteAddressesModel> myAddressesModelList;
  MyFavouriteAddressesModel myAddressesModel;

  void _autocomplete(AutoComplete autoComplete) {
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
              height: MediaQuery.of(context).size.height * 0.8,
              child: Container(
                child: _buildAutocompleteBottomNavigationMenu(autoComplete),
                decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                    )),
              ));
        });
  }

  _buildAutocompleteBottomNavigationMenu(AutoComplete autoComplete) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 7),
                    child: Center(
                      child: Container(
                        width: 67,
                        height: 7,
                        decoration: BoxDecoration(
                            color: Color(0xFFEBEAEF),
                            borderRadius: BorderRadius.all(Radius.circular(11))),
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(bottom: 0, right: 15),
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                              left: 15,
                              top: 33,
                              bottom: 0,
                            ),
                            child: SvgPicture.asset('assets/svg_images/mini_black_ellipse.svg'),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: 3,
                              left: 25,
                              bottom: 5,
                            ),
                            child: autoComplete,
                          ),
                        ],
                      )),
                  Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: Divider(
                      color: Color(0xFFEDEDED),
                      height: 1,
                      thickness: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
    return Scaffold(
      key: _scaffoldStateKey,
      resizeToAvoidBottomPadding: false,
      body:  Container(
          color: Colors.white,
          child:  ListView(
            children: <Widget>[
              DestinationPointsSelector(
                destinationPoints: restaurant.destination_points,
                key: destinationPointsSelectorStateKey,
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, left: 15),
                child: Row(
                  children: <Widget>[
                    //_buildTextFormField('Адрес доставки')
                    Text(
                      'Адрес доставки',
                      style: TextStyle(
                          color: Color(0xFFB0B0B0),
                          fontSize: 11),
                    )
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 15, top: 5),
                  child: Container(
                    height: 40,
                    child: TextField(
                      controller: addressField,
                      readOnly: true,
                      onTap: (){
                        if(autoComplete.controller != null){
                          print('nazaho');
                          autoComplete.controller
                              .text = addressField.text;
                        }
                        _autocomplete(autoComplete);
                      },
                      focusNode: focusNode,
                      decoration: new InputDecoration(
                        border: InputBorder.none,
                        counterText: '',
                      ),
                    ),
                  )),
              Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Divider(
                    height: 1.0, color: Color(0xFFEDEDED)),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 15, left: 15, bottom: 5, right: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 150,
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
                      width: 150,
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
                    top: 15, left: 15, bottom: 5, right: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 150,
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
                      width: 150,
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
                      'Комментарий к заказу',
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
                      'Доставка',
                      style: TextStyle(
                          color: Color(0xFFB0B0B0),
                          fontSize: 13),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15, bottom: 5),
                child: Row(
                  children: <Widget>[
                    Text(
                      '30-50 мин.',
                      style: TextStyle(
                          color: Colors.black, fontSize: 13),
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
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Доставка до двери',
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
                        activeColor: Colors.red,
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
              Container(
                height: 10,
                color: Color(0xFAFAFAFA),
              ),
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

  @override
  void initState() {
    super.initState();
    _color = true;
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
          child: ListView(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(
                          bottom: 10, top: 15, left: 15),
                      child: Text(
                        'Адрес заведения',
                        style: TextStyle(
                            color: Color(0xFFB0B0B0), fontSize: 11),
                      )),
                ],
              ),
              Row(
                children: <Widget>[
                  Padding(
                      padding:
                      EdgeInsets.only(bottom: 10, top: 0, left: 15),
                      child: Text(
                        restaurant.name,
                        style: TextStyle(
                            color: Color(0xFF3F3F3F),
                            fontWeight: FontWeight.bold,
                            fontSize: 21),
                      )),
                ],
              ),
              DestinationPointsSelector(
                destinationPoints: restaurant.destination_points,
                key: destinationPointsSelectorStateKey,
              ),
              Padding(
                padding: EdgeInsets.only(top: 5, bottom: 5),
                child: Divider(
                  height: 1,
                  color: Color(0xFFF5F5F5),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15, left: 15, bottom: 5),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Комментарий к заказу',
                      style: TextStyle(
                          color: Color(0xFFB0B0B0), fontSize: 13),
                    )
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 15, bottom: 5),
                  child: Container(
                    height: 20,
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
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Divider(height: 1.0, color: Color(0xFFEDEDED)),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15, left: 15, bottom: 5),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Время готовки',
                      style: TextStyle(
                          color: Color(0xFFB0B0B0), fontSize: 13),
                    )
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 15, bottom: 5),
                  child: Container(
                    height: 20,
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      decoration: new InputDecoration(
                        border: InputBorder.none,
                        counterText: '',
                      ),
                    ),
                  )),
              Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Divider(height: 1.0, color: Color(0xFFEDEDED)),
              ),
              Padding(
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
                        activeColor: Colors.red,
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
              Container(
                height: 145,
                color: Color(0xFAFAFAFA),
              ),
            ],
          )
      ),);
  }
}

class DestinationPointsSelector extends StatefulWidget {
  List<DestinationPoints> destinationPoints;

  DestinationPointsSelector({Key key, this.destinationPoints}) : super(key: key);

  @override
  DestinationPointsSelectorState createState() => DestinationPointsSelectorState(destinationPoints);
}

class DestinationPointsSelectorState extends State<DestinationPointsSelector> {
  DestinationPoints selectedDestinationPoint = null;
  List<DestinationPoints> destinationPointsList;

  DestinationPointsSelectorState(this.destinationPointsList);

  void initState() {
    if(destinationPointsList.length > 0){
      selectedDestinationPoint = destinationPointsList[0];
    }
  }

  Widget build(BuildContext context) {
    List<Widget> widgetsList = new List<Widget>();
    destinationPointsList.forEach((element) {
      widgetsList.add(
          Padding(
            padding: EdgeInsets.only(right: 0),
            child: ListTile(
              contentPadding: EdgeInsets.only(right: 5),
              title: GestureDetector(
                child: Text(
                  element.unrestrictedValue,
                  style: TextStyle(color: Color(0xFF424242)),
                ),
                onTap: (){
                  setState(() {
                    selectedDestinationPoint = element;
                  });
                },
              ),
              leading: Radio(
                focusColor: Colors.red,
                value: element,
                groupValue: selectedDestinationPoint,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onChanged: (DestinationPoints value) {
                  setState(() {
                    selectedDestinationPoint = value;
                  });
                },
              ),
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