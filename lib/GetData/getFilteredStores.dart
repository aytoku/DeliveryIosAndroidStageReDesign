import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/models/CreateOrderModel.dart';
import 'package:flutter_app/models/FilteredStores.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


Future<FilteredStoresData> getFilteredStores(String city_uuid) async {
  FilteredStoresData filteredStores = null;
  var url = 'http://78.110.156.74:3003/api/v3/stores/filter?city_uuid=${city_uuid}';
  var response = await http.get(url, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
    'Source':'ios_client_app_1',
    "ServiceName": 'faem_food',
  });
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    filteredStores = new FilteredStoresData.fromJson(jsonResponse);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  print(response.body);
  return filteredStores;
}