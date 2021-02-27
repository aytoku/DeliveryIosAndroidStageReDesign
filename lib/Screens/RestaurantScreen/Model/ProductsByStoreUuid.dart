class ProductsByStoreUuidData{
  List<ProductsByStoreUuid> productsByStoreUuidList;

  ProductsByStoreUuidData( {
    this.productsByStoreUuidList,
  });

  factory ProductsByStoreUuidData.fromJson(List<dynamic> parsedJson){
    List<ProductsByStoreUuid> productsList = null;
    if(parsedJson != null){
      productsList = parsedJson.map((i) => ProductsByStoreUuid.fromJson(i)).toList();
    }

    return ProductsByStoreUuidData(
      productsByStoreUuidList:productsList,
    );
  }
}


class ProductsByStoreUuid {
  ProductsByStoreUuid({
    this.uuid,
    this.name,
    this.storeUuid,
    this.productCategories,
    this.comment,
    this.url,
    this.deleted,
    this.available,
    this.stopList,
    this.defaultSet,
    this.priority,
    this.openable,
    this.type,
    this.price,
    this.weight,
    this.weightMeasurement,
    this.meta,
    this.externalId,
    this.variantGroups,
  });

  String uuid;
  String name;
  String storeUuid;
  List<ProductCategory> productCategories;
  String comment;
  String url;
  bool deleted;
  bool available;
  bool stopList;
  bool defaultSet;
  int priority;
  bool openable;
  String type;
  double price;
  int weight;
  String weightMeasurement;
  ProductsByStoreUuidMeta meta;
  String externalId;
  dynamic variantGroups;

  factory ProductsByStoreUuid.fromJson(Map<String, dynamic> json) => ProductsByStoreUuid(
    uuid: json["uuid"],
    name: json["name"],
    storeUuid: json["store_uuid"],
    productCategories: List<ProductCategory>.from(json["product_categories"].map((x) => ProductCategory.fromJson(x))),
    comment: json["comment"],
    url: json["url"],
    deleted: json["deleted"],
    available: json["available"],
    stopList: json["stop_list"],
    defaultSet: json["default_set"],
    priority: json["priority"],
    openable: json["openable"],
    type: json["type"],
    price: json["price"] * 1.0,
    weight: json["weight"],
    weightMeasurement: json["weight_measurement"],
    meta: ProductsByStoreUuidMeta.fromJson(json["meta"]),
    externalId: json["external_id"],
    variantGroups: json["variant_groups"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "store_uuid": storeUuid,
    "product_categories": List<dynamic>.from(productCategories.map((x) => x.toJson())),
    "comment": comment,
    "url": url,
    "deleted": deleted,
    "available": available,
    "stop_list": stopList,
    "default_set": defaultSet,
    "priority": priority,
    "openable": openable,
    "type": type,
    "price": price,
    "weight": weight,
    "weight_measurement": weightMeasurement,
    "meta": meta.toJson(),
    "external_id": externalId,
    "variant_groups": variantGroups,
  };
}

class ProductsByStoreUuidMeta {
  ProductsByStoreUuidMeta({
    this.description,
    this.composition,
    this.weight,
    this.weightMeasurement,
    this.images,
    this.energyValue,
  });

  String description;
  String composition;
  int weight;
  String weightMeasurement;
  List<String> images;
  EnergyValue energyValue;

  factory ProductsByStoreUuidMeta.fromJson(Map<String, dynamic> json) => ProductsByStoreUuidMeta(
    description: json["description"],
    composition: json["composition"],
    weight: json["weight"],
    weightMeasurement: json["weight_measurement"],
    images: (json["images"] == null) ? null : List<String>.from(json["images"].map((x) => x)),
    energyValue: EnergyValue.fromJson(json["energy_value"]),
  );

  Map<String, dynamic> toJson() => {
    "description": description,
    "composition": composition,
    "weight": weight,
    "weight_measurement": weightMeasurement,
    "images": List<dynamic>.from(images.map((x) => x)),
    "energy_value": energyValue.toJson(),
  };
}

class EnergyValue {
  EnergyValue({
    this.protein,
    this.fat,
    this.carbohydrates,
    this.calories,
  });

  int protein;
  int fat;
  int carbohydrates;
  double calories;

  factory EnergyValue.fromJson(Map<String, dynamic> json) => EnergyValue(
    protein: json["protein"],
    fat: json["fat"],
    carbohydrates: json["carbohydrates"],
    calories: json["calories"]*1.0,
  );

  Map<String, dynamic> toJson() => {
    "protein": protein,
    "fat": fat,
    "carbohydrates": carbohydrates,
    "calories": calories,
  };
}

class ProductCategory {
  ProductCategory({
    this.uuid,
    this.name,
    this.priority,
    this.comment,
    this.url,
    this.meta,
  });

  String uuid;
  String name;
  int priority;
  String comment;
  String url;
  ProductCategoryMeta meta;

  factory ProductCategory.fromJson(Map<String, dynamic> json) => ProductCategory(
    uuid: json["uuid"],
    name: json["name"],
    priority: json["priority"],
    comment: json["comment"],
    url: json["url"],
    meta: ProductCategoryMeta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "priority": priority,
    "comment": comment,
    "url": url,
    "meta": meta.toJson(),
  };
}

class ProductCategoryMeta {
  ProductCategoryMeta();

  factory ProductCategoryMeta.fromJson(Map<String, dynamic> json) => ProductCategoryMeta(
  );

  Map<String, dynamic> toJson() => {
  };
}