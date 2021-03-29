import 'package:http/http.dart' as http;
import 'package:flutter_app/data/api.dart';
import 'dart:convert';
import 'package:flutter_app/CoreColor/Model/color.dart';

  ColorData colorData;

  Future<ColorData> getColorData(String appName) async {

    var url = '${apiUrl}applications/color_scheme?app=$appName';
    var response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "Source": "eda/faem"
    });
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      colorData = new ColorData.fromJson(responseData);
      print(colorData.mainColor);
    } else {
      print('Request get colors failed with status: ${response.statusCode}.');
      print(response.body);
    }
    return colorData;
  }




