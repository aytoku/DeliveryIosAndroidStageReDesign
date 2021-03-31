import 'package:http/http.dart' as http;
import 'package:flutter_app/data/api.dart';
import 'dart:convert';
import 'package:flutter_app/CoreColor/Model/color.dart';

  ColorData colorData;

  Future<void> getColorData(String appName) async {

    var url = '${authApiUrl}clients/new/applications/color_scheme?app=$appName';
    var response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "Source": "eda/faem"
    });
    print(response.body);
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      colorData = new ColorData.fromJson(responseData);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return colorData;
  }




