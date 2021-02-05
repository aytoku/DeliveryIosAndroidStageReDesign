import 'dart:convert';

OrderRegistration orderRegistrationFromJson(String str) => OrderRegistration.fromJson(json.decode(str));

String orderRegistrationToJson(OrderRegistration data) => json.encode(data.toJson());

class OrderRegistration {
  OrderRegistration({
    this.orderId,
    this.formUrl,
    this.errorCode,
    this.errorMessage,
  });

  final String orderId;
  final String formUrl;
  final String errorCode;
  final String errorMessage;

  factory OrderRegistration.fromJson(Map<String, dynamic> json) => OrderRegistration(
    orderId: !json.containsKey('orderId') ? '' : json["orderId"],
    formUrl: !json.containsKey('formUrl') ? '' : json["formUrl"],
    errorCode: !json.containsKey('errorCode') ? '' : json["errorCode"],
    errorMessage: !json.containsKey('errorMessage') ? '' : json["errorMessage"],
  );

  Map<String, dynamic> toJson() => {
    "orderId": orderId == null ? null : orderId,
    "formUrl": formUrl == null ? null : formUrl,
    "errorCode": errorCode == null ? null : errorCode,
    "errorMessage": errorMessage == null ? null : errorMessage,
  };
}