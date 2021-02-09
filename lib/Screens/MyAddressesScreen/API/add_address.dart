import 'dart:convert';
import 'package:flutter_app/Screens/MyAddressesScreen/Model/AddressesModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../../../models/ResponseData.dart';


Future<AddressesModelData> addAddress(String uuid, String type, String favorite, DestinationPoints point) async {

  AddressesModelData cityByCoordinates = null;
  var json_request = jsonEncode({
    "type": type,
    "favorite": favorite,
    "point": point,
  });
  var url = 'http://78.110.156.74:3003/api/v3/clients/$uuid/addresses';
  var response = await http.post(url, body: json_request, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
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