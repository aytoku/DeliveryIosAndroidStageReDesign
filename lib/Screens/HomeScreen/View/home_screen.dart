import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Config/config.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/Preloader/device_id_screen.dart';
import 'package:flutter_app/Screens/AuthScreen/View/auth_screen.dart';
import 'package:flutter_app/Screens/HomeScreen/API/getFilteredStores.dart';
import 'package:flutter_app/Screens/HomeScreen/Model/FilteredStores.dart';
import 'package:flutter_app/Screens/HomeScreen/Widgets/Filter.dart';
import 'package:flutter_app/Screens/HomeScreen/Widgets/OrderChecking.dart';
import 'package:flutter_app/Screens/HomeScreen/Widgets/Promotion.dart';
import 'package:flutter_app/Screens/HomeScreen/Widgets/RestaurantsList.dart';
import 'package:flutter_app/Screens/InformationScreen/View/infromation_screen.dart';
import 'package:flutter_app/Screens/MyAddressesScreen/View/my_addresses_screen.dart';
import 'package:flutter_app/Screens/OrdersScreen/View/orders_story_screen.dart';
import 'package:flutter_app/Screens/ProfileScreen/View/profile_screen.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/CartButton/CartButton.dart';
import 'package:flutter_app/Screens/ServiceScreen/View/service_screen.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/models/last_addresses_model.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';

import '../../CityScreen/View/city_screen.dart';


class HomeScreen extends StatefulWidget {
  HomeScreen() : super(key: homeScreenKey);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver{
  List<OrderChecking> orderList;
  List<FilteredStores> recordsItems = new List<FilteredStores>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey<CartButtonState> basketButtonStateKey = new GlobalKey<CartButtonState>();
  Filter filter;
  RestaurantsList restaurantsList;
  GlobalKey<CityScreenState> cityScreenKey = new GlobalKey<CityScreenState>();


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    filter = Filter(this, key: new GlobalKey<FilterState>());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed){
      setState(() {

      });
    }
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
              color: Color(0xFF09B44D),
              child: ListTile(
                title: Text(
                  necessaryDataForAuth.name ?? ' ',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                ),
                subtitle: Text(
                  necessaryDataForAuth.phone_number ?? ' ',
                  style: TextStyle(color: Colors.white, fontSize: 14),
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
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: ListTile(
            leading: SvgPicture.asset('assets/svg_images/my_addresses.svg'),
            title: Text(
              'Мои адреса',
              style: TextStyle(
                  fontSize: 17, color: Color(0xFF424242), letterSpacing: 0.45),
            ),
            onTap: () async {
              if (await Internet.checkConnection()) {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => new MyAddressesScreen(),
                  ),
                );
              } else {
                noConnection(context);
              }
            },
          ),
        ),
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
                    builder: (context) => new ServiceScreen(),
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
                authCodeData.refresh_token = null;
                await NecessaryDataForAuth.saveData();
                await LastAddressesModel.clear();
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
                          builder: (context) => new AuthScreen(),
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
            height: 200,
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
              padding: const EdgeInsets.only(left: 15, top: 30, bottom: 20),
              child: Row(
                children: [
                  Text('Адреса',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Text('Сменить город',
                    style: TextStyle(
                        fontSize: 16,
                      color: Colors.grey,
                      decoration: TextDecoration.underline
                    ),
                  ),
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarBrightness: Brightness.light
      ),
      child: Scaffold(
        key: _scaffoldKey,
        drawer: ClipRRect(
          borderRadius: BorderRadius.only(topRight: Radius.circular(15)),
          child: Drawer(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Center(
                      child: Image(
                        height: 97,
                        width: 142,
                        image: AssetImage('assets/images/faem.png'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: getSideBarItems(currentUser.isLoggedIn),
                    ),
                  ),
                ],
              )
          ),
        ),
        body: FutureBuilder<FilteredStoresData>(
            future: getFilteredStores(selectedCity.uuid),
            initialData: null,
            builder: (BuildContext context,
                AsyncSnapshot<FilteredStoresData> snapshot) {
              print(snapshot.connectionState);
              if (snapshot.hasData) {
               if (snapshot.data.filteredStoresList == null || snapshot.data.filteredStoresList.length == 0) {
                 return Column(
                   children: [
                     Padding(
                       padding: const EdgeInsets.only(top: 50, left: 16, right: 15, bottom: 10),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Padding(
                             padding: EdgeInsets.only(left: 8, top: 0),
                             child: InkWell(
                               child: SvgPicture.asset(
                                 'assets/svg_images/home_menu.svg',
                                 color: Colors.black,
                               ),
                               onTap: () {
                                 _scaffoldKey.currentState.openDrawer();
                               },
                             ),
                           ),
                           GestureDetector(
                             child: Container(
                               width: 250,
                               height: 38,
                               decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(15),
                                   color: Color(0xFF09B44D)
                               ),
                               child: Center(
                                 child: Text(selectedCity.name,
                                   style: TextStyle(
                                       color: Colors.white,
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
                           Padding(
                             padding: EdgeInsets.only(bottom: 0, top: 0),
                             child: InkWell(
                               child: SvgPicture.asset(
                                 'assets/svg_images/search.svg',
                                 color: Colors.black,),
                             ),
                           ),
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
                if (snapshot.connectionState == ConnectionState.done) {

                  // Если нам пришло с серва хоть что-то
                  if(snapshot.data.filteredStoresList != null){
                    recordsItems.addAll(snapshot.data.filteredStoresList);
                  }
                }
                return Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 50, left: 16, right: 15, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 8, top: 0),
                            child: InkWell(
                              child: SvgPicture.asset(
                                'assets/svg_images/home_menu.svg',
                                color: Colors.black,
                              ),
                              onTap: () {
                                _scaffoldKey.currentState.openDrawer();
                              },
                            ),
                          ),
                          GestureDetector(
                            child: Container(
                              width: 250,
                              height: 38,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Color(0xFF09B44D)
                              ),
                              child: Center(
                                child: Text(selectedCity.name,
                                  style: TextStyle(
                                      color: Colors.white,
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
                          Padding(
                            padding: EdgeInsets.only(bottom: 0, top: 0),
                            child: InkWell(
                              child: SvgPicture.asset(
                                'assets/svg_images/search.svg',
                                color: Colors.black,),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: <Widget>[
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
                                    child: ListView(
                                      children: snapshot.data,
                                      scrollDirection: Axis.horizontal,
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
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 0, right: 10),
                                      child: Text('Все',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    SvgPicture.asset('assets/svg_images/arrow_right.svg',
                                      color: Colors.grey,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          Promotion(),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text('Рестораны',
                                style: TextStyle(
                                  fontSize: 28,
                                  color: Color(0xFF3F3F3F),
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                )),
                          ),
                          filter,
                          (recordsItems.isEmpty) ?  Center(
                            child: Container(),
                          ) : restaurantsList = RestaurantsList(List.from(recordsItems), key: GlobalKey(),)
                        ],
                      ),
                    ),
                    // (currentUser.cartDataModel.cart != null &&
                    //     currentUser.cartDataModel.cart.length != 0)
                    //     ? Padding(
                    //   padding: const EdgeInsets.only(bottom: 0),
                    //   child: BasketButton(
                    //     key: basketButtonStateKey,
                    //     restaurant:
                    //     currentUser.cartDataModel.cart[0].restaurant,
                    //   ),
                    // )
                    //     : Visibility(
                    //   child: Container(height: 80),
                    //   visible: false,
                    // )
                  ],
                );
              } else {
                return Center(
                  child: SpinKitFadingCircle(
                    color: Colors.green,
                    size: 50.0,
                  ),
                );
              }
            }),
      ),
    );
  }
}