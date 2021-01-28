import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../Model/CityByCoordinates.dart';

Future<CityByCoordinates> getCityByCoordinates(double lat, double long) async {

  CityByCoordinates cityByCoordinates = null;
  var json_request = jsonEncode({
    "lat": lat,
    "long": long
  });
  var url = 'http://78.110.156.74:3003/api/v3/cities/findaddress';
  var response = await http.post(url, body: json_request, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  });
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    cityByCoordinates = new CityByCoordinates.fromJson(jsonResponse);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  print(response.body);
  return cityByCoordinates;
}