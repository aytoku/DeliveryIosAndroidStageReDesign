import 'package:flutter_app/Screens/CartScreen/Model/CartModel.dart';
import 'package:flutter_app/data/api.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/data/globalVariables.dart';
import 'dart:convert';
import 'dart:async';

Future<CartModel> sendPromo(String code, String uuid) async {
  CartModel cartModel;
  var url = '${apiUrl}promotion/apply?uuid=$uuid&code=$code';

  var response = await http.get(url, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    // 'Authorization':'Bearer ' + authCodeData.token
  });
  print("URL $url");
  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    cartModel = new CartModel.fromJson(jsonResponse);
    print("PROMO: ${response.body}");
  } else {
    print(response.body);
    print('Request promo failed with status: ${response.statusCode}.');
  }
  return cartModel;
}