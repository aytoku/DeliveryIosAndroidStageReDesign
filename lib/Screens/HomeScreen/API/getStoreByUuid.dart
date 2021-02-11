import 'package:flutter_app/data/RefreshToken.dart';
import 'package:flutter_app/data/data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../Model/StoreByUuid.dart';


Future<StoreByUuid> getStoreByUuid() async {
  await RefreshToken.sendRefreshToken();
  StoreByUuid storeByUuid = null;
  var url = 'http://78.110.156.74:3003/api/v3/stores/2c4d40ad-c1d6-400a-9f45-ab6bb7382db0';
  var response = await http.get(url, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
    'Source':'ios_client_app_1',
    "ServiceName": 'faem_food',
    'Authorization':'Bearer ' + authCodeData.token
  });
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    storeByUuid = new StoreByUuid.fromJson(jsonResponse);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  print(response.body);
  return storeByUuid;
}