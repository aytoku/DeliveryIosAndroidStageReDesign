import 'package:flutter/material.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'ProductMenu/ItemCounter.dart';

class GroceryItem extends StatefulWidget {
  GroceryItem({
    this.key
  }) : super(key: key);
  final GlobalKey<GroceryItemState> key;

  @override
  GroceryItemState createState() {
    return new GroceryItemState();
  }
}

class GroceryItemState extends State<GroceryItem>{

  GroceryItemState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15, top: 60),
            child: Row(
                children:[
                  Flexible(
                    flex: 1,
                    child: InkWell(
                        child: SvgPicture.asset('assets/svg_images/arrow_left.svg'),
                      onTap: (){
                          Navigator.pop(context);
                      },
                    ),
                  ),
                  Flexible(flex: 7,child: Text('Фрукты', style: TextStyle(fontSize: 24)))
                ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: StaggeredGridView.countBuilder(
                crossAxisCount: 2,
                itemCount: 4,
                itemBuilder: (BuildContext context, int index){
                  return GestureDetector(
                    child: Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      height: 250,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4.0, // soften the shadow
                            spreadRadius: 1.0, //extend the shadow
                          )
                        ],
                        color: Colors.white,
                        border: Border.all(width: 1.0, color: Colors.grey[200]),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 140,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  topLeft: Radius.circular(10)),
                              child: Image.asset('assets/images/apple.png'),),
                          ),
                          Container(
                            height: 110,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                color: Color(0xFFFAFAFA)
                            ),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 14, top: 12),
                                    child: Text(
                                      'Яблоко',
                                      // restaurantDataItems.name,
                                      maxLines: 3,
                                      style: TextStyle(
                                          fontSize: 16.0, color: Color(0xFF3F3F3F), fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                // MenuItemDesc(foodRecords: restaurantDataItems, parent: this),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15, top: 8),
                                    child: Text('desc',
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.grey),
                                    ),
                                  ),
                                ),
                                // Padding(
                                //   padding: EdgeInsets.only(top: 25),
                                //   child: MenuItemCounter(
                                //     // foodRecords: restaurantDataItems,
                                //     // menuItemCounterKey: menuItemCounterKey,
                                //     // parent: this
                                //   ),
                                // )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () async {
                      if (await Internet.checkConnection()) {
                        // onPressedButton(restaurantDataItems, menuItemCounterKey);
                        // Navigator.push(context, MaterialPageRoute(builder: (context)=> PB()));
                      } else {
                        noConnection(context);
                      }
                    },
                  );
                },
                staggeredTileBuilder: (int index) =>
                new StaggeredTile.extent(1, 260),
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 4.0,
              ),
            ),
          ),
        ],
      )
    );
  }
}