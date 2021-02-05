import 'package:flutter_app/Screens/CartScreen/Model/CartModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../Model/CartModel.dart';


Future<List<Item>> getCartByDeviceId(String device_id) async {

  List<Item> cartModelItems = null;
  var url = 'http://78.110.156.74:3003/api/v3/orders/carts/${device_id}';
  var response = await http.get(url, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  });
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    if(jsonResponse != null){
      cartModelItems = List<Item>.from(jsonResponse.map((x) => Item.fromJson(x)));
    }
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  print(response.body);
  return cartModelItems;
}
