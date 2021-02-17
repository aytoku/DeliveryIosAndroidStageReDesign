import 'dart:convert';

ProductsDataModel productsDataModelFromJson(String str) => ProductsDataModel.fromJson(json.decode(str));

String productsDataModelToJson(ProductsDataModel data) => json.encode(data.toJson());

class ProductsDataModel {
  ProductsDataModel({
    this.uuid,
    this.name,
    this.storeUuid,
    this.comment,
    this.url,
    this.weight_measurement,
    this.weight,
    this.type,
    this.price,
    this.defaultSet,
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
  String weight_measurement;
  bool openable;
  ProductsDataModelMeta meta;
  List<ProductCategory> productCategories;
  List<VariantGroup> variantGroups;

  factory ProductsDataModel.fromJson(Map<String, dynamic> json) => ProductsDataModel(
    uuid: json["uuid"],
    name: json["name"],
    storeUuid: json["store_uuid"],
    type: json["type"],
    weight: json["weight"] * 1.0,
    weight_measurement: json["weight_measurement"],
    comment: json["comment"],
    url: json["url"],
    price: json["price"],
    defaultSet: json["default_set"],
    meta: ProductsDataModelMeta.fromJson(json["meta"]),
    productCategories: List<ProductCategory>.from(json["product_categories"].map((x) => ProductCategory.fromJson(x))),
    variantGroups: List<VariantGroup>.from(json["variant_groups"].map((x) => VariantGroup.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "store_uuid": storeUuid,
    "comment": comment,
    "type": type,
    "url": url,
    "weight": weight,
    "weight_measurement": weight_measurement,
    "price": price,
    "default_set": defaultSet,
    "meta": meta.toJson(),
    "product_categories": List<dynamic>.from(productCategories.map((x) => x.toJson())),
    "variant_groups": List<dynamic>.from(variantGroups.map((x) => x.toJson())),
  };

  Map<String, dynamic> toServerJson(int count){

    // Map<String, dynamic> request = {
    //   "source": "mod",
    //   "item":{
    //     "product": {
    //       "uuid": uuid,
    //       "name": name,
    //       "type": type,
    //       "price": price,
    //       "store_uuid": storeUuid,
    //       "meta": meta.toJson(),
    //       "product_categories": List<dynamic>.from(productCategories.map((x) => x.toJson())),
    //     },
    //     "count": count
    //   }
    // };
    Map<String, dynamic> request = {
      "source": "mod",
      "item": {
        "product_uuid": "4bee9b65-f641-4363-823f-18fe6a01a8d9",
        "variant_groups": [
          {
            "variant_group_uuid": "5038f805-e717-4a47-a8b1-66d4cc2d6f9d",
            "variants_uuid": [
              "0303c064-0d27-4253-85ee-b603f14d00f1"
            ]
          },
          {
            "variant_group_uuid": "cbb48e54-7a3a-4c15-b074-bdaf92443eca",
            "variants_uuid": [
              "5247d31d-2a5c-4270-91c9-451742ecea8e"
            ]
          },
          {
            "variant_group_uuid": "6569fa1b-d1df-4895-8288-066edb7c1603",
            "variants_uuid": [
              "71c9994c-b448-41bb-91fa-a4a998fe4f29",
              "cac55e84-cee3-4b22-a535-fc64726552f5"
            ]
          }
        ],
        "count": 1
      }
    };
    // if(type.toLowerCase() != "single")
    //  request["item"]["variant_groups"] = List<dynamic>.from(variantGroups.map((x) => x.toJson()));

    return request;
  }
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
    images: json["images"] == null ? null : List<String>.from(json["images"].map((x) => x)),
    energyValue: EnergyValue.fromJson(json["energy_value"]),
  );

  Map<String, dynamic> toJson() => {
    "description": description,
    "images": images == null ? null : List<dynamic>.from(images.map((x) => x)),
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

  factory EnergyValue.fromJson(Map<String, dynamic> json){
    if(json == null){
      return EnergyValue(
        protein: 0,
        fat: 0,
        carbohydrates: 0,
        calories: 0,
      );
    }
    return EnergyValue(
      protein: json["protein"],
      fat: json["fat"],
      carbohydrates: json["carbohydrates"],
      calories: json["calories"],
    );
  }

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

class VariantGroup {
  VariantGroup({
    this.uuid,
    this.name,
    this.productUuid,
    this.required,
    this.multiselect,
    this.description,
    this.meta,
    this.variants,
  });

  String uuid;
  String name;
  String productUuid;
  bool required;
  bool multiselect;
  String description;
  ProductCategoryMeta meta;
  List<Variant> variants;

  factory VariantGroup.fromJson(Map<String, dynamic> json) => VariantGroup(
    uuid: json["uuid"],
    name: json["name"],
    productUuid: json["product_uuid"],
    required: json["required"],
    multiselect: json["multiselect"],
    description: json["description"],
    meta: ProductCategoryMeta.fromJson(json["meta"]),
    variants: List<Variant>.from(json["variants"].map((x) => Variant.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "product_uuid": productUuid,
    "required": required,
    "multiselect": multiselect,
    "description": description,
    "meta": meta.toJson(),
    "variants": List<dynamic>.from(variants.map((x) => x.toJson())),
  };
}

class Variant {
  Variant({
    this.uuid,
    this.name,
    this.productUuid,
    this.variantGroupUuid,
    this.price,
    this.description,
    this.variantDefault,
    this.meta,
  });

  String uuid;
  String name;
  String productUuid;
  String variantGroupUuid;
  int price;
  String description;
  bool variantDefault;
  ProductsDataModelMeta meta;

  factory Variant.fromJson(Map<String, dynamic> json) => Variant(
    uuid: json["uuid"],
    name: json["name"],
    productUuid: json["product_uuid"],
    variantGroupUuid: json["variant_group_uuid"],
    price: json["price"],
    description: json["description"],
    variantDefault: json["default"],
    meta: ProductsDataModelMeta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "product_uuid": productUuid,
    "variant_group_uuid": variantGroupUuid,
    "price": price,
    "description": description,
    "default": variantDefault,
    "meta": meta.toJson(),
  };
}
