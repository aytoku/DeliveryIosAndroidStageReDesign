// To parse this JSON data, do
//
//     final orderStatus = orderStatusFromJson(jsonString);

import 'dart:convert';

OrderStatus orderStatusFromJson(String str) => OrderStatus.fromJson(json.decode(str));

String orderStatusToJson(OrderStatus data) => json.encode(data.toJson());

class OrderStatus {
  OrderStatus({
    this.errorCode,
    this.errorMessage,
    this.orderNumber,
    this.orderStatus,
    this.actionCode,
    this.actionCodeDescription,
    this.amount,
    this.currency,
    this.date,
    this.orderDescription,
    this.merchantOrderParams,
    this.attributes,
    this.cardAuthInfo,
    this.terminalId,
  });

  final String errorCode;
  final String errorMessage;
  final String orderNumber;
  final int orderStatus;
  final int actionCode;
  final String actionCodeDescription;
  final int amount;
  final String currency;
  final int date;
  final String orderDescription;
  final List<Attribute> merchantOrderParams;
  final List<Attribute> attributes;
  final CardAuthInfo cardAuthInfo;
  final String terminalId;

  factory OrderStatus.fromJson(Map<String, dynamic> json) => OrderStatus(
    errorCode: json["errorCode"] == null ? null : json["errorCode"],
    errorMessage: json["errorMessage"] == null ? null : json["errorMessage"],
    orderNumber: json["orderNumber"] == null ? null : json["orderNumber"],
    orderStatus: json["orderStatus"] == null ? null : json["orderStatus"],
    actionCode: json["actionCode"] == null ? null : json["actionCode"],
    actionCodeDescription: json["actionCodeDescription"] == null ? null : json["actionCodeDescription"],
    amount: json["amount"] == null ? null : json["amount"],
    currency: json["currency"] == null ? null : json["currency"],
    date: json["date"] == null ? null : json["date"],
    orderDescription: json["orderDescription"] == null ? null : json["orderDescription"],
    merchantOrderParams: json["merchantOrderParams"] == null ? null : List<Attribute>.from(json["merchantOrderParams"].map((x) => Attribute.fromJson(x))),
    attributes: json["attributes"] == null ? null : List<Attribute>.from(json["attributes"].map((x) => Attribute.fromJson(x))),
    cardAuthInfo: json["cardAuthInfo"] == null ? null : CardAuthInfo.fromJson(json["cardAuthInfo"]),
    terminalId: json["terminalId"] == null ? null : json["terminalId"],
  );

  Map<String, dynamic> toJson() => {
    "errorCode": errorCode == null ? null : errorCode,
    "errorMessage": errorMessage == null ? null : errorMessage,
    "orderNumber": orderNumber == null ? null : orderNumber,
    "orderStatus": orderStatus == null ? null : orderStatus,
    "actionCode": actionCode == null ? null : actionCode,
    "actionCodeDescription": actionCodeDescription == null ? null : actionCodeDescription,
    "amount": amount == null ? null : amount,
    "currency": currency == null ? null : currency,
    "date": date == null ? null : date,
    "orderDescription": orderDescription == null ? null : orderDescription,
    "merchantOrderParams": merchantOrderParams == null ? null : List<dynamic>.from(merchantOrderParams.map((x) => x.toJson())),
    "attributes": attributes == null ? null : List<dynamic>.from(attributes.map((x) => x.toJson())),
    "cardAuthInfo": cardAuthInfo == null ? null : cardAuthInfo.toJson(),
    "terminalId": terminalId == null ? null : terminalId,
  };
}

class Attribute {
  Attribute({
    this.name,
    this.value,
  });

  final String name;
  final String value;

  factory Attribute.fromJson(Map<String, dynamic> json) => Attribute(
    name: json["name"] == null ? null : json["name"],
    value: json["value"] == null ? null : json["value"],
  );

  Map<String, dynamic> toJson() => {
    "name": name == null ? null : name,
    "value": value == null ? null : value,
  };
}

class CardAuthInfo {
  CardAuthInfo({
    this.expiration,
    this.cardholderName,
    this.secureAuthInfo,
    this.pan,
  });

  final String expiration;
  final String cardholderName;
  final SecureAuthInfo secureAuthInfo;
  final String pan;

  factory CardAuthInfo.fromJson(Map<String, dynamic> json) => CardAuthInfo(
    expiration: json["expiration"] == null ? null : json["expiration"],
    cardholderName: json["cardholderName"] == null ? null : json["cardholderName"],
    secureAuthInfo: json["secureAuthInfo"] == null ? null : SecureAuthInfo.fromJson(json["secureAuthInfo"]),
    pan: json["pan"] == null ? null : json["pan"],
  );

  Map<String, dynamic> toJson() => {
    "expiration": expiration == null ? null : expiration,
    "cardholderName": cardholderName == null ? null : cardholderName,
    "secureAuthInfo": secureAuthInfo == null ? null : secureAuthInfo.toJson(),
    "pan": pan == null ? null : pan,
  };
}

class SecureAuthInfo {
  SecureAuthInfo({
    this.eci,
    this.threeDsInfo,
  });

  final int eci;
  final ThreeDsInfo threeDsInfo;

  factory SecureAuthInfo.fromJson(Map<String, dynamic> json) => SecureAuthInfo(
    eci: json["eci"] == null ? null : json["eci"],
    threeDsInfo: json["threeDSInfo"] == null ? null : ThreeDsInfo.fromJson(json["threeDSInfo"]),
  );

  Map<String, dynamic> toJson() => {
    "eci": eci == null ? null : eci,
    "threeDSInfo": threeDsInfo == null ? null : threeDsInfo.toJson(),
  };
}

class ThreeDsInfo {
  ThreeDsInfo({
    this.xid,
  });

  final String xid;

  factory ThreeDsInfo.fromJson(Map<String, dynamic> json) => ThreeDsInfo(
    xid: json["xid"] == null ? null : json["xid"],
  );

  Map<String, dynamic> toJson() => {
    "xid": xid == null ? null : xid,
  };
}