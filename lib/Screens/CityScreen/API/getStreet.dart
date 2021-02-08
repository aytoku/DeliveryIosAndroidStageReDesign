import 'dart:convert';
import 'package:flutter_app/Screens/MyAddressesScreen/Models/AddressesModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../../../data/data.dart';
import '../../../models/CreateOrderModel.dart';
import '../../../models/ResponseData.dart';


Future<AddressesModelData> getStreet(String name, String city_uuid) async {
  await CreateOrder.sendRefreshToken();
  AddressesModelData cityByCoordinates = null;
  var json_request = jsonEncode({
    "name": name,
    "city_uuid": city_uuid
  });
  var url = 'http://78.110.156.74:3003/api/v3/streets';
  var response = await http.post(url, body: json_request, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization':'Bearer ' + authCodeData.token
  });
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    cityByCoordinates = new AddressesModelData.fromJson(jsonResponse);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  print(response.body);
  return cityByCoordinates;
}