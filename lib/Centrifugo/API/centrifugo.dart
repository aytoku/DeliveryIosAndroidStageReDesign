import 'package:flutter_app/data/refreshToken.dart';
import 'package:flutter_app/data/data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


Future<String> getCentrifugoToken() async {
  await SendRefreshToken.sendRefreshToken();
  var url = 'https://notifier.apis.stage.faem.pro/api/v2/connectiontoken';
  var response = await http.get(url, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
    'Source':'ios_client_app_1',
    "ServiceName": 'faem_food',
    'Authorization':'Bearer ' + authCodeData.token
  });
  print(response.body + 'ku');
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    return jsonResponse['token'];
  } else {
    print('Request failed with status: ${response.statusCode}.');
    return '';
  }
}