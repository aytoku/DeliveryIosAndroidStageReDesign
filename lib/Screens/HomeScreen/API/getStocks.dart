import 'package:flutter_app/Screens/HomeScreen/Model/Stock.dart';
import 'package:flutter_app/data/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

Future<StockData> getStocks(String cityUuid) async {
  StockData stockData;
  var url = '${apiUrl}promotions/$cityUuid';
  var response = await http.get(url, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  });
  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    stockData = new StockData.fromJson(jsonResponse);
  } else {
    print('Request stocks failed with status: ${response.statusCode}.');
  }
  return stockData;
}
