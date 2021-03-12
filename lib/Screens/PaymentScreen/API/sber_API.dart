import 'dart:convert';
import 'package:flutter_app/Screens/PaymentScreen/Model/GooglePay.dart';
import 'package:flutter_app/Screens/PaymentScreen/Model/OrderDeposit.dart';
import 'package:flutter_app/Screens/PaymentScreen/Model/OrderRefund.dart';
import 'package:flutter_app/Screens/PaymentScreen/Model/OrderRegistration.dart';
import 'package:flutter_app/Screens/PaymentScreen/Model/OrderReverse.dart';
import 'package:flutter_app/Screens/PaymentScreen/Model/OrderStatus.dart';
import 'package:flutter_app/Screens/PaymentScreen/Model/SberGooglePayment.dart';
import 'package:flutter_app/data/data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class SberAPI{

  static String sberToken = 'h1ed6cv2f93cm8teci2b63aeeg';
  static String returnUrl = 'https://mail.ru/';
  static String failUrl = 'https://yandex.ru/';
  static String language = 'ru';
  static String clientId = '11';
  static String pageView = 'MOBILE';
  static int orderNumber = 2287;
  static int amount = 154;

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


  static Future<OrderStatus> getOrderStatus(String orderId) async {
    OrderStatus orderStatus = null;
    var request = 'token=$sberToken&orderId=$orderId';
    var encoded = Uri.encodeFull(request);
    var url = 'https://3dsec.sberbank.ru/payment/rest/getOrderStatusExtended.do';
    var response = await http.post(url, body: encoded, headers: <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
    });
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      orderStatus = new OrderStatus.fromJson(jsonResponse);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    print(response.body);
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

  static Future<SberGooglePayment> googlePay(Map<String, String> googlePay) async {
    SberGooglePayment sberGooglePayment = null;
    var request = convert.jsonEncode({
      'merchant': 'T1513081007',
      'orderNumber': orderNumber,
      'paymentToken': convert.base64Encode(utf8.encode(googlePay['token'])),
      'amount': amount,
      'phone': currentUser.phone,
      'returnUrl': returnUrl,
    });
    var url = 'https://3dsec.sberbank.ru/payment/google/payment.do';
    var response = await http.post(url, body: request, headers: <String, String>{
      'Content-Type': 'application/json'
    });
    print(response.body);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      sberGooglePayment = new SberGooglePayment.fromJson(jsonResponse);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }


    return sberGooglePayment;
  }
}