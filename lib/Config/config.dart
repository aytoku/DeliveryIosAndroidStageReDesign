import 'dart:convert';
import 'package:device_id/device_id.dart';
import 'package:flutter_app/Screens/CodeScreen/Model/AuthCode.dart';
import 'package:flutter_app/data/data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../Centrifugo/centrifugo.dart';
import '../Screens/CityScreen/Model/FilteredCities.dart';
import '../data/data.dart';

class NecessaryDataForAuth{
  String device_id;
  String phone_number;
  String refresh_token;
  String name;
  String token;
  FilteredCities city;
  static NecessaryDataForAuth _necessaryDataForAuth;

  NecessaryDataForAuth({
    this.device_id,
    this.phone_number,
    this.token,
    this.city,
    this.refresh_token,
    this.name
  });

  static Future<NecessaryDataForAuth> getData() async{
  //    await Future.delayed(Duration(seconds: 4), () {});
    if(_necessaryDataForAuth != null)
      return _necessaryDataForAuth;
    String device_id = await DeviceId.getID;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String phone_number = prefs.getString('phone_number');
    String refresh_token = prefs.getString('refresh_token');
    String name = prefs.getString('name');
    String cityJson = prefs.getString('city');
    String token = prefs.getString('token');


    FilteredCities city;

    if(cityJson != null){
      city = FilteredCities.fromJson(convert.jsonDecode(cityJson));
    }

    NecessaryDataForAuth result = new NecessaryDataForAuth(
        device_id: device_id,
        phone_number: phone_number,
        refresh_token: refresh_token,
        name: name,
        token: token,
        city: city,
    );

    refresh_token = await refreshToken(refresh_token, token, device_id);

    result.refresh_token = refresh_token;
    _necessaryDataForAuth = result;
    if(refresh_token != null){
      result.token = authCodeData.token;
      await Centrifugo.connectToServer();
      await saveData();
    }

    return result;
  }

  static Future saveData() async{
    String phone_number = _necessaryDataForAuth.phone_number;
    String refresh_token = _necessaryDataForAuth.refresh_token;
    String name = _necessaryDataForAuth.name;
    String city = convert.jsonEncode(_necessaryDataForAuth.city.toJson());
    String token = _necessaryDataForAuth.token;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('phone_number', phone_number);
    prefs.setString('refresh_token',refresh_token);
    prefs.setString('name',name);
    prefs.setString('city',city);
    prefs.setString('token',token);
  }

  static Future<String> refreshToken(String refresh_token, String token, String device_id) async {
    String result = null;
    var url = 'http://78.110.156.74:3005/api/v3/auth/clients/refresh';
    print(refresh_token);
    print('--------');
    print(token);
    if(refresh_token == null || token == null){
      return null;
    }
    var response = await http.post(url, body: jsonEncode({
      "device_id": device_id,
      "service": "eda",
      "refresh": refresh_token
      }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':'Bearer ' + token
        });
    print(response.body);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      authCodeData = AuthCodeData.fromJson(jsonResponse);
      result = authCodeData.refreshToken.value;
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return result;
  }

  static Future clear() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _necessaryDataForAuth = null;
    necessaryDataForAuth = null;
  }
}