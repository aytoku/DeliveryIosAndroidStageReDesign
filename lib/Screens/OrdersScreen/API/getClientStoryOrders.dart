import 'package:flutter_app/Screens/CartScreen/Model/CartModel.dart';
import 'package:flutter_app/Screens/OrdersScreen/Model/OrdersDetailsModel.dart';
import 'package:flutter_app/data/global_variables.dart';
import 'package:flutter_app/data/refreshToken.dart';
import 'package:flutter_app/data/api.dart';
import 'package:flutter_app/data/data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;



Future<OrderDetailsModel> getClientStoryOrders() async {
  await SendRefreshToken.sendRefreshToken();
  OrderDetailsModel ordersDetails = null;
  var url = '${apiUrl}orders/history';
  var response = await http.get(url, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization':'Bearer ' + authCodeData.token
  });
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    if(jsonResponse != null){
      ordersDetails = new OrderDetailsModel.fromJson(jsonResponse);
    }
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  print(response.body + 'vah');
  return ordersDetails;
}
