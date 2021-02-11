import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/HomeScreen/Model/FilteredStores.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Model/ProductsByStoreUuid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


Future<ProductsByStoreUuidData> getProductsByStoreUuid(String store_uuid) async {
  ProductsByStoreUuidData productsByStoreUuid = null;
  var url = 'http://78.110.156.74:3003/api/v3/products/store/${store_uuid}';
  var response = await http.get(url, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
    'Source':'ios_client_app_1',
    "ServiceName": 'faem_food',
  });
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    productsByStoreUuid = new ProductsByStoreUuidData.fromJson(jsonResponse);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  //print(response.body);
  return productsByStoreUuid;
}

Future<ProductsByStoreUuidData> getSortedProductsByStoreUuid(FilteredStores store) async{
  ProductsByStoreUuidData productsByStoreUuid = await getProductsByStoreUuid(store.uuid);
  if(productsByStoreUuid == null || productsByStoreUuid.productsByStoreUuidList == null)
    return productsByStoreUuid;


    productsByStoreUuid.productsByStoreUuidList.sort((ProductsByStoreUuid a, ProductsByStoreUuid b) {
      int ind1 = store.productCategoriesUuid.indexWhere((element) {
        return (element.uuid == a.uuid);
      });

      int ind2 = store.productCategoriesUuid.indexWhere((element) {
        return (element.uuid == b.uuid);
      });

      return (ind1 > ind2) ? 1 : -1;
    });
    return productsByStoreUuid;
}