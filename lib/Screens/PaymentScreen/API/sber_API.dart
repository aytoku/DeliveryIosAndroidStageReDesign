import 'dart:convert';
import 'package:flutter_app/Screens/PaymentScreen/Model/OrderDeposit.dart';
import 'package:flutter_app/Screens/PaymentScreen/Model/OrderRefund.dart';
import 'package:flutter_app/Screens/PaymentScreen/Model/OrderRegistration.dart';
import 'package:flutter_app/Screens/PaymentScreen/Model/OrderReverse.dart';
import 'package:flutter_app/Screens/PaymentScreen/Model/OrderStatus.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class SberAPI{

  static String sberToken = 'h1ed6cv2f93cm8teci2b63aeeg';
  static String returnUrl = 'https://mail.ru/';
  static String failUrl = 'https://yandex.ru/';
  static String language = 'ru';
  static String clientId = '11';
  static String pageView = 'MOBILE';
  static int orderNumber = 101;
  static int amount = 100;

  static Future<OrderRegistration> orderRegistration() async {
    OrderRegistration orderRegistration = null;
    var request = 'token=$sberToken&orderNumber=$orderNumber&returnUrl=$returnUrl&failUrl=$failUrl&language=$language&clientId=$clientId&amount=$amount&pageView=$pageView';
    var encoded = Uri.encodeFull(request);
    var url = 'https://3dsec.sberbank.ru/payment/rest/register.do';
    var response = await http.post(url, body: encoded, headers: <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
    });
    print(response.body);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      orderRegistration = new OrderRegistration.fromJson(jsonResponse);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    print(response.body);
    return orderRegistration;
  }


  static Future<OrderStatus> getOrderStatus(String orderNumber) async {
    OrderStatus orderStatus = null;
    var request = 'token=$sberToken&orderNumber=$orderNumber&language=$language';
    var encoded = Uri.encodeFull(request);
    var url = 'https://3dsec.sberbank.ru/payment/rest/getOrderStatusExtended.do';
    var response = await http.post(url, body: encoded, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      orderStatus = new OrderStatus.fromJson(jsonResponse);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return orderStatus;
  }


  static Future<OrderReverse> orderReverse(String orderId) async {
    OrderReverse orderReverse = null;
    var request = 'token=$sberToken&orderId=$orderId';
    var encoded = Uri.encodeFull(request);
    var url = 'https://3dsec.sberbank.ru/payment/rest/reverse.do';
    var response = await http.post(url, body: encoded, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      orderReverse = new OrderReverse.fromJson(jsonResponse);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return orderReverse;
  }


  static Future<OrderDeposit> orderDeposit(String orderId, int amount) async {
    OrderDeposit orderDeposit = null;
    var request = 'token=$sberToken&orderId=$orderId&amount=$amount';
    var encoded = Uri.encodeFull(request);
    var url = 'https://3dsec.sberbank.ru/payment/rest/deposit.do';
    var response = await http.post(url, body: encoded, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      orderDeposit = new OrderDeposit.fromJson(jsonResponse);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return orderDeposit;
  }


  static Future<OrderRefund> orderRefund(String orderId, int amount) async {
    OrderRefund orderRefund = null;
    var request = 'token=$sberToken&orderId=$orderId&amount=$amount';
    var encoded = Uri.encodeFull(request);
    var url = 'https://3dsec.sberbank.ru/payment/rest/refund.do';
    var response = await http.post(url, body: encoded, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      orderRefund = new OrderRefund.fromJson(jsonResponse);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return orderRefund;
  }
}