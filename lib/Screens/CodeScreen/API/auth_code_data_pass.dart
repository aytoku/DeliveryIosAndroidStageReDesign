import 'dart:convert';
import 'package:flutter_app/Screens/CodeScreen/Model/AuthCode.dart';
import 'package:flutter_app/data/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

Future<AuthCodeData> loadAuthCodeData(String device_id, int code, String service) async {

  AuthCodeData authCodeData = null;
  var json_request = jsonEncode({
    "device_id": device_id,
    "code": code,
    "service": service,
  });
  var url = '${authApiUrl}clients/verification';
  var response = await http.post(url, body: json_request, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  });
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    authCodeData = new AuthCodeData.fromJson(jsonResponse);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  print(response.body);
  return authCodeData;
}