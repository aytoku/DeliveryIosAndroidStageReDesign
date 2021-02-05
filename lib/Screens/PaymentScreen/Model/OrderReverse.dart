import 'dart:convert';

OrderReverse orderRegistrationFromJson(String str) => OrderReverse.fromJson(json.decode(str));

String orderRegistrationToJson(OrderReverse data) => json.encode(data.toJson());

class OrderReverse {
  OrderReverse({
    this.errorCode,
    this.errorMessage,
  });

  final String errorCode;
  final String errorMessage;

  factory OrderReverse.fromJson(Map<String, dynamic> json) => OrderReverse(
    errorCode: !json.containsKey('errorCode') ? '' : json["errorCode"],
    errorMessage: !json.containsKey('errorMessage') ? '' : json["errorMessage"],
  );

  Map<String, dynamic> toJson() => {
    "errorCode": errorCode == null ? null : errorCode,
    "errorMessage": errorMessage == null ? null : errorMessage,
  };
}