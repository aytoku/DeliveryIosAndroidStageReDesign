import 'package:flutter_app/Screens/HomeScreen/Model/FilteredStores.dart';
import 'package:flutter_app/Screens/OrderConfirmationScreen/Model/DeliveryTariff.dart';
import 'package:flutter_app/data/api.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


Future<DeliveryTariff> getDeliveryTariff() async {
  DeliveryTariff deliveryTariff;
  var url = '${apiUrl}delivery/tariff';
  var response = await http.get(url, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization':'Bearer ' + authCodeData.token
  });
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    deliveryTariff = DeliveryTariff.fromJson(jsonResponse);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  print(response.body);
  return deliveryTariff;
}