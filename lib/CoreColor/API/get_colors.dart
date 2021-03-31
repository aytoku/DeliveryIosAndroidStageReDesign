import 'package:http/http.dart' as http;
import 'package:flutter_app/data/api.dart';
import 'dart:convert';
import 'package:flutter_app/CoreColor/Model/color.dart';
import 'package:flutter_app/data/global_variables.dart';

  ColorData colorData;

  Future<void> getColorScheme(String appName) async {

    var url = '${apiUrl}applications/color_scheme?app=$appName';
    var response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "Source": "eda/faem"
    });
    print(response.body);
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      AppColor.fromJson(responseData);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return colorData;
  }




