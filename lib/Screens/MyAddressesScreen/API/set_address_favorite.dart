
import 'package:flutter_app/Screens/MyAddressesScreen/Model/AddressesModel.dart';
import 'package:flutter_app/data/global_variables.dart';
import 'package:flutter_app/CoreColor/API/get_colors.dart';
import 'package:flutter_app/data/refreshToken.dart';
import 'package:flutter_app/data/api.dart';
import 'package:flutter_app/data/data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


Future<AddressesModelData> setAddressFavorite(String address_uuid) async {
  AddressesModelData addressModel = null;
  await SendRefreshToken.sendRefreshToken();
  var url = '${apiUrl}clients/addresses/$address_uuid';
  var response = await http.put(url, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
    'Source':'ios_client_app_1',
    "ServiceName": 'faem_food',
    'Authorization':'Bearer ' + authCodeData.token
  });
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    addressModel = new AddressesModelData.fromJson(jsonResponse);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  print(response.body);
  return addressModel;
}