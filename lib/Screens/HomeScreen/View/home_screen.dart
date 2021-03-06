import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Centrifugo/API/fcm.dart';
import 'package:flutter_app/Centrifugo/API/test_fcm.dart';
import 'package:flutter_app/Centrifugo/centrifugo.dart';
import 'package:flutter_app/Config/config.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/Preloader/device_id_screen.dart';
import 'package:flutter_app/Screens/AuthScreen/Bloc/phone_number_get_bloc.dart';
import 'package:flutter_app/Screens/AuthScreen/View/auth_screen.dart';
import 'package:flutter_app/Screens/CartScreen/API/get_cart_by_device_id.dart';
import 'package:flutter_app/Screens/CartScreen/View/cart_page_view.dart';
import 'package:flutter_app/Screens/ChatScreen/API/create_message.dart';
import 'package:flutter_app/Screens/ChatScreen/API/get_filtered_messages.dart';
import 'package:flutter_app/Screens/HomeScreen/API/getStocks.dart';
import 'package:flutter_app/Screens/HomeScreen/Bloc/restaurant_get_bloc.dart';
import 'package:flutter_app/Screens/HomeScreen/Bloc/restaurant_get_event.dart';
import 'package:flutter_app/Screens/HomeScreen/Bloc/restaurant_get_state.dart';
import 'package:flutter_app/Screens/HomeScreen/Model/FilteredStores.dart';
import 'package:flutter_app/Screens/HomeScreen/Model/Stock.dart';
import 'package:flutter_app/Screens/HomeScreen/Widgets/Filter.dart';
import 'package:flutter_app/Screens/HomeScreen/Widgets/OrderChecking.dart';
import 'package:flutter_app/Screens/HomeScreen/Widgets/RestaurantsList.dart';
import 'package:flutter_app/Screens/HomeScreen/View/promo_screen.dart';
import 'package:flutter_app/Screens/HomeScreen/Widgets/StockList.dart';
import 'package:flutter_app/Screens/InformationScreen/View/infromation_screen.dart';
import 'package:flutter_app/Screens/OrdersScreen/View/orders_story_screen.dart';
import 'package:flutter_app/Screens/PaymentScreen/View/payment_screen.dart';
import 'package:flutter_app/Screens/ProfileScreen/View/profile_screen.dart';
import 'package:flutter_app/Screens/RestaurantScreen/View/grocery_screen.dart';
import 'package:flutter_app/Screens/RestaurantScreen/View/restaurant_screen.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../Preloader/device_id_screen.dart';
import '../../../data/data.dart';
import '../../CartScreen/Model/CartModel.dart';
import '../../ChatScreen/View/chat_screen.dart';
import '../../CityScreen/View/city_screen.dart';
import '../../RestaurantScreen/Widgets/CartButton/CartButton.dart';
import '../Model/FilteredStores.dart';


class HomeScreen extends StatefulWidget {
  HomeScreen() : super(key: homeScreenKey);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver{
  List<OrderChecking> orderList;
  List<FilteredStores> recordsItems;
  GlobalKey<ScaffoldState> _scaffoldKey;
  List<Widget> stocksItems;
  ScrollController stocksScrollController;
  GlobalKey<CartButtonState> basketButtonStateKey;
  Filter filter;
  RestaurantsList restaurantsList;
  GlobalKey<CityScreenState> cityScreenKey;
  RestaurantGetBloc restaurantGetBloc;
  CartButton cartButton;
  Timer timer;




  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    stocksScrollController = new ScrollController();
    Future.delayed(Duration.zero, () {

      checkVer(context);

    });
    orderList = new List<OrderChecking>();
    recordsItems = new List<FilteredStores>();
    _scaffoldKey = new GlobalKey<ScaffoldState>();
    basketButtonStateKey = new GlobalKey<CartButtonState>();
    cityScreenKey = new GlobalKey<CityScreenState>();
    restaurantGetBloc = BlocProvider.of<RestaurantGetBloc>(context);
    restaurantGetBloc.add(InitialLoad());
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    stocksScrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed){
      setState(() {

      });
    }
  }

  List<Widget> getSideBarItems(bool isLogged) {
    List<Widget> allSideBarItems = [
      Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: ListTile(
          leading: SvgPicture.asset('assets/svg_images/info.svg'),
          title: Text(
            'Информация',
            style: TextStyle(
                fontSize: 17, color: Color(0xFF424242), letterSpacing: 0.45),
          ),
          onTap: () async {
            if (await Internet.checkConnection()) {
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => new InformationScreen(),
                ),
              );
            } else {
              noConnection(context);
            }
          },
        ),
      ),
    ];

    if (isLogged) {
      allSideBarItems.insertAll(0, [
        Padding(
          padding: EdgeInsets.only(top: 0),
          child: InkWell(
            child: Container(
              color: AppColor.mainColor,
              child: ListTile(
                title: Text(
                  necessaryDataForAuth.name ?? ' ',
                  style: TextStyle(
                      color: AppColor.textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                ),
                subtitle: Text(
                  necessaryDataForAuth.phone_number ?? ' ',
                  style: TextStyle(color: AppColor.textColor, fontSize: 14),
                ),
                trailing: GestureDetector(
                  child: SvgPicture.asset(
                      'assets/svg_images/pencil.svg'),
                ),
              ),
            ),
            onTap: () async {
              if (await Internet.checkConnection()) {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => new ProfileScreen(),
                  ),
                );
              } else {
                noConnection(context);
              }
            },
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.only(top: 10, bottom: 10),
        //   child: ListTile(
        //     leading: SvgPicture.asset('assets/svg_images/pay.svg'),
        //     title: Text(
        //       'Способы оплаты',
        //       style: TextStyle(
        //           fontSize: 17, color: Color(0xFF424242), letterSpacing: 0.45),
        //     ),
        //     onTap: () async {
        //       if (await Internet.checkConnection()) {
        //         Navigator.push(
        //           context,
        //           new MaterialPageRoute(
        //             builder: (context) => new PaymentScreen(),
        //           ),
        //         );
        //       } else {
        //         noConnection(context);
        //       }
        //     },
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: ListTile(
            leading: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: SvgPicture.asset('assets/svg_images/order_story.svg'),
            ),
            title: Text(
              'История заказов',
              style: TextStyle(
                  fontSize: 17, color: Color(0xFF424242), letterSpacing: 0.45),
            ),
            onTap: () async {
              if (await Internet.checkConnection()) {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => new OrdersStoryScreen(),
                  ),
                );
              } else {
                noConnection(context);
              }
            },
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.only(top: 10, bottom: 10),
        //   child: ListTile(
        //     leading: SvgPicture.asset('assets/svg_images/my_addresses.svg'),
        //     title: Text(
        //       'Мои адреса',
        //       style: TextStyle(
        //           fontSize: 17, color: Color(0xFF424242), letterSpacing: 0.45),
        //     ),
        //     onTap: () async {
        //       if (await Internet.checkConnection()) {
        //         Navigator.push(
        //           context,
        //           new MaterialPageRoute(
        //             builder: (context) => new MyAddressesScreen(),
        //           ),
        //         );
        //       } else {
        //         noConnection(context);
        //       }
        //     },
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: ListTile(
            leading: SvgPicture.asset('assets/svg_images/service.svg'),
            title: Text(
              'Служба поддержки',
              style: TextStyle(
                  fontSize: 17, color: Color(0xFF424242), letterSpacing: 0.45),
            ),
            onTap: () async {
              if (await Internet.checkConnection()) {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => new ChatScreen(),
                  ),
                );
              } else {
                noConnection(context);
              }
            },
          ),
        ),
      ]);
      allSideBarItems.add(
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: ListTile(
            leading: SvgPicture.asset('assets/svg_images/exit.svg'),
            title: Text(
              'Выход',
              style: TextStyle(
                  fontSize: 17, color: Color(0xFF424242), letterSpacing: 0.45),
            ),
            onTap: () async {
              if (await Internet.checkConnection()) {
                necessaryDataForAuth.refresh_token = null;
                authCodeData.refreshToken.value = null;
                authCodeData.token = null;
                await NecessaryDataForAuth.saveData();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => DeviceIdScreen()),
                        (Route<dynamic> route) => false);
              } else {
                noConnection(context);
              }
            },
          ),
        ),
      );
    } else {
      allSideBarItems.insert(
          0,
          Padding(
            padding: EdgeInsets.only(top: 0),
            child: ListTile(
                title: InkWell(
                  child: Padding(
                    padding: EdgeInsets.only(top: 0, bottom: 20),
                    child: Text(
                      'Авторизоваться',
                      style: TextStyle(
                          fontSize: 17,
                          color: Color(0xFF424242),
                          letterSpacing: 0.45),
                    ),
                  ),
                  onTap: () async {
                    if (await Internet.checkConnection()) {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context)=> AuthGetBloc(),
                            child: AuthScreen(),
                          ),
                        ),
                      );
                    } else {
                      noConnection(context);
                    }
                  },
                )),
          ));
    }
    return allSideBarItems;
  }



  @override
  Widget build(BuildContext context) {
    if(currentUser.isLoggedIn && Centrifugo.chat_subscription == null){
      getChatUuid().then((value) => Centrifugo.chatSubscription(value));
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarBrightness: Brightness.light
      ),
      child: Scaffold(
        backgroundColor: AppColor.themeColor,
        key: _scaffoldKey,
        drawer: ClipRRect(
          borderRadius: BorderRadius.only(topRight: Radius.circular(15), bottomRight: Radius.circular(15)),
          child: Drawer(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40, bottom: 10, right: 10),
                    child: Center(
                      child: Container(
                        height: 140,
                        child: Image(
                          image: AssetImage('assets/images/fermer.png'),
                          width: 150,
                        ),
                      )
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: getSideBarItems(currentUser.isLoggedIn),
                    ),
                  ),
                ],
              )
          ),
        ),
        body: BlocBuilder<RestaurantGetBloc, RestaurantGetState>(
            bloc: BlocProvider.of<RestaurantGetBloc>(context),
            builder: (BuildContext context,
                RestaurantGetState state) {
              if(state is RestaurantGetStateLoading){
                if(state.showPrelaoder){
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Color(0xFF141414),
                    ),
                    child: Center(
                      child: Image(
                          image: assetImage
                      ),
                    ),
                  );
                }else{
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Color(0xFF141414),
                    ),
                    child: Center(
                      child: Image(
                        image: AssetImage('assets/images/Fermer_yellow.png'),
                      ),
                    ),
                  );
                }
              }
              else if(state is RestaurantGetStateSuccess){
                recordsItems.clear();
                recordsItems.addAll(state.items);
                return Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 50, left: 16, right: 15, bottom: 10),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 0, top: 0),
                            child: InkWell(
                              hoverColor: AppColor.themeColor,
                              focusColor: AppColor.themeColor,
                              splashColor: AppColor.themeColor,
                              highlightColor: AppColor.themeColor,
                              child: Container(
                                height: 40,
                                width: 40,
                                padding: EdgeInsets.all(5),
                                child: SvgPicture.asset(
                                  'assets/svg_images/home_menu.svg',
                                  color: Colors.black,
                                ),
                              ),
                              onTap: () {
                                _scaffoldKey.currentState.openDrawer();
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: GestureDetector(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.63,
                                height: 38,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: AppColor.mainColor
                                ),
                                child: Center(
                                  child: Text(selectedCity.name,
                                    style: TextStyle(
                                        color: AppColor.textColor,
                                        fontSize: 13
                                    ),
                                  ),
                                ),
                              ),
                              onTap: (){
                                Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                    builder: (context) =>
                                    new CityScreen(),
                                  ),
                                );
                              },
                            ),
                          ),

                          // Padding(
                          //   padding: EdgeInsets.only(bottom: 0, top: 0),
                          //   child: InkWell(
                          //     child: SvgPicture.asset(
                          //       'assets/svg_images/search.svg',
                          //       color: Colors.black,),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.zero,
                        children: <Widget>[
                          FutureBuilder<List<Stock>>(
                              future: getStocks(necessaryDataForAuth.city.uuid),
                              builder: (context, AsyncSnapshot<List<Stock>> snapshot) {
                                return (snapshot.connectionState == ConnectionState.done || snapshot.hasData) ? Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 22, top: 15, right: 20),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Акции и новинки',
                                            style: TextStyle(
                                                fontSize: 28,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, left: 0, right: 0, bottom: 10),
                                        child: Container(
                                          height: 100,
                                          width: MediaQuery.of(context).size.width,
                                          child: SingleChildScrollView(
                                              physics: BouncingScrollPhysics(),
                                              scrollDirection: Axis.horizontal,
                                              controller: stocksScrollController,
                                              child: Row(
                                                children: List.generate(snapshot.data.length, (index){
                                                  return InkWell(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(left: 20, right: (
                                                          snapshot.data[index] == snapshot.data.last ? 20 : 0)),
                                                      child: Container(
                                                        width: MediaQuery.of(context).size.width * 0.7,
                                                        height: 100,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                        child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(10),
                                                            child: Image.network(snapshot.data[index].image,
                                                              fit: BoxFit.cover,),),
                                                      ),
                                                    ),
                                                    onTap: (){
                                                      var stock = snapshot.data[index];
                                                      if(stock.stores != null && stock.stores.isNotEmpty){
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(builder: (_) {
                                                            return PromoScreen(stock: stock,);
                                                          }),
                                                        );
                                                      }
                                                    },
                                                  );
                                                }),
                                              ),
                                          ),
                                        )
                                    ),
                                  ],
                                ) : Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 22, top: 15, right: 20),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Акции и новинки',
                                            style: TextStyle(
                                                fontSize: 28,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, left: 0, right: 0, bottom: 10),
                                        child: Container(
                                          height: 100,
                                          width: MediaQuery.of(context).size.width,
                                          child: SingleChildScrollView(
                                            physics: BouncingScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            controller: stocksScrollController,
                                            child: Row(
                                              children: List.generate(2, (index){
                                                return Padding(
                                                  padding: EdgeInsets.only(left: 20, right: (
                                                      index == 1 ? 20 : 0)),
                                                  child: Container(
                                                    width: MediaQuery.of(context).size.width * 0.7,
                                                    height: 100,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(10),
                                                        child: Image.asset('assets/images/load_image.png', fit: BoxFit.fill,)),
                                                  ),
                                                );
                                              }),
                                            ),
                                          ),
                                        )
                                    ),
                                  ],
                                );
                              }
                          ),
                          (!currentUser.isLoggedIn) ? Container() :
                          FutureBuilder<List<OrderChecking>>(
                            future: OrderChecking.getActiveOrder(),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<OrderChecking>> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done &&
                                  snapshot.data != null &&
                                  snapshot.data.length > 0) {
                                orderList = snapshot.data;
                                return (currentUser.isLoggedIn)
                                    ? Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: Container(
                                    height: 230,
                                    child: (snapshot.data.length > 1) ? ListView(
                                      children: snapshot.data,
                                      scrollDirection: Axis.horizontal,
                                    ) : Center(
                                      child: Row(
                                        children: snapshot.data,
                                      ),
                                    ),
                                  ),
                                ) : Container(
                                  height: 0,
                                );
                              } else {
                                orderList = null;
                                return Container(
                                  height: 0,
                                );
                              }
                            },
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(left: 22, top: 15, right: 20),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     children: [
                          //       Text('Акции и новинки',
                          //         style: TextStyle(
                          //             fontSize: 28,
                          //             fontWeight: FontWeight.bold
                          //         ),
                          //       ),
                          //       Row(
                          //         children: [
                          //           Padding(
                          //             padding: const EdgeInsets.only(top: 0, right: 10),
                          //             child: Text('Все',
                          //               style: TextStyle(
                          //                 fontSize: 14,
                          //                 color: Colors.grey,
                          //               ),
                          //             ),
                          //           ),
                          //           SvgPicture.asset('assets/svg_images/arrow_right.svg',
                          //             color: Colors.grey,
                          //           )
                          //         ],
                          //       )
                          //     ],
                          //   ),
                          // ),
                          // Promotion(),
                          SizedBox(
                            height: 10,
                          ),
                          // GestureDetector(
                          //   child: Container(
                          //     height: 40,width: 40,
                          //     child: Text('sdf'),
                          //   ),
                          //   onTap: () async {
                          //     createMessage('ka');
                          //   },
                          // ),
                          // Padding(
                          //   padding:
                          //   EdgeInsets.symmetric(horizontal: 20.0),
                          //   child: Text('Рестораны', // нужно добавить цвет для текста
                          //       // в некоторых прилагах и черный и белый текст
                          //       style: TextStyle(
                          //         fontSize: 28,
                          //         color: Color(0xFF3F3F3F),
                          //         fontWeight: FontWeight.bold,
                          //         letterSpacing: 1.2,
                          //       )),
                          // ),
                          filter = Filter(this),
                          (recordsItems.isEmpty) ?  Center(
                            child: Container(),
                          ) : restaurantsList = RestaurantsList(List.from(recordsItems), this, key: GlobalKey())
                        ],
                      ),
                    ),
                    cartButton != null ? cartButton :
                    FutureBuilder<CartModel>(
                        future: getCartByDeviceId(necessaryDataForAuth.device_id),
                        builder: (BuildContext context, AsyncSnapshot<CartModel> snapshot){
                          if(snapshot.connectionState == ConnectionState.done){
                            currentUser.cartModel = snapshot.data;
                            if(currentUser.cartModel == null
                                || currentUser.cartModel.items == null
                                || currentUser.cartModel.items.length < 1){
                              currentUser.cartModel = new CartModel();
                              return Container();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 0),
                              child: cartButton = CartButton(
                                key: basketButtonStateKey,
                                restaurant: FilteredStores.fromStoreData(currentUser.cartModel.storeData),
                                source: CartSources.Home,
                              ),
                            );
                          }
                          return Container();
                        }
                    )
                  ],
                );
              }else if(state is RestaurantGetStateEmpty){
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 50, left: 16, right: 15, bottom: 10),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 0, top: 0),
                            child: InkWell(
                              hoverColor: AppColor.themeColor,
                              focusColor: AppColor.themeColor,
                              splashColor: AppColor.themeColor,
                              highlightColor: AppColor.themeColor,
                              child: Container(
                                height: 40,
                                width: 40,
                                padding: EdgeInsets.all(5),
                                child: SvgPicture.asset(
                                  // добавить цвет для картинок 
                                  'assets/svg_images/home_menu.svg',
                                  color: Colors.black,
                                ),
                              ),
                              onTap: () {
                                _scaffoldKey.currentState.openDrawer();
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: GestureDetector(
                              child: Container(
                                width: 250,
                                height: 38,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: AppColor.mainColor
                                ),
                                child: Center(
                                  child: Text(selectedCity.name,
                                    style: TextStyle(
                                        color: AppColor.textColor,
                                        fontSize: 13
                                    ),
                                  ),
                                ),
                              ),
                              onTap: (){
                                Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                    builder: (context) =>
                                    new CityScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                          // Padding(
                          //   padding: EdgeInsets.only(bottom: 0, top: 0),
                          //   child: InkWell(
                          //     child: SvgPicture.asset(
                          //       'assets/svg_images/search.svg',
                          //       color: Colors.black,),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
                      child: Center(
                        child: Text('Нет заведений по этому городу'),
                      ),
                    ),
                  ],
                );
              }
              return Container();
            }),
      ),
    );
  }
}