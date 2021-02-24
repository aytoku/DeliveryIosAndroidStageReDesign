import 'package:flutter_app/Screens/ServiceScreen/Model/TicketModel.dart';
import 'package:flutter_app/data/refreshToken.dart';
import 'package:flutter_app/data/data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

Future<TicketsListRecord> getTicketByUuid(String uuid) async {
  TicketsListRecord ticketsListRecord = null;
  await SendRefreshToken.sendRefreshToken();
  var url = 'https://crm.apis.stage.faem.pro/api/v2/tickets/$uuid';
  var response = await http.get(url, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
    'Source':'ios_client_app_1',
    "ServiceName": 'faem_food',
    'Authorization':'Bearer ' + authCodeData.token
  });
  if (response.statusCode == 200) {

    print(response.body);
    var jsonResponse = convert.jsonDecode(response.body);
    ticketsListRecord = TicketsListRecord.fromJson(jsonResponse);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  print(response.body);
  return ticketsListRecord;
}