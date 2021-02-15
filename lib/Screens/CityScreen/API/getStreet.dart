import 'dart:convert';
import 'package:flutter_app/Screens/MyAddressesScreen/Model/AddressesModel.dart';
import 'package:flutter_app/Screens/MyAddressesScreen/Model/NecessaryAddressModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../../../data/data.dart';
import '../../../data/RefreshToken.dart';


Future<NecessaryAddressData> getStreet(String name, String city_uuid) async {
  //await CreateOrder.sendRefreshToken();
  NecessaryAddressData cityByCoordinates = null;
  var json_request = jsonEncode({
    "name": name,
    "city_uuid": city_uuid
  });
  var url = 'http://78.110.156.74:3003/api/v3/addresses';
  var response = await http.post(url, body: json_request, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    //'Authorization':'Bearer ' + authCodeData.token
  });
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    cityByCoordinates = new NecessaryAddressData.fromJson(jsonResponse);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  print(response.body);
  return cityByCoordinates;
}