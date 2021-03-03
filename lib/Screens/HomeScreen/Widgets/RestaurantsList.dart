import 'package:flutter/material.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/Screens/HomeScreen/Model/FilteredStores.dart';
import 'package:flutter_app/Screens/RestaurantScreen/View/restaurant_screen.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RestaurantsList extends StatefulWidget {

  GlobalKey<RestaurantsListState> key;
  List<FilteredStores> records_items;
  RestaurantsList(this.records_items, {this.key}) : super(key: key);

  @override
  RestaurantsListState createState() {
    return new RestaurantsListState(records_items);
  }
}

class RestaurantsListState extends State<RestaurantsList>{
  RestaurantsListState(this.records_items);
  List<FilteredStores> records_items;

  @override
  void initState() {
    super.initState();
  }

  _buildRestaurantsList() {
    DateTime now = DateTime.now();
    int currentTime = now.hour*60+now.minute;
    int dayNumber  = now.weekday-1;
    List<Widget> restaurantList = [];
    records_items.forEach((FilteredStores restaurant) {
//      int work_beginning = restaurant.work_schedule[dayNumber].work_beginning;
//      int work_ending = restaurant.work_schedule[dayNumber].work_ending;
//      bool day_off = restaurant.work_schedule[dayNumber].day_off;
//      bool available = restaurant.available != null ? restaurant.available : true;
      restaurantList.add(InkWell(
          hoverColor: Colors.white,
          focusColor: Colors.white,
          splashColor: Colors.white,
          highlightColor: Colors.white,
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(width: 1.0, color: Colors.grey[200])),
            child: Column(
              children: <Widget>[
//                ( day_off ||
//                    !available ||
//                    !(currentTime >= work_beginning && currentTime < work_ending)) ? Stack(
//                  children: [
//                    ClipRRect(
//                        borderRadius: BorderRadius.only(
//                            topLeft: Radius.circular(15),
//                            topRight: Radius.circular(15),
//                            bottomLeft: Radius.circular(0),
//                            bottomRight: Radius.circular(0)),
//                        child: Hero(
//                            tag: restaurant.uuid,
//                            child: ColorFiltered(
//                              colorFilter: ColorFilter.mode(
//                                  Colors.grey,
//                                  BlendMode.saturation
//                              ),
//                              child: Image.network(
//                                getImage(restaurant.image),
//                                height: 200.0,
//                                width: MediaQuery.of(context).size.width,
//                                fit: BoxFit.cover,
//                              ),
//                            ))),
//                    Padding(
//                      padding: const EdgeInsets.only(top: 150.0),
//                      child: Align(
//                        alignment: Alignment.bottomRight,
//                        child: Container(
//                          height: 32,
//                          width: 250,
//                          decoration: BoxDecoration(
//                              borderRadius: BorderRadius.only(
//                                  topLeft: Radius.circular(20),
//                                  bottomLeft: Radius.circular(20)
//                              ),
//                              color: Colors.black.withOpacity(0.5)
//                          ),
//                          child: Center(
//                            child: Padding(
//                              padding: const EdgeInsets.only(left: 8.0, right: 8),
//                              child: Text(
//                                "Заведение откроется в ${(work_beginning / 60).toStringAsFixed(0)} часов",
//                                style: TextStyle(
//                                    fontSize: 12.0,
//                                    fontWeight: FontWeight.w600,
//                                    color: Colors.white
//                                ),
//                                overflow: TextOverflow.ellipsis,
//                              ),
//                            ),
//                          ),
//                        ),
//                      ),
//                    )
//                  ],
//                ) :
                Stack(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(0)),
                        child:  Image.network(
                          getImage((restaurant.meta.images != null && restaurant.meta.images.length > 0) ? restaurant.meta.images[0] : ''),
                          height: 200.0,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                        )),
                  ],
                ),
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
                      SizedBox(
                        height: 30,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                padding: EdgeInsets.only(left: 8, right: 8, top: 0),
                                height: 25,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(0xFF09B44D)
                                ),
                                child: Row(
                                  children: [
                                    SvgPicture.asset('assets/svg_images/rest_star.svg',
                                      color: Colors.white,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 3.0),
                                      child: Text(restaurant.meta.rating.toString(),
                                        style: TextStyle(
                                            color: Colors.white
                                        ),
                                      ),
                                    )
                                  ],
                                )
                            ),
                            Container(
                              height: 25,
                              padding: EdgeInsets.only(left: 10, right: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xFFEFEFEF)
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5.0, left: 0),
                                    child: SvgPicture.asset(
                                        'assets/svg_images/rest_car.svg'),
                                  ),
                                  Text(
                                    restaurant.meta.avgDeliveryTime.toString(),
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Container(
                                height: 25,
                                padding: EdgeInsets.only(left: 10, right: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(0xFFEFEFEF)
                                ),
                                child: Center(
                                  child: Text(
                                    '${restaurant.meta.avgDeliveryPrice}',
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          onTap: () async {
            if (await Internet.checkConnection()) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) {
                  return RestaurantScreen(restaurant: restaurant);
                }),
              );
            } else {
              noConnection(context);
            }
          }));
    });
    List<Widget> childrenColumn = new List<Widget>();
    childrenColumn.addAll(restaurantList);
    return Column(children: childrenColumn);
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: _buildRestaurantsList(),
    );
  }
}