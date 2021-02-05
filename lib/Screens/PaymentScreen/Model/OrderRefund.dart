import 'dart:convert';

OrderRefund orderRegistrationFromJson(String str) => OrderRefund.fromJson(json.decode(str));

String orderRegistrationToJson(OrderRefund data) => json.encode(data.toJson());

class OrderRefund {
  OrderRefund({
    this.errorCode,
  });

  final String errorCode;

  factory OrderRefund.fromJson(Map<String, dynamic> json) => OrderRefund(
    errorCode: !json.containsKey('errorCode') ? '' : json["errorCode"],
  );

  Map<String, dynamic> toJson() => {
    "errorCode": errorCode == null ? null : errorCode,
  };
}