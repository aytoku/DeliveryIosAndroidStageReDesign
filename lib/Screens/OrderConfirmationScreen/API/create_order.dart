import 'dart:convert';

import 'package:flutter_app/Screens/CartScreen/Model/CartModel.dart';
import 'package:flutter_app/Screens/MyAddressesScreen/Model/my_addresses_model.dart';
import 'package:flutter_app/data/api.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../../../data/data.dart';
import '../../../data/refreshToken.dart';


Future<CartModel> createOrder(
    String order_uuid,
    bool withoutDelivery,
    bool ownDelivery,
    bool eatInStore,
    DestinationPoints deliveryAddress,
    String entrance,
    String floor,
    String apartment,
    String intercom,
    String comment
    ) async {
  await SendRefreshToken.sendRefreshToken();
  CartModel cartModel = null;
  var json_request = jsonEncode(
      {
        "without_delivery": withoutDelivery,
        "own_delivery": ownDelivery,
        "eat_in_store": eatInStore,
        "delivery_address": (deliveryAddress != null) ? deliveryAddress.toJson() : null,
        "delivery_address_details":{
          "entrance": entrance,
          "floor": floor,
          "apartment": apartment,
          "intercom": intercom
        },
        "comment": comment
      }
  );
  var url = '${apiUrl}orders/${order_uuid}';
  var response = await http.put(url, body: json_request, headers: <String, String>{
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
