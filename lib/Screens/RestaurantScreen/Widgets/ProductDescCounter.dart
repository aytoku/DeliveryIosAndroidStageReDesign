import 'package:flutter/material.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/Screens/CartScreen/Widgets/PriceField.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductDescCounter extends StatefulWidget {
  GlobalKey<PriceFieldState> priceFieldKey;
  ProductDescCounter({Key key, this.priceFieldKey}) : super(key: key);

  @override
  ProductDescCounterState createState() {
    return new ProductDescCounterState(priceFieldKey);
  }
}

class ProductDescCounterState extends State<ProductDescCounter> {
  GlobalKey<PriceFieldState> priceFieldKey;
  ProductDescCounterState(this.priceFieldKey);

  int counter = 1;

  // ignore: non_constant_identifier_names
  void _incrementCounter_plus() {
    setState(() {
      counter++;
      if(priceFieldKey.currentState != null){
        priceFieldKey.currentState.setCount(counter);
      }
    });
  }

  // ignore: non_constant_identifier_names
  void _incrementCounter_minus() {
    setState(() {
      counter--;
      if(priceFieldKey.currentState != null){
        priceFieldKey.currentState.setCount(counter);
      }
    });
  }


  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 0, right: 0),
      child: Container(
        width: 130,
        height: 52,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.black)),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: EdgeInsets.only(left: 0, top: 0, bottom: 0),
            child: InkWell(
              onTap: () {
                if (counter != 1) {
                  _incrementCounter_minus();
                  // counter = restaurantDataItems.records_count;
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8)),
                ),
                height: 40,
                width: 28,
                child: Padding(
                  padding: EdgeInsets.all(7),
                  child: (counter <= 1) ? SvgPicture.asset('assets/svg_images/minus.svg') : SvgPicture.asset('assets/svg_images/black_minus.svg'),
                ),
              ),
            ),
          ),
          SizedBox(width: 15.0),
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Text(
              '$counter',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 0, top: 0, bottom: 0),
            child: InkWell(
              onTap: () async {
                if (await Internet.checkConnection()) {
                  setState(() {
                    _incrementCounter_plus();
                    // counter = restaurantDataItems.records_count;
                  });
                } else {
                  noConnection(context);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8)),
                ),
                height: 40,
                width: 28,
                child: Padding(
                  padding: EdgeInsets.all(7),
                  child: SvgPicture.asset('assets/svg_images/plus_counter.svg'),
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}