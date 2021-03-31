class ClientName {
  ClientName({
    this.uuid,
    this.name,
    this.application,
    this.mainPhone,
    this.devicesId,
    this.blocked,
    this.addresses,
    this.meta,
  });

  final String uuid;
  final String name;
  final String application;
  final String mainPhone;
  final List<String> devicesId;
  final bool blocked;
  final dynamic addresses;
  final Meta meta;

  factory ClientName.fromJson(Map<String, dynamic> json) => ClientName(
    uuid: json["uuid"] == null ? null : json["uuid"],
    name: json["name"] == null ? null : json["name"],
    application: json["application"] == null ? null : json["application"],
    mainPhone: json["main_phone"] == null ? null : json["main_phone"],
    devicesId: json["devices_id"] == null ? null : List<String>.from(json["devices_id"].map((x) => x)),
    blocked: json["blocked"] == null ? null : json["blocked"],
    addresses: json["addresses"],
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid == null ? null : uuid,
    "name": name == null ? null : name,
    "application": application == null ? null : application,
    "main_phone": mainPhone == null ? null : mainPhone,
    "devices_id": devicesId == null ? null : List<dynamic>.from(devicesId.map((x) => x)),
    "blocked": blocked == null ? null : blocked,
    "addresses": addresses,
    "meta": meta == null ? null : meta.toJson(),
  };
}

class Meta {
  Meta();

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
  );

  Map<String, dynamic> toJson() => {
  };
}
