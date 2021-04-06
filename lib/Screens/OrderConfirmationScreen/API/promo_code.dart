import 'package:flutter_app/Screens/CartScreen/Model/CartModel.dart';
import 'package:flutter_app/data/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

Future<CartModel> sendPromo(String code) async {
  CartModel cartModel;
  var url = '${apiUrl}promotion/$code/apply';
  var jsonRequest = ({
    ''
  });
  var response = await http.post(url, body: jsonRequest, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  });
  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    cartModel = new CartModel.fromJson(jsonResponse);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  return cartModel;
}