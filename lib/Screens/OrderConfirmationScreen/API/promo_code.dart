import 'package:flutter_app/Screens/CartScreen/Model/CartModel.dart';
import 'package:flutter_app/data/api.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

Future<CartModel> sendPromo(String code, String uuid) async {
  CartModel cartModel;
  var url = '${apiUrl}promotions/apply?uuid=$uuid&code=$code';

  var response = await http.post(url, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8'
  });
  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    cartModel = new CartModel.fromJson(jsonResponse);
    print("PROMO: ${response.body}");
  } else {
    print('Request promo failed with status: ${response.statusCode}.');
  }
  print(response.body);
  return cartModel;
}