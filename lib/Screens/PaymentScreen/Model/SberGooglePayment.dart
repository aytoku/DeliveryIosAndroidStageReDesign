class SberGooglePayment {
  SberGooglePayment({
    this.success,
    this.data,
    this.error
  });

  bool success;
  Data data;
  Error error;

  factory SberGooglePayment.fromJson(Map<String, dynamic> json) => SberGooglePayment(
    success: json["success"],
    data: json["data"] != null ? Data.fromJson(json["data"]) : null,
    error: json["error"] != null ? Error.fromJson(json["error"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data != null ? data.toJson() : null,
    "error": error != null ? error.toJson() : null,
  };
}

class Data {
  Data({
    this.orderId,
    this.acsUrl,
    this.paReq,
    this.termUrl,
    this.MD
  });

  String orderId;
  String acsUrl;
  String paReq;
  String termUrl;
  String MD;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    orderId: json["orderId"],
    acsUrl: json.containsKey("acsUrl") ? json["acsUrl"] : null,
    paReq: json.containsKey("paReq") ? json["paReq"] : null,
    termUrl: json.containsKey("termUrl") ? json["termUrl"]: null,
    MD: json.containsKey("MD") ? json["MD"] : null,
  );

  Map<String, dynamic> toJson() => {
    "orderId": orderId,
    "paReq": paReq,
    "acsUrl": acsUrl,
    "termUrl": termUrl,
    "MD": MD,
  };
}

class Error {
  Error({
    this.code,
    this.description,
    this.message,
  });

  String code;
  String description;
  String message;

  factory Error.fromJson(Map<String, dynamic> json) => Error(
    code: json["code"],
    description: json["description"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "description": description,
    "message": message,
  };
}
