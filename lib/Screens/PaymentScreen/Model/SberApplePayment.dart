class ApplePaymentSuccess {
  ApplePaymentSuccess({
    this.success,
    this.data,
    this.orderStatus,
  });

  final bool success;
  final Data data;
  final AppleOrderStatus orderStatus;

  factory ApplePaymentSuccess.fromJson(Map<String, dynamic> json) => ApplePaymentSuccess(
    success: json["success"] == null ? null : json["success"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    orderStatus: json["orderStatus"] == null ? null : AppleOrderStatus.fromJson(json["orderStatus"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "data": data == null ? null : data.toJson(),
    "orderStatus": orderStatus == null ? null : orderStatus.toJson(),
  };
}

class Data {
  Data({
    this.orderId,
  });

  final String orderId;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    orderId: json["orderId"] == null ? null : json["orderId"],
  );

  Map<String, dynamic> toJson() => {
    "orderId": orderId == null ? null : orderId,
  };
}

class AppleOrderStatus {
  AppleOrderStatus({
    this.errorCode,
    this.orderNumber,
    this.orderStatus,
    this.actionCode,
    this.actionCodeDescription,
    this.amount,
    this.currency,
    this.date,
    this.ip,
    this.merchantOrderParams,
    this.attributes,
    this.cardAuthInfo,
    this.authDateTime,
    this.terminalId,
    this.authRefNum,
    this.paymentAmountInfo,
    this.bankInfo,
  });

  final String errorCode;
  final String orderNumber;
  final int orderStatus;
  final int actionCode;
  final String actionCodeDescription;
  final int amount;
  final String currency;
  final int date;
  final String ip;
  final List<Attribute> merchantOrderParams;
  final List<Attribute> attributes;
  final CardAuthInfo cardAuthInfo;
  final int authDateTime;
  final String terminalId;
  final String authRefNum;
  final PaymentAmountInfo paymentAmountInfo;
  final BankInfo bankInfo;

  factory AppleOrderStatus.fromJson(Map<String, dynamic> json) => AppleOrderStatus(
    errorCode: json["errorCode"] == null ? null : json["errorCode"],
    orderNumber: json["orderNumber"] == null ? null : json["orderNumber"],
    orderStatus: json["orderStatus"] == null ? null : json["orderStatus"],
    actionCode: json["actionCode"] == null ? null : json["actionCode"],
    actionCodeDescription: json["actionCodeDescription"] == null ? null : json["actionCodeDescription"],
    amount: json["amount"] == null ? null : json["amount"],
    currency: json["currency"] == null ? null : json["currency"],
    date: json["date"] == null ? null : json["date"],
    ip: json["ip"] == null ? null : json["ip"],
    merchantOrderParams: json["merchantOrderParams"] == null ? null : List<Attribute>.from(json["merchantOrderParams"].map((x) => Attribute.fromJson(x))),
    attributes: json["attributes"] == null ? null : List<Attribute>.from(json["attributes"].map((x) => Attribute.fromJson(x))),
    cardAuthInfo: json["cardAuthInfo"] == null ? null : CardAuthInfo.fromJson(json["cardAuthInfo"]),
    authDateTime: json["authDateTime"] == null ? null : json["authDateTime"],
    terminalId: json["terminalId"] == null ? null : json["terminalId"],
    authRefNum: json["authRefNum"] == null ? null : json["authRefNum"],
    paymentAmountInfo: json["paymentAmountInfo"] == null ? null : PaymentAmountInfo.fromJson(json["paymentAmountInfo"]),
    bankInfo: json["bankInfo"] == null ? null : BankInfo.fromJson(json["bankInfo"]),
  );

  Map<String, dynamic> toJson() => {
    "errorCode": errorCode == null ? null : errorCode,
    "orderNumber": orderNumber == null ? null : orderNumber,
    "orderStatus": orderStatus == null ? null : orderStatus,
    "actionCode": actionCode == null ? null : actionCode,
    "actionCodeDescription": actionCodeDescription == null ? null : actionCodeDescription,
    "amount": amount == null ? null : amount,
    "currency": currency == null ? null : currency,
    "date": date == null ? null : date,
    "ip": ip == null ? null : ip,
    "merchantOrderParams": merchantOrderParams == null ? null : List<dynamic>.from(merchantOrderParams.map((x) => x.toJson())),
    "attributes": attributes == null ? null : List<dynamic>.from(attributes.map((x) => x.toJson())),
    "cardAuthInfo": cardAuthInfo == null ? null : cardAuthInfo.toJson(),
    "authDateTime": authDateTime == null ? null : authDateTime,
    "terminalId": terminalId == null ? null : terminalId,
    "authRefNum": authRefNum == null ? null : authRefNum,
    "paymentAmountInfo": paymentAmountInfo == null ? null : paymentAmountInfo.toJson(),
    "bankInfo": bankInfo == null ? null : bankInfo.toJson(),
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

class BankInfo {
  BankInfo({
    this.bankCountryName,
  });

  final String bankCountryName;

  factory BankInfo.fromJson(Map<String, dynamic> json) => BankInfo(
    bankCountryName: json["bankCountryName"] == null ? null : json["bankCountryName"],
  );

  Map<String, dynamic> toJson() => {
    "bankCountryName": bankCountryName == null ? null : bankCountryName,
  };
}

class CardAuthInfo {
  CardAuthInfo({
    this.expiration,
    this.cardholderName,
    this.approvalCode,
    this.pan,
  });

  final String expiration;
  final String cardholderName;
  final String approvalCode;
  final String pan;

  factory CardAuthInfo.fromJson(Map<String, dynamic> json) => CardAuthInfo(
    expiration: json["expiration"] == null ? null : json["expiration"],
    cardholderName: json["cardholderName"] == null ? null : json["cardholderName"],
    approvalCode: json["approvalCode"] == null ? null : json["approvalCode"],
    pan: json["pan"] == null ? null : json["pan"],
  );

  Map<String, dynamic> toJson() => {
    "expiration": expiration == null ? null : expiration,
    "cardholderName": cardholderName == null ? null : cardholderName,
    "approvalCode": approvalCode == null ? null : approvalCode,
    "pan": pan == null ? null : pan,
  };
}

class PaymentAmountInfo {
  PaymentAmountInfo({
    this.paymentState,
    this.approvedAmount,
    this.depositedAmount,
    this.refundedAmount,
  });

  final String paymentState;
  final int approvedAmount;
  final int depositedAmount;
  final int refundedAmount;

  factory PaymentAmountInfo.fromJson(Map<String, dynamic> json) => PaymentAmountInfo(
    paymentState: json["paymentState"] == null ? null : json["paymentState"],
    approvedAmount: json["approvedAmount"] == null ? null : json["approvedAmount"],
    depositedAmount: json["depositedAmount"] == null ? null : json["depositedAmount"],
    refundedAmount: json["refundedAmount"] == null ? null : json["refundedAmount"],
  );

  Map<String, dynamic> toJson() => {
    "paymentState": paymentState == null ? null : paymentState,
    "approvedAmount": approvedAmount == null ? null : approvedAmount,
    "depositedAmount": depositedAmount == null ? null : depositedAmount,
    "refundedAmount": refundedAmount == null ? null : refundedAmount,
  };
}


class ApplePaymentError {
  ApplePaymentError({
    this.error,
    this.success,
  });

  final Error error;
  final bool success;

  factory ApplePaymentError.fromJson(Map<String, dynamic> json) => ApplePaymentError(
    error: json["error"] == null ? null : Error.fromJson(json["error"]),
    success: json["success"] == null ? null : json["success"],
  );

  Map<String, dynamic> toJson() => {
    "error": error == null ? null : error.toJson(),
    "success": success == null ? null : success,
  };
}

class Error {
  Error({
    this.code,
    this.description,
    this.message,
  });

  final int code;
  final String description;
  final String message;

  factory Error.fromJson(Map<String, dynamic> json) => Error(
    code: json["code"] == null ? null : json["code"],
    description: json["description"] == null ? null : json["description"],
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "code": code == null ? null : code,
    "description": description == null ? null : description,
    "message": message == null ? null : message,
  };
}
