import 'dart:io';

import 'package:animated_widgets/widgets/translation_animated.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/Screens/HomeScreen/Bloc/restaurant_get_bloc.dart';
import 'package:flutter_app/Screens/HomeScreen/Model/FilteredStores.dart';
import 'package:flutter_app/Screens/HomeScreen/Model/Stock.dart';
import 'package:flutter_app/Screens/HomeScreen/View/home_screen.dart';
import 'package:flutter_app/Screens/RestaurantScreen/View/grocery_screen.dart';
import 'package:flutter_app/Screens/RestaurantScreen/View/restaurant_screen.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/CartButton/CartButton.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/FadeAnimation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/SliverTitleItems/SliverText.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../data/data.dart';
import '../../../data/globalVariables.dart';
import '../../../data/globalVariables.dart';
import '../../RestaurantScreen/Widgets/SliverTitleItems/SliverBackButton.dart';

class PromoScreen extends StatefulWidget {

  Stock stock;
  PromoScreen({Key key, this.stock}) : super(key: key);

  @override
  PromoScreenState createState() {
    return new PromoScreenState(stock);
  }
}

class PromoScreenState extends State<PromoScreen>{
  Stock stock;
  ScrollController sliverScrollController = new ScrollController();

  GlobalKey<CartButtonState> basketButtonStateKey;
  PromoScreenState(this.stock);



  List<Widget>  getSliverChildren(){
    List<Widget> result = new List<Widget>();
    stock.stores.forEach((restaurant) {
      bool isScheduleAvailable = restaurant.workSchedule.isAvailable();
      Standard standard = restaurant.workSchedule.getCurrentStandard();
      bool available = restaurant.available.flag != null ? restaurant.available.flag : true;
      result.add(
          InkWell(
              hoverColor: AppColor.themeColor,
              focusColor: AppColor.themeColor,
              splashColor: AppColor.themeColor,
              highlightColor: AppColor.themeColor,
              child: Container(
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
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(width: 1.0, color: AppColor.elementsColor)),
                child: Column(
                  children: <Widget>[
                    (!available ||
                        !(isScheduleAvailable) ? Stack(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(0)),
                            child: Hero(
                                tag: restaurant.uuid,
                                child: ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                      Colors.grey,
                                      BlendMode.saturation
                                  ),
                                  child: Image.network(
                                    getImage((restaurant.meta.images.length > 0 )? restaurant.meta.images[0]: ''),
                                    height: 200.0,
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.cover,
                                  ),
                                ))),
                        Padding(
                          padding: const EdgeInsets.only(top: 150.0),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              height: 32,
                              width: 250,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomLeft: Radius.circular(20)
                                  ),
                                  color: Colors.black.withOpacity(0.5)
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                                  child: (!available) ? Text(
                                    restaurant.available.reason,
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ) : Text(
                                    (standard!= null) ? "Заведение откроется в ${standard.beginningTime} часов" : '',
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ) :
                    Stack(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(0)),
                            child:  Stack(
                              children: [
                                Center(child: Image.asset('assets/images/food.png', height: 200.0,
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.cover,),
                                ),
                                Image.network(
                                  getImage((restaurant.meta.images != null && restaurant.meta.images.length > 0) ? restaurant.meta.images[0] : ''),
                                  height: 200.0,
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.cover,
                                ),
                              ],
                            )),
                      ],
                    )),
                    Container(
                      margin: EdgeInsets.only(left: 15.0, top: 12, bottom: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              restaurant.name,
                              style: TextStyle(
                                fontSize: 21.0,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF3F3F3F),),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            height: 4.0,
                          ),
                          // SizedBox(
                          //   height: 30,
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     children: [
                          //       Container(
                          //           padding: EdgeInsets.only(left: 8, right: 8, top: 0),
                          //           height: 25,
                          //           decoration: BoxDecoration(
                          //               borderRadius: BorderRadius.circular(10),
                          //               color: AppColor.mainColor
                          //           ),
                          //           child: Row(
                          //             children: [
                          //               SvgPicture.asset('assets/svg_images/rest_star.svg',
                          //                 color: Colors.white,
                          //               ),
                          //               Padding(
                          //                 padding: const EdgeInsets.only(left: 3.0),
                          //                 child: Text(restaurant.meta.rating.toString(),
                          //                   style: TextStyle(
                          //                       color: AppColor.textColor
                          //                   ),
                          //                 ),
                          //               )
                          //             ],
                          //           )
                          //       ),
                          //       Container(
                          //         height: 25,
                          //         padding: EdgeInsets.only(left: 10, right: 10),
                          //         decoration: BoxDecoration(
                          //             borderRadius: BorderRadius.circular(10),
                          //             color: AppColor.subElementsColor
                          //         ),
                          //         child: Row(
                          //           children: [
                          //             Padding(
                          //               padding: const EdgeInsets.only(right: 5.0, left: 0),
                          //               child: SvgPicture.asset(
                          //                   'assets/svg_images/rest_car.svg'),
                          //             ),
                          //             Text(
                          //               restaurant.meta.avgDeliveryTime.toString(),
                          //               style: TextStyle(
                          //                   fontSize: 14.0,
                          //                   color: Colors.black,
                          //                   fontWeight: FontWeight.w500
                          //               ),
                          //               overflow: TextOverflow.ellipsis,
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //       Padding(
                          //         padding: const EdgeInsets.only(right: 15),
                          //         child: Container(
                          //           height: 25,
                          //           padding: EdgeInsets.only(left: 10, right: 10),
                          //           decoration: BoxDecoration(
                          //               borderRadius: BorderRadius.circular(10),
                          //               color: AppColor.subElementsColor
                          //           ),
                          //           child: Center(
                          //             child: Text(
                          //               '${restaurant.meta.avgDeliveryPrice}',
                          //               style: TextStyle(
                          //                   fontSize: 14.0,
                          //                   color: Colors.black,
                          //                   fontWeight: FontWeight.w500
                          //               ),
                          //               overflow: TextOverflow.ellipsis,
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              onTap: () async {
                if (await Internet.checkConnection()) {
                  if(restaurant.type == 'restaurant'){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) {
                        return RestaurantScreen(restaurant: restaurant);
                      }),
                    );
                  }else{
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) {
                        return GroceryScreen(restaurant: restaurant);
                      }),
                    );
                  }
                } else {
                  noConnection(context);
                }
              })
      );
    });
    return result;
  }

  bool get _isAppBarExpanded {

    return sliverScrollController.hasClients && sliverScrollController.offset > 90;
  }

  Widget _buildRestaurantScreen() {

    List<Widget> sliverChildren = getSliverChildren();
    GlobalKey<SliverBackButtonState>sliverImageKey = new GlobalKey();
    GlobalKey<SliverTextState>sliverTextKey = new GlobalKey();

    sliverScrollController.addListener(() async {


      if(sliverTextKey.currentState != null && sliverScrollController.offset > 89){
        sliverTextKey.currentState.setState(() {
          sliverTextKey.currentState.title =  new Text(stock.name, style: TextStyle(color: Colors.black),);
        });
      }else{
        if(sliverTextKey.currentState != null){
          sliverTextKey.currentState.setState(() {
            sliverTextKey.currentState.title =  new Text('');
          });
        }
      }
      if(sliverImageKey.currentState != null && sliverScrollController.offset > 89){
        sliverImageKey.currentState.setState(() {
          sliverImageKey.currentState.image =
          new SvgPicture.asset('assets/svg_images/arrow_left.svg');
        });
      }else{
        if(sliverImageKey.currentState != null){
          sliverImageKey.currentState.setState(() {
            sliverImageKey.currentState.image =  null;
          });
        }
      }
    });

    return DefaultTabController(
      length: 1,
      child: Scaffold(
        backgroundColor: AppColor.themeColor,
        body: Stack(
          children: [
            Image.network(
              getImage((stock.banner != null) ? stock.banner : ''),
              fit: BoxFit.cover,
              height: 230.0,
              width: MediaQuery.of(context).size.width,
            ),
            CustomScrollView(
              physics: BouncingScrollPhysics(),
              anchor: 0.01,
              controller: sliverScrollController,
              slivers: [
                SliverAppBar(
                  brightness: _isAppBarExpanded ? Brightness.dark : Brightness.light,
                  expandedHeight: 140.0,
                  floating: false,
                  pinned: true,
                  snap: false,
                  stretch: true,
                  leading: InkWell(
                    child: Container(
                        height: 40,
                        width: 60,
                        child: Padding(
                          padding:
                          EdgeInsets.only(top: 17, bottom: 17, right: 10),
                          child:  SliverBackButton(key: sliverImageKey, image: null,),
                        )),
                    onTap: (){
                      Navigator.pop(context);
                    },
                  ),
                  elevation: 0,
                  backgroundColor: AppColor.themeColor,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: SliverText(title: Text('', style: TextStyle(fontSize: 18),),key: sliverTextKey,),
                    background: AnnotatedRegion<SystemUiOverlayStyle>(
                      value: (Platform.isIOS) ? _isAppBarExpanded ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
                      child: ClipRRect(
                          child: Stack(
                            children: <Widget>[
                              Image.network(
                                getImage((stock.banner != null) ? stock.banner : ''),
                                fit: BoxFit.cover,
                                height: 230.0,
                                width: MediaQuery.of(context).size.width,
                              ),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 40, left: 15),
                                    child: GestureDetector(
                                      child: SvgPicture.asset(
                                          'assets/svg_images/fermer_arrow_left.svg'),
                                      onTap: () async {
                                        if(await Internet.checkConnection()){
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
                                        }else{
                                          noConnection(context);
                                        }
                                      },
                                    ),
                                  ))
                            ],
                          )),
                    ),
                  ),
                ),
                SliverStickyHeader(
                  sticky: false,
                  header: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.themeColor,
                          offset: Offset(0, 5),
                          blurRadius: 4,
                          spreadRadius: 2,
                        )
                      ],
                      border: Border.all(color: Colors.white, width: 4),
                      color: AppColor.themeColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                stock.name,
                                style: TextStyle(
                                    fontSize: 18,
                                  fontWeight: FontWeight.w400
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  stock.description,
                                  style: TextStyle(
                                      fontSize: 14
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 25),
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: AppColor.mainColor
                                    ),
                                    height: 37,
                                    width: MediaQuery.of(context).size.width,
                                    child: Center(
                                      child: Text(
                                        'Скопировать код: ' + stock.code,
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: AppColor.textColor
                                        ),
                                      ),
                                    ),
                                  ),
                                  Material(
                                    type: MaterialType.transparency,
                                    child: InkWell(
                                      splashColor: AppColor.unselectedBorderFieldColor.withOpacity(0.5),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        height: 37,
                                      ),
                                      onTap: () async {
                                        savedPromo = stock;
                                        Clipboard.setData(new ClipboardData(text: stock.code));
                                        showToast();
                                      },
                                    ),
                                  ),

                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SliverStickyHeader(
                    sticky: true,
                    header: Container(),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index){
                          return TranslationAnimatedWidget(
                            enabled: true,
                            values: [
                              Offset(0, 200), // disabled value value
                              Offset(0, 100), //intermediate value
                              Offset(0, 0) //enabled value
                            ],
                            child: Container(
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white,
                                      offset: Offset(0, 0),
                                      blurRadius: 4,
                                      spreadRadius: 2,
                                    )
                                  ],
                                  border: Border.all(color: Colors.white, width: 4),
                                  color: AppColor.themeColor
                              ),
                              child: Column(
                                children: sliverChildren,
                              ),
                            ),
                          );
                        },
                        childCount: 1,
                      ),
                    )
                )
              ],
            ),
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: Padding(
            //     padding:  EdgeInsets.only(bottom: 0),
            //     child: CartButton(
            //       key: basketButtonStateKey, restaurant: restaurant, source: CartSources.Restaurant,),
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  void showToast() async {
    await Fluttertoast.showToast(
        msg: "Код скопирован",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Expanded(child: _buildRestaurantScreen())
          ],
        ),
      ),
    );
  }
}