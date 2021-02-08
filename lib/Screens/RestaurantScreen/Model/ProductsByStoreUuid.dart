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

  final String uuid;
  final String name;
  final String storeUuid;
  final String comment;
  final String url;
  final int price;
  final bool defaultSet;
  final int priority;
  final String type;
  final int weight;
  final String weightMeasurement;
  final bool openable;
  final ProductsByStoreUuidMeta meta;
  final List<ProductCategory> productCategories;
  final dynamic variantGroups;

  factory ProductsByStoreUuid.fromJson(Map<String, dynamic> json) => ProductsByStoreUuid(
    uuid: json["uuid"] == null ? null : json["uuid"],
    name: json["name"] == null ? null : json["name"],
    storeUuid: json["store_uuid"] == null ? null : json["store_uuid"],
    comment: json["comment"] == null ? null : json["comment"],
    url: json["url"] == null ? null : json["url"],
    price: json["price"] == null ? null : json["price"],
    defaultSet: json["default_set"] == null ? null : json["default_set"],
    priority: json["priority"] == null ? null : json["priority"],
    type: json["type"] == null ? null : json["type"],
    weight: json["weight"] == null ? null : json["weight"],
    weightMeasurement: json["weight_measurement"] == null ? null : json["weight_measurement"],
    openable: json["openable"] == null ? null : json["openable"],
    meta: json["meta"] == null ? null : ProductsByStoreUuidMeta.fromJson(json["meta"]),
    productCategories: json["product_categories"] == null ? null : List<ProductCategory>.from(json["product_categories"].map((x) => ProductCategory.fromJson(x))),
    variantGroups: json["variant_groups"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid == null ? null : uuid,
    "name": name == null ? null : name,
    "store_uuid": storeUuid == null ? null : storeUuid,
    "comment": comment == null ? null : comment,
    "url": url == null ? null : url,
    "price": price == null ? null : price,
    "default_set": defaultSet == null ? null : defaultSet,
    "priority": priority == null ? null : priority,
    "type": type == null ? null : type,
    "weight": weight == null ? null : weight,
    "weight_measurement": weightMeasurement == null ? null : weightMeasurement,
    "openable": openable == null ? null : openable,
    "meta": meta == null ? null : meta.toJson(),
    "product_categories": productCategories == null ? null : List<dynamic>.from(productCategories.map((x) => x.toJson())),
    "variant_groups": variantGroups,
  };
}

class ProductsByStoreUuidMeta {
  ProductsByStoreUuidMeta({
    this.description,
    this.images,
    this.energyValue,
  });

  final String description;
  final List<String> images;
  final EnergyValue energyValue;

  factory ProductsByStoreUuidMeta.fromJson(Map<String, dynamic> json) => ProductsByStoreUuidMeta(
    description: json["description"] == null ? null : json["description"],
    images: json["images"] == null ? null : List<String>.from(json["images"].map((x) => x)),
    energyValue: json["energy_value"] == null ? null : EnergyValue.fromJson(json["energy_value"]),
  );

  Map<String, dynamic> toJson() => {
    "description": description == null ? null : description,
    "images": images == null ? null : List<dynamic>.from(images.map((x) => x)),
    "energy_value": energyValue == null ? null : energyValue.toJson(),
  };
}

class EnergyValue {
  EnergyValue({
    this.protein,
    this.fat,
    this.carbohydrates,
    this.calories,
  });

  final int protein;
  final int fat;
  final int carbohydrates;
  final int calories;

  factory EnergyValue.fromJson(Map<String, dynamic> json) => EnergyValue(
    protein: json["protein"] == null ? null : json["protein"],
    fat: json["fat"] == null ? null : json["fat"],
    carbohydrates: json["carbohydrates"] == null ? null : json["carbohydrates"],
    calories: json["calories"] == null ? null : json["calories"],
  );

  Map<String, dynamic> toJson() => {
    "protein": protein == null ? null : protein,
    "fat": fat == null ? null : fat,
    "carbohydrates": carbohydrates == null ? null : carbohydrates,
    "calories": calories == null ? null : calories,
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

  final String uuid;
  final String name;
  final int priority;
  final String comment;
  final String url;
  final ProductCategoryMeta meta;

  factory ProductCategory.fromJson(Map<String, dynamic> json) => ProductCategory(
    uuid: json["uuid"] == null ? null : json["uuid"],
    name: json["name"] == null ? null : json["name"],
    priority: json["priority"] == null ? null : json["priority"],
    comment: json["comment"] == null ? null : json["comment"],
    url: json["url"] == null ? null : json["url"],
    meta: json["meta"] == null ? null : ProductCategoryMeta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid == null ? null : uuid,
    "name": name == null ? null : name,
    "priority": priority == null ? null : priority,
    "comment": comment == null ? null : comment,
    "url": url == null ? null : url,
    "meta": meta == null ? null : meta.toJson(),
  };
}

class ProductCategoryMeta {
  ProductCategoryMeta();

  factory ProductCategoryMeta.fromJson(Map<String, dynamic> json) => ProductCategoryMeta(
  );

  Map<String, dynamic> toJson() => {
  };
}

