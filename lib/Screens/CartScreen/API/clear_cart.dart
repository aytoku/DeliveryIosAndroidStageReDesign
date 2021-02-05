import 'dart:convert';
import 'package:flutter_app/Screens/CartScreen/Model/CartModel.dart';
import 'package:flutter_app/Screens/CodeScreen/Model/AuthCode.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


Future<CartModel> clearCart(String device_id) async {

  CartModel cartModel = null;
  var url = 'http://78.110.156.74:3003/api/v3/orders/carts/${device_id}/clear';
  var response = await http.delete(url, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  });
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    cartModel = new CartModel.fromJson(jsonResponse);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  print(response.body);
  return cartModel;
}
