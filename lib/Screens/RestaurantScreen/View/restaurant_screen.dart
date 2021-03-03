import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/Screens/CartScreen/View/cart_page_view.dart';
import 'package:flutter_app/Screens/HomeScreen/Bloc/restaurant_get_bloc.dart';
import 'package:flutter_app/Screens/HomeScreen/Model/FilteredStores.dart';
import 'package:flutter_app/Screens/HomeScreen/View/home_screen.dart';
import 'package:flutter_app/Screens/RestaurantScreen/API/getProductsByStoreUuid.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Model/ProductsByStoreUuid.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/CartButton/CartButton.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/PanelContent.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/ProductCategories/CategoryList.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/ProductDescCounter.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/ProductMenu/Item.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/ProductMenu/ItemCounter.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/ProductMenu/Title.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/SliverTitleItems/SliverBackButton.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/SliverTitleItems/SliverText.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/VariantSelector.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../../data/data.dart';
import '../../CartScreen/API/clear_cart.dart';
import '../API/add_variant_to_cart.dart';
import '../Model/ProductDataModel.dart';

class RestaurantScreen extends StatefulWidget {
  final FilteredStores restaurant;

  RestaurantScreen({Key key, this.restaurant}) : super(key: key);

  @override
  RestaurantScreenState createState() =>
      RestaurantScreenState(restaurant);
}

class RestaurantScreenState extends State<RestaurantScreen> {
  final FilteredStores restaurant;
  // Добавленные глобалки
  ProductsByStoreUuidData restaurantDataItems; // Модель текущего меню
  CategoryList categoryList; // Виджет с категориями еды
  // (для подгрузки ВПЕРЕД по клику по категории)
  List<MenuItem> foodMenuItems; // Виджеты с хавкой
  List<MenuItemTitle> foodMenuTitles; // Тайтлы категорий
  List<Widget> menuWithTitles;

  GlobalKey<ProductDescCounterState> counterKey;
  GlobalKey<CartButtonState> basketButtonStateKey;
  bool isLoading = true;

  GlobalKey<ScaffoldState> _scaffoldStateKey;

  ScrollController sliverScrollController;
  PanelController panelController;
  GlobalKey<PanelContentState> panelContentKey;
  ScrollController sc;

  RestaurantScreenState(this.restaurant);


  @override
  void initState() {
    super.initState();
    panelController = new PanelController();
    foodMenuItems = new List<MenuItem>();
    foodMenuTitles = new List<MenuItemTitle>();
    menuWithTitles = new List<Widget>();
    counterKey = new GlobalKey();
    basketButtonStateKey = new GlobalKey<CartButtonState>();
    _scaffoldStateKey = GlobalKey();
    sliverScrollController = new ScrollController();

    // Инициализируем список категорий
    categoryList = new CategoryList(key: new GlobalKey<CategoryListState>(), restaurant: restaurant, parent: this);
  }

  @override
  void dispose(){
    super.dispose();
  }



  bool get _isAppBarExpanded {
    return sliverScrollController.hasClients && sliverScrollController.offset > 90;
  }

  _dayOff(ProductsByStoreUuid restaurantDataItems,
      GlobalKey<MenuItemCounterState> menuItemCounterKey) {
    GlobalKey<VariantsSelectorState> variantsSelectorStateKey =
    GlobalKey<VariantsSelectorState>();
    // GlobalKey<ToppingsSelectorState> toppingsSelectorStateKey =
    // new GlobalKey<ToppingsSelectorState>();

//    DateTime now = DateTime.now();
//    int dayNumber  = now.weekday-1;
//
//    int work_beginning = restaurant.work_schedule[dayNumber].work_beginning;
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
          )),
      child: Stack(
        children: <Widget>[
//          Padding(
//            padding: EdgeInsets.only(top: 30),
//            child: Align(
//                alignment: Alignment.topCenter,
//                child: Text('К сожалению, доставка не доступна.\nБлижайшее время в ${( work_beginning/ 60).toStringAsFixed(0)} часов',
//                  style: TextStyle(
//                      fontSize: 16
//                  ),
//                  textAlign: TextAlign.center,
//                )
//            ),
//          ),
          Padding(
            padding: EdgeInsets.only(top: 10,left: 15, right: 15, bottom: 25),
            child: Align(
                alignment: Alignment.bottomCenter,
                child: FlatButton(
                  child: Text(
                    "Далее",
                    style:
                    TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  color: Color(0xFF09B44D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.only(
                      left: 110, top: 20, right: 110, bottom: 20),
                  onPressed: () async {
                    homeScreenKey = new GlobalKey<HomeScreenState>();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) => RestaurantGetBloc(),
                              child: new HomeScreen(),
                            )),
                            (Route<dynamic> route) => false);
                  },
                )
            ),
          )
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context) {
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
                child: Text("Товар добавлен в коризну"),
              ),
            ),
          ),
        );
      },
    );
  }

  showCartClearDialog(BuildContext context, ProductsDataModel productDataModel,
      GlobalKey<MenuItemCounterState> menuItemCounterKey, MenuItemState menuItem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(bottom: 0),
          child: Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            child: Container(
                height: 242,
                width: 300,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 15, top: 20, bottom: 20, right: 15),
                      child: Text(
                        'Все ранее добавленные блюда из ресторна ${currentUser.cartModel.storeData.name} будут удалены из корзины',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                    InkWell(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: EdgeInsets.only(top: 20, bottom: 20),
                          child: Center(
                            child: Text(
                              'Ок',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      onTap: () async {
                        if (await Internet.checkConnection()) {
                          currentUser.cartModel = await clearCart(necessaryDataForAuth.device_id);
                          currentUser.cartModel = await addVariantToCart(productDataModel, necessaryDataForAuth.device_id, counterKey.currentState.counter);
                          basketButtonStateKey.currentState.refresh();
                          counterKey.currentState.refresh();
                          menuItem.setState(() {

                          });

                          if(productDataModel.product.type == "variable"){
                            Navigator.pop(context);
                            panelController.close();
                          }else{
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }


                          Padding(
                            padding: EdgeInsets.only(bottom: 0),
                            child: showAlertDialog(context),
                          );
                        } else {
                          noConnection(context);
                        }
                      },
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                    InkWell(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: EdgeInsets.only(top: 20, bottom: 20),
                          child: Center(
                            child: Text(
                              'Отмена',
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
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

  _restInfo() {
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
            child: _buildRestInfoNavigationMenu(),
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                )),
          );
        });
  }

  _buildRestInfoNavigationMenu() {
//    DateTime now = DateTime.now();
//    int currentTime = now.hour*60+now.minute;
//    int dayNumber  = now.weekday-1;
//    int work_ending = restaurant.work_schedule[dayNumber].work_ending;
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, top: 30),
            child: Align(
                alignment: Alignment.topLeft,
                child: Text(restaurant.name,
                  style: TextStyle(
                      color: Color(0xFF424242),
                      fontSize: 21,
                      fontWeight: FontWeight.bold
                  ),
                )
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, top: 20),
            child: Align(
                alignment: Alignment.topLeft,
                child: Text('Адрес',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14
                  ),
                )
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, top: 10),
            child: Align(
                alignment: Alignment.topLeft,
                child: Text(restaurant.address.unrestrictedValue,
                  style: TextStyle(
                      fontSize: 14
                  ),
                )
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, top: 20),
            child: Align(
                alignment: Alignment.topLeft,
                child: Text("Время доставки",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14
                  ),
                )
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, top: 10),
            child: Align(
                alignment: Alignment.topLeft,
                child: Text('${restaurant.meta.avgDeliveryTime}',
                  style: TextStyle(
                      fontSize: 14
                  ),
                )
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, top: 20),
            child: Align(
                alignment: Alignment.topLeft,
                child: Text('Кухни',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14
                  ),
                )
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, top: 10),
            child: Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: List.generate(restaurant.storeCategoriesUuid.length, (index){
                    return Text(restaurant.storeCategoriesUuid[index].name);
                  }),
                )
            ),
          )
        ],
      ),
    );
  }

  _buildFoodCategoryList() {
    if(restaurant.productCategoriesUuid.length>0)
      return categoryList;
    else
      return Container(height: 0);
  }


  // функция для получения детей сливера
  List<Widget>  getSliverChildren(){
    List<Widget> result = new List<Widget>();
    result.addAll(menuWithTitles);
    return result;
  }

  // генерация списка еды с названиями категорий
  List<Widget> generateMenu() {
    List<Widget> menu = new List<Widget>();
    String lastCategoryUuid = "";
    int lastCategoryIndex = -1;
    foodMenuItems.forEach((foodMenuItem) {
      if(foodMenuItem.restaurantDataItems.productCategories.length > 0 &&
          foodMenuItem.restaurantDataItems.productCategories[0].uuid != lastCategoryUuid){
        lastCategoryIndex++;
        lastCategoryUuid = foodMenuItem.restaurantDataItems.productCategories[0].uuid;
        if(lastCategoryIndex < foodMenuTitles.length){
          menu.add(foodMenuTitles[lastCategoryIndex]);
        }
      }
      print(foodMenuItem.restaurantDataItems.uuid);
      menu.add(foodMenuItem);
    });
    return menu;
  }


  // список итемов заведения
  Widget _buildScreen() {
    isLoading = false;
    // Если хавки нет
    if (restaurantDataItems != null && restaurantDataItems.productsByStoreUuidList.length == 0) {
      return Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 50, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(left: 0),
                      child: InkWell(
                          hoverColor: Colors.white,
                          focusColor: Colors.white,
                          splashColor: Colors.white,
                          highlightColor: Colors.white,
                          onTap: () async {
                            homeScreenKey =
                            new GlobalKey<HomeScreenState>();
                            if(await Internet.checkConnection()){
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
                          child: Container(
                              height: 40,
                              width: 60,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 12, bottom: 12, right: 10, left: 16),
                                child: SvgPicture.asset(
                                    'assets/svg_images/arrow_left.svg'),
                              ))),
                    ),
                  ),
                  Flexible(
                    flex: 7,
                    child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(right: 30),
                        child: Text(
                          this.restaurant.name,
                          style: TextStyle(
                            fontSize: 18,),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0.0, bottom: 0),
              child: Divider(color: Color(0xFFEEEEEE), height: 1,),
            ),
            _buildFoodCategoryList(),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 0),
              child: Divider(color: Color(0xFFEEEEEE), height: 1,),
            ),
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
              child: Center(
                child: Text('Нет товаров данной категории'),
              ),
            ),
          ],
        ),
      );
    }


    // генерим список еды и названий категория
    foodMenuItems.clear();
    foodMenuItems.addAll(MenuItem.fromFoodRecordsList(restaurantDataItems.productsByStoreUuidList, this));
    foodMenuTitles.clear();
    foodMenuTitles.addAll(MenuItemTitle.fromCategoryList(restaurant.productCategoriesUuid));
    menuWithTitles = generateMenu();

    List<Widget> sliverChildren = getSliverChildren();
    GlobalKey<SliverTextState>sliverTextKey = new GlobalKey();
    GlobalKey<SliverBackButtonState>sliverImageKey = new GlobalKey();

    // замена кастомной кнопки на кнопку и текст аппбара
    sliverScrollController.addListener(() async {

      try{
        if(!isLoading){
          // Используя силу математики, находим индекс хавки, на которую сейчас
          // смотрим
          double offset = sliverScrollController.offset;
          int i = 0;
          double defaultTitleHeight = 50;
          double defaultFoodItemHeight = 165;
          var item;
          while(offset > 0 && i < menuWithTitles.length){
            item = menuWithTitles[i];
            if(item is MenuItem){
              offset -= (item.key.currentContext != null) ? item.key.currentContext.size.height : defaultFoodItemHeight;
            } else if(item is MenuItemTitle){
              offset -= (item.key.currentContext != null) ? item.key.currentContext.size.height : defaultTitleHeight;
            }
            i++;
          }

          if(item!=null){
            String catName = '';
            if(item is MenuItem)
              catName = item.restaurantDataItems.productCategories[0].name;
            else if(item is MenuItemTitle)
              catName = item.title;

            CategoriesUuid cat;
            restaurant.productCategoriesUuid.forEach((element) {
              if(element.name == catName){
                cat = element;
                return;
              }
            });

            if(cat != null &&  cat.name != categoryList.key.currentState.currentCategory.name){
              // Выбираем категорию и скроллим сам список категорий к ней
              categoryList.key.currentState.SelectCategory(cat);
              categoryList.key.currentState.ScrollToSelectedCategory();
            }
          }
        }
      }catch(e){
      }

      print(isLoading);
      if(sliverTextKey.currentState != null && sliverScrollController.offset > 89){
        sliverTextKey.currentState.setState(() {
          sliverTextKey.currentState.title =  new Text(this.restaurant.name, style: TextStyle(color: Colors.black),);
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
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Image.network(
              getImage((restaurant.meta.images != null && restaurant.meta.images.length > 0) ? restaurant.meta.images[0] : ''),
              fit: BoxFit.cover,
              height: 230.0,
              width: MediaQuery.of(context).size.width,
            ),
            CustomScrollView(
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
                  backgroundColor: Colors.white,
                  leading: InkWell(
                    hoverColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Container(
                      height: 40,
                      width: 60,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 20, right: 10),
                        child: SliverBackButton(key: sliverImageKey, image: null,),
                      ),
                    ),
                    onTap: () async {
                      homeScreenKey =
                      new GlobalKey<HomeScreenState>();
                      if(await Internet.checkConnection()){
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
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: SliverText(title: Text('', style: TextStyle(fontSize: 18),),key: sliverTextKey,),
                    background: AnnotatedRegion<SystemUiOverlayStyle>(
                      value: (Platform.isIOS) ? _isAppBarExpanded ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
                      child: ClipRRect(
                          child: Stack(
                            children: <Widget>[
                              Image.network(
                                getImage((restaurant.meta.images != null && restaurant.meta.images.length > 0) ? restaurant.meta.images[0] : ''),
                                fit: BoxFit.cover,
                                height: 500.0,
                                width: MediaQuery.of(context).size.width,
                              ),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 40, left: 15),
                                    child: GestureDetector(
                                      child: SvgPicture.asset(
                                          'assets/svg_images/rest_arrow_left.svg'),
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
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: Text(
                                  this.restaurant.name,
                                  style: TextStyle(
                                      fontSize: 21,
                                      color: Color(0xFF3F3F3F)),
                                ),
                              ),
                              InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: SvgPicture.asset(
                                      'assets/svg_images/rest_info.svg'),
                                ),
                                onTap: (){
                                  _restInfo();
                                },
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Container(
                                height: 26,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(0xFFEFEFEF)
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 5, bottom: 5, right: 10, left: 10),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset('assets/svg_images/star.svg',
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 5),
                                          child: Text(restaurant.meta.rating.toString(),
                                            style: TextStyle(
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Container(
                                height: 26,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(0xFFEFEFEF)
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(left:10, right: 10, top: 5, bottom: 5),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 5),
                                          child: SvgPicture.asset('assets/svg_images/rest_car.svg',
                                          ),
                                        ),
                                        Text(
                                          '~' +  '${restaurant.meta.avgDeliveryTime}',
                                          style: TextStyle(
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, right: 15),
                              child: Container(
                                height: 26,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(0xFFEFEFEF)
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(left:10, right: 10, top: 5, bottom: 5),
                                    child: Text('${restaurant.meta.avgDeliveryPrice}',
                                      style: TextStyle(
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SliverStickyHeader(
                  sticky: true,
                  header: Container(
                    decoration: BoxDecoration(
                        color: Colors.white
                    ),
                    child: _buildFoodCategoryList(),
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index){
                        return Container(
                          padding: (currentUser.cartModel.items == null || currentUser.cartModel.items.length < 1) ?
                          EdgeInsets.only(bottom: 15)
                              : EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.2),
                          decoration: BoxDecoration(
                              color: Colors.white
                          ),
                          child: Column(
                              children: sliverChildren
                          ),
                        );
                      },
                      childCount: 1,
                    ),
                  ),
                )
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:  EdgeInsets.only(bottom: 0),
                child: CartButton(
                  key: basketButtonStateKey, restaurant: restaurant, source: CartSources.Restaurant,),
              ),
            )
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    panelContentKey = new GlobalKey<PanelContentState>();

    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldStateKey,
      body: SlidingUpPanel(
        backdropEnabled: true,
        controller: panelController,
        color: Colors.transparent,
        minHeight: 0,
        maxHeight: 625,
        isDraggable: true,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        panelBuilder: (sc) {
          this.sc = sc;
          return Container(
            height: 625,
            child: Stack(
              children: [
                Align(
                    alignment: Alignment.topCenter,
                    child: SvgPicture.asset('assets/svg_images/close_button.svg')),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container( height: 625,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),),
                      child: PanelContent(key: panelContentKey, parent: this)),
                ),
              ],
            ),
          );
        },
        body: (restaurantDataItems != null) ?
        _buildScreen()
            :
        FutureBuilder<ProductsByStoreUuidData>(
            future: getSortedProductsByStoreUuid(restaurant),
            initialData: null,
            builder: (BuildContext context,
                AsyncSnapshot<ProductsByStoreUuidData> snapshot) {
              print(snapshot.connectionState);
              if (snapshot.connectionState == ConnectionState.done) {
                restaurantDataItems = snapshot.data;
                return _buildScreen();
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
  // Подгрузка итемов с категорией
  // ignore: non_constant_identifier_names
  Future<bool> GoToCategory(int categoryIndex) async {
    if(isLoading)
      return false;
    isLoading = true;
    try{

      // Вычисляем оффсет тайтла необходимой категории
      double offset = 0;
      int i = 0;
      double defaultTitleHeight = 50;
      double defaultFoodItemHeight = 165;
      for(int i = 0; i<menuWithTitles.length; i++){
        var item = menuWithTitles[i];
        if(item is MenuItemTitle){
          offset += (item.key.currentContext != null) ? item.key.currentContext.size.height : 0;
          if(item.title.toLowerCase() == restaurant.productCategoriesUuid[categoryIndex].name.toLowerCase()) {
            break;
          }
        } else if(item is MenuItem){
          offset += (item.key.currentContext != null) ? item.key.currentContext.size.height : 0;
        }
      }
      await sliverScrollController.position.animateTo(offset,curve: Curves.ease, duration: Duration(milliseconds: 600));

      // Скроллим к нему

      return true;
      // находим итем с данной категорией
      MenuItemTitle targetCategory = menuWithTitles.firstWhere((element) => element is MenuItemTitle && element.title == restaurant.productCategoriesUuid[categoryIndex].name);
      if(targetCategory != null){
        while(targetCategory.key.currentContext == null) {
          await sliverScrollController.animateTo(sliverScrollController.offset+200, duration: new Duration(milliseconds: 15),
              curve: Curves.ease);
        }
        // джампаем к нему

        await Scrollable.ensureVisible(targetCategory.key.currentContext, duration: new Duration(milliseconds: 90),
            curve: Curves.ease);
        await sliverScrollController.position.animateTo(sliverScrollController.position.pixels-60,curve: Curves.ease, duration: Duration(milliseconds: 50));
      }
    }finally{
      isLoading = false;
    }
    return true;
  }
}