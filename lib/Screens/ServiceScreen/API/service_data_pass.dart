import 'dart:convert';
import 'package:flutter_app/Screens/ServiceScreen/Model/ServiceModel.dart';
import 'package:flutter_app/Screens/ServiceScreen/Model/TicketModel.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:flutter_app/data/refreshToken.dart';
import 'package:flutter_app/data/data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

Future<ServiceModel> loadServiceData(TicketModel ticketModel) async {

  ServiceModel serviceModel = null;
  await SendRefreshToken.sendRefreshToken();
  var json_request = jsonEncode({
    "title": ticketModel.title,
    "description": ticketModel.description,
    "order_data": {
      "name": "",
      "uuid": ticketModel.uuid
    }
  });
  var url = 'https://crm.apis.stage.faem.pro/api/v2/tickets';
  var response = await http.post(url, body: json_request, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
    'Source':'faem_food',
    'Authorization':'Bearer ' + authCodeData.token
  });
  if (response.statusCode == 200) {

    print(response.body);
    var jsonResponse = convert.jsonDecode(response.body);
    serviceModel = new ServiceModel.fromJson(jsonResponse);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  return serviceModel;
}