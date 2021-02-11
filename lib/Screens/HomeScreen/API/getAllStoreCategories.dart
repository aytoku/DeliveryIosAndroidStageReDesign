import 'package:flutter_app/Screens/HomeScreen/Model/AllStoreCategories.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


Future<AllStoreCategoriesData> getAllStoreCategories(String city_uuid) async {
  AllStoreCategoriesData allStoreCategories = null;
  var url = 'http://78.110.156.74:3003/api/v3/stores/categories/filter?city_uuid+${city_uuid}';
  var response = await http.get(url, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
    'Source':'ios_client_app_1',
    "ServiceName": 'faem_food',
  });
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    allStoreCategories = new AllStoreCategoriesData.fromJson(jsonResponse);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  print(response.body);
  return allStoreCategories;
}