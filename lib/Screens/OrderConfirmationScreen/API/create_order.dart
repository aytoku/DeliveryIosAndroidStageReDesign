import 'package:flutter_app/Screens/CartScreen/Model/CartModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../../../data/data.dart';
import '../../../models/RefreshToken.dart';


Future<CartModel> createOrder(String order_uuid) async {
  await RefreshToken.sendRefreshToken();
  CartModel cartModel = null;
  var url = 'http://78.110.156.74:3003/api/v3/orders/${order_uuid}';
  var response = await http.put(url, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization':'Bearer ' + authCodeData.token
  });
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    cartModel = new CartModel.fromJson(jsonResponse);
  } else {
    print('Request failed with status: ${response.statusCode}. ');
  }
  print(response.body);
  return cartModel;
}
