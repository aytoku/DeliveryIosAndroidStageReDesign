import 'dart:convert';
import 'package:flutter_app/Screens/AuthScreen/Model/Auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

Future<AuthData> loadAuthData(String device_id, String phone, String service) async {
  AuthData authData = null;
  var json_request = jsonEncode({
    "device_id": device_id,
    "phone": phone,
    "service": service
  });
  print(device_id+ " " + phone + " " + service);
  var url = 'http://78.110.156.74:3005/api/v3/clients/new';
  var response = await http.post(url, body: json_request, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  });
  print(response.body);
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    authData = new AuthData.fromJson(jsonResponse);

  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  return authData;
}