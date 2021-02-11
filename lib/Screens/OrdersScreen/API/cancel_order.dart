import 'package:flutter_app/Screens/CartScreen/Model/CartModel.dart';
import 'package:flutter_app/Screens/OrdersScreen/Model/OrdersDetailsModel.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/models/CreateOrderModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;



Future<CartModel> cancelOrder(String order_uuid) async {
  await CreateOrder.sendRefreshToken();
  CartModel cartModel = null;
  var url = 'http://78.110.156.74:3002/api/v3/orders/$order_uuid/cancel';
  var response = await http.put(url, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization':'Bearer ' + authCodeData.token
  });
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    if(jsonResponse != null){
      cartModel  = new CartModel.fromJson(jsonResponse);
    }
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  print(response.body + 'vah');
  return cartModel;
}
