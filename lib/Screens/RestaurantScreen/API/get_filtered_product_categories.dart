import 'package:flutter_app/Screens/RestaurantScreen/Model/FilteredProductCategories.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Model/ProductDataModel.dart';
import 'package:flutter_app/data/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


Future<FilteredProductCategories> getFilteredProductCategories(String store_uuid, String parent_uuid, String city_uuid) async {
  FilteredProductCategories filteredProductCategories = null;
  var url = '${apiUrl}products/categories/filter?parent_uuid=$parent_uuid&city_uuid=$city_uuid&store_uuid=$store_uuid';
  var response = await http.get(url, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
  });
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    filteredProductCategories = new FilteredProductCategories.fromJson(jsonResponse);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  print(response.body);
  return filteredProductCategories;
}