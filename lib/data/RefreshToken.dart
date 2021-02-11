import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../Amplitude/amplitude.dart';
import '../Config/config.dart';
import '../Screens/OrderConfirmationScreen/API/necessary_address_data_pass.dart';
import 'data.dart';
import '../Screens/CodeScreen/Model/AuthCode.dart';

class RefreshToken {


  static Future<bool> sendRefreshToken() async {
    bool isSuccess = false;
    var url = 'http://78.110.156.74:3005/api/v3/auth/clients/refresh';
    var response = await http.post(
        url, body: jsonEncode({
      "refresh": authCodeData.refreshToken.value,
      "service": "eda",
      "device_id": necessaryDataForAuth.device_id}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':'Bearer ' + authCodeData.token
        });
    print('ТУТ КЕФРЕЭ ' + authCodeData.refreshToken.value);
    if (response.statusCode == 200) {
      isSuccess = true;
      var jsonResponse = convert.jsonDecode(response.body);
      authCodeData = AuthCodeData.fromJson(jsonResponse);
      necessaryDataForAuth.refresh_token = authCodeData.refreshToken.value;
      necessaryDataForAuth.token = authCodeData.token;
      await NecessaryDataForAuth.saveData();
      //await sendFCMToken(FCMToken);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    print(response.body);
    return isSuccess;
  }
}