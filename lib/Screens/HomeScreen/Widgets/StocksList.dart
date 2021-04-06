import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/HomeScreen/Model/Stock.dart';
import 'package:flutter_app/Screens/HomeScreen/API/getStocks.dart';

class StocksList extends StatefulWidget {
  GlobalKey<StocksListState> key;

  StocksList({this.key}) : super(key: key);

  @override
  StocksListState createState() => StocksListState();
}

class StocksListState extends State<StocksList>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  List<Stock> stocks;
  ScrollController stocksScrollController;

  @override
  bool get wantKeepAlive => true;

  List<Widget> _buildStockList(List<Stock> stocks) {
    List<Widget> result = new List<Widget>();
    result.add(
      Container(
        height: 120,
        child: Container(
          width: 130,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 2.0, // soften the shadow
                spreadRadius: 1.0, //extend the shadow
              )
            ],

          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (stocks != null) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: 150,
          child: ListView(
            controller: stocksScrollController,
            scrollDirection: Axis.horizontal,
            children: [],
          ),
        ),
      );
    }
    return Container();
  }
}
