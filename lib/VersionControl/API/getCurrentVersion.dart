import 'package:flutter_app/VersionControl/Model/CurrentVersionModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../../data/api.dart';

Future<CurrentVersionModel> getCurrentVersion() async {
  CurrentVersionModel currentVersion = null;
  var url = '${apiUrl}versions/last';
  var response = await http.get(url, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
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