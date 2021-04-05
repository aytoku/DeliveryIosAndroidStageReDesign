class DeliveryTariff {
  DeliveryTariff({
    this.price,
    this.estimatedTime
  });

  final double price;
  final int estimatedTime;

  factory DeliveryTariff.fromJson(Map<String, dynamic> json) => DeliveryTariff(
      price: json["price"] == null ? null : json["price"] * 1.0,
      estimatedTime: json["estimated_time"] == null ? null : json["estimated_time"]
  );

  Map<String, dynamic> toJson() => {
    "price": price == null ? null : price,
    "estimated_time": estimatedTime == null ? null : estimatedTime,
  };
}