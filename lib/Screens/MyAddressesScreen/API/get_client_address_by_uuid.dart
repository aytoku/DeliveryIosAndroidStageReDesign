
import 'package:flutter_app/Screens/MyAddressesScreen/Model/AddressesModel.dart';
import 'package:flutter_app/Screens/MyAddressesScreen/Model/my_addresses_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


Future<MyFavouriteAddressesModel> getClientAddressByUuid(String client_uuid, String address_uuid) async {
  MyFavouriteAddressesModel addressModel = null;
  var url = 'http://78.110.156.74:3003/api/v3/clients/$client_uuid/addresses/$address_uuid';
  var response = await http.get(url, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
    'Source':'ios_client_app_1',
    "ServiceName": 'faem_food',
  });
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    addressModel = new MyFavouriteAddressesModel.fromJson(jsonResponse);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  print(response.body);
  return addressModel;
}