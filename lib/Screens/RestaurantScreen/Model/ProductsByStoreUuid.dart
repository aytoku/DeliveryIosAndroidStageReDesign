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
    this.comment,
    this.url,
    this.price,
    this.defaultSet,
    this.priority,
    this.type,
    this.weight,
    this.weightMeasurement,
    this.openable,
    this.meta,
    this.productCategories,
    this.variantGroups,
  });

  String uuid;
  String name;
  String storeUuid;
  String comment;
  String url;
  int price;
  bool defaultSet;
  int priority;
  String type;
  double weight;
  String weightMeasurement;
  bool openable;
  ProductsDataModelMeta meta;
  List<ProductCategory> productCategories;
  dynamic variantGroups;

  factory ProductsByStoreUuid.fromJson(Map<String, dynamic> json) => ProductsByStoreUuid(
    uuid: json["uuid"],
    name: json["name"],
    storeUuid: json["store_uuid"],
    comment: json["comment"],
    url: json["url"],
    price: json["price"],
    defaultSet: json["default_set"],
    priority: json["priority"],
    type: json["type"],
    weight: json["weight"] * 1.0,
    weightMeasurement: json["weight_measurement"],
    openable: json["openable"],
    meta: ProductsDataModelMeta.fromJson(json["meta"]),
    productCategories: List<ProductCategory>.from(json["product_categories"].map((x) => ProductCategory.fromJson(x))),
    variantGroups: json["variant_groups"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "store_uuid": storeUuid,
    "comment": comment,
    "url": url,
    "price": price,
    "default_set": defaultSet,
    "priority": priority,
    "type": type,
    "weight": weight,
    "weight_measurement": weightMeasurement,
    "openable": openable,
    "meta": meta.toJson(),
    "product_categories": List<dynamic>.from(productCategories.map((x) => x.toJson())),
    "variant_groups": variantGroups,
  };
}

class ProductsDataModelMeta {
  ProductsDataModelMeta({
    this.description,
    this.images,
    this.energyValue,
  });

  String description;
  List<String> images;
  EnergyValue energyValue;

  factory ProductsDataModelMeta.fromJson(Map<String, dynamic> json) => ProductsDataModelMeta(
    description: json["description"],
    images: List<String>.from(json["images"].map((x) => x)),
    energyValue: EnergyValue.fromJson(json["energy_value"]),
  );

  Map<String, dynamic> toJson() => {
    "description": description,
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
  int calories;

  factory EnergyValue.fromJson(Map<String, dynamic> json) => EnergyValue(
    protein: json["protein"],
    fat: json["fat"],
    carbohydrates: json["carbohydrates"],
    calories: json["calories"],
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
