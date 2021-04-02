import 'package:flutter_app/Screens/RestaurantScreen/Model/FilteredProductCategories.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Model/ProductDataModel.dart';
import 'package:flutter_app/data/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../Model/ProductsByStoreUuid.dart';


Future<ProductsByStoreUuidData> getFilteredProductCategories(String product_category_uuid, String store_uuid) async {
  ProductsByStoreUuidData productByStoreUuidData = null;
  var url = '${apiUrl}/products/filter?product_category_uuid=$product_category_uuid&store_uuid=$store_uuid';
  var response = await http.get(url, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
  });
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    productByStoreUuidData = new ProductsByStoreUuidData.fromJson(jsonResponse);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  print(response.body);
  return productByStoreUuidData;
}