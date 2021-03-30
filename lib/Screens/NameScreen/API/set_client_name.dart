import 'package:flutter_app/Screens/CartScreen/Model/CartModel.dart';
import 'package:flutter_app/data/api.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


Future<void> setClientName(String uuid, String name) async {

  //CartModel cartModelItems = null;
  var url = '${apiUrl}clients/$uuid/$name';
  var response = await http.put(url, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization':'Bearer ' + authCodeData.token
  });
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    if(jsonResponse != null){
      //cartModelItems = new CartModel.fromJson(jsonResponse);
    }
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  print(response.body + 'vah');
  //return cartModelItems;
}