class PaymentMethod {
  PaymentMethod({
    this.name,
    this.image,
    this.tag,
    this.outputTag
  });

  final String image;
  final String name;
  final String tag;
  final String outputTag;

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
    image: json["image"] == null ? null : json["image"],
    name: json["name"] == null ? null : json["name"],
    tag: json["tag"] == null ? null : json["tag"],
    outputTag: json["outputTag"] == null ? null : json["outputTag"]
  );

  Map<String, dynamic> toJson() => {
    "image": image == null ? null : image,
    "name": name == null ? null : name,
    "tag": tag == null ? null : tag,
    "outputTag": outputTag == null ? null : outputTag
  };
}