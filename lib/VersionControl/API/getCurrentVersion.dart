import 'package:flutter_app/VersionControl/Model/CurrentVersionModel.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/models/CreateOrderModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

Future<CurrentVersionModel> getCurrentVersion() async {
  CurrentVersionModel currentVersion = null;
  var url = 'http://78.110.156.74:3003/api/v3/versions/last';
  String token = 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1dWlkIjoiMTIzIiwibmFtZSI6InRlc3RfdXNlciIsImV4cCI6ODgxMTEzODMzMywiaWF0IjoxNjExMTM4MzMzLCJpc3MiOiJhdXRoX3NlcnZpY2UifQ.A3hMQOcQFqZ19bj_W86EXmIPpV9jnlZjK6PACARXLiXo6D0Lc2axLDx-uRIu2aEqjtdGdOLL_wv0ICV9oYXIUgLy8jHQtMrHNEHYDzJJSTjc0yF0wXGIT5LtjpeXcA6-ZxyxwpmjeFBpf3lTPDCEWTeRlY-2EMTSgU4C5J_WkcsalOpgwKAtOJGHRPCwq4AZ2jhPTd1ZwR1GaMY08tDVIHWMRi6IQih12RBg1dixkhJms5U10mX_uzIixhMSoQuH1NkPPeujkjGJCOEBD5NG7XP06o2kFCp7TMAnexwlh5FQWHZluK8snkUL9QMzppCZvUDWDd-fCweKyyBw9-Emqw';
  var response = await http.get(url, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
    'Source':'ios_client_app_1',
    "ServiceName": 'faem_food',
    'Authorization':'Bearer ' + token
  });
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    currentVersion = new CurrentVersionModel.fromJson(jsonResponse);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  print(response.body);
  return currentVersion;
}