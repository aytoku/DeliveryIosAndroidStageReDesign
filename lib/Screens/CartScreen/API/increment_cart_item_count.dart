import 'dart:convert';
import 'package:flutter_app/Screens/CartScreen/Model/CartModel.dart';
import 'package:flutter_app/Screens/CodeScreen/Model/AuthCode.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


Future<CartModel> incrementCartItemCount(String device_id, int item_id) async {

  CartModel cartModel = null;
  var url = 'http://78.110.156.74:3003/api/v3/orders/carts/${device_id}/items/${item_id}';
  String token = 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1dWlkIjoiMTIzIiwibmFtZSI6InRlc3RfdXNlciIsImV4cCI6ODgxMTEzODMzMywiaWF0IjoxNjExMTM4MzMzLCJpc3MiOiJhdXRoX3NlcnZpY2UifQ.A3hMQOcQFqZ19bj_W86EXmIPpV9jnlZjK6PACARXLiXo6D0Lc2axLDx-uRIu2aEqjtdGdOLL_wv0ICV9oYXIUgLy8jHQtMrHNEHYDzJJSTjc0yF0wXGIT5LtjpeXcA6-ZxyxwpmjeFBpf3lTPDCEWTeRlY-2EMTSgU4C5J_WkcsalOpgwKAtOJGHRPCwq4AZ2jhPTd1ZwR1GaMY08tDVIHWMRi6IQih12RBg1dixkhJms5U10mX_uzIixhMSoQuH1NkPPeujkjGJCOEBD5NG7XP06o2kFCp7TMAnexwlh5FQWHZluK8snkUL9QMzppCZvUDWDd-fCweKyyBw9-Emqw';
  var response = await http.put(url, headers: <String, String>{
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
