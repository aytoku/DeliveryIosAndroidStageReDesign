import 'dart:convert';

import 'package:flutter_app/Screens/RestaurantScreen/Model/ProductDataModel.dart';

CartModel cartModelFromJson(String str) => CartModel.fromJson(json.decode(str));

String cartModelToJson(CartModel data) => json.encode(data.toJson());

class CartModel {
  CartModel({
    this.uuid,
    this.id,
    this.storeUuid,
    this.storeData,
    this.deviceId,
    this.clientUuid,
    this.clientData,
    this.source,
    this.state,
    this.callbackPhone,
    this.comment,
    this.cancellationReason,
    this.cancellationComment,
    this.items,
    this.paymentType,
    this.totalPrice,
    this.withoutDelivery,
    this.eatInStore,
    this.ownDelivery,
    this.deliveryType,
    this.deliveryPrice,
    this.deliveryAddress,
    this.cookingPromiseTime,
    this.createdAt,
  });

  String uuid;
  String id;
  String storeUuid;
  StoreData storeData;
  String deviceId;
  String clientUuid;
  ClientData clientData;
  String source;
  String state;
  String callbackPhone;
  String comment;
  String cancellationReason;
  String cancellationComment;
  List<Item> items;
  String paymentType;
  int totalPrice;
  bool withoutDelivery;
  bool eatInStore;
  bool ownDelivery;
  String deliveryType;
  int deliveryPrice;
  Address deliveryAddress;
  int cookingPromiseTime;
  DateTime createdAt;

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
    uuid: json["uuid"],
    id: json["id"],
    storeUuid: json["store_uuid"],
    storeData: StoreData.fromJson(json["store_data"]),
    deviceId: json["device_id"],
    clientUuid: json["client_uuid"],
    clientData: ClientData.fromJson(json["client_data"]),
    source: json["source"],
    state: json["state"],
    callbackPhone: json["callback_phone"],
    comment: json["comment"],
    cancellationReason: json["cancellation_reason"],
    cancellationComment: json["cancellation_comment"],
    items: (json["items"] == null) ? null : List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
    paymentType: json["payment_type"],
    totalPrice: json["total_price"],
    withoutDelivery: json["without_delivery"],
    eatInStore: json["eat_in_store"],
    ownDelivery: json["own_delivery"],
    deliveryType: json["delivery_type"],
    deliveryPrice: json["delivery_price"],
    deliveryAddress: Address.fromJson(json["delivery_address"]),
    cookingPromiseTime: json["cooking_promise_time"],
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "id": id,
    "store_uuid": storeUuid,
    "store_data": storeData.toJson(),
    "device_id": deviceId,
    "client_uuid": clientUuid,
    "client_data": clientData.toJson(),
    "source": source,
    "state": state,
    "callback_phone": callbackPhone,
    "comment": comment,
    "cancellation_reason": cancellationReason,
    "cancellation_comment": cancellationComment,
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
    "payment_type": paymentType,
    "total_price": totalPrice,
    "without_delivery": withoutDelivery,
    "eat_in_store": eatInStore,
    "own_delivery": ownDelivery,
    "delivery_type": deliveryType,
    "delivery_price": deliveryPrice,
    "delivery_address": deliveryAddress.toJson(),
    "cooking_promise_time": cookingPromiseTime,
    "created_at": createdAt.toIso8601String(),
  };
}

class ClientData {
  ClientData({
    this.uuid,
    this.name,
    this.comment,
    this.mainPhone,
    this.blocked,
    this.meta,
  });

  String uuid;
  String name;
  String comment;
  String mainPhone;
  bool blocked;
  ClientDataMeta meta;

  factory ClientData.fromJson(Map<String, dynamic> json) => ClientData(
    uuid: json["uuid"],
    name: json["name"],
    comment: json["comment"],
    mainPhone: json["main_phone"],
    blocked: json["blocked"],
    meta: ClientDataMeta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "comment": comment,
    "main_phone": mainPhone,
    "blocked": blocked,
    "meta": meta.toJson(),
  };
}

class ClientDataMeta {
  ClientDataMeta();

  factory ClientDataMeta.fromJson(Map<String, dynamic> json) => ClientDataMeta(
  );

  Map<String, dynamic> toJson() => {
  };
}

class Address {
  Address({
    this.uuid,
    this.pointType,
    this.unrestrictedValue,
    this.value,
    this.country,
    this.region,
    this.regionType,
    this.type,
    this.city,
    this.cityType,
    this.street,
    this.streetType,
    this.streetWithType,
    this.house,
    this.frontDoor,
    this.comment,
    this.outOfTown,
    this.houseType,
    this.accuracyLevel,
    this.radius,
    this.lat,
    this.lon,
  });

  String uuid;
  String pointType;
  String unrestrictedValue;
  String value;
  String country;
  String region;
  String regionType;
  String type;
  String city;
  String cityType;
  String street;
  String streetType;
  String streetWithType;
  String house;
  int frontDoor;
  String comment;
  bool outOfTown;
  String houseType;
  int accuracyLevel;
  int radius;
  int lat;
  int lon;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    uuid: json["uuid"],
    pointType: json["point_type"],
    unrestrictedValue: json["unrestricted_value"],
    value: json["value"],
    country: json["country"],
    region: json["region"],
    regionType: json["region_type"],
    type: json["type"],
    city: json["city"],
    cityType: json["city_type"],
    street: json["street"],
    streetType: json["street_type"],
    streetWithType: json["street_with_type"],
    house: json["house"],
    frontDoor: json["front_door"],
    comment: json["comment"],
    outOfTown: json["out_of_town"],
    houseType: json["house_type"],
    accuracyLevel: json["accuracy_level"],
    radius: json["radius"],
    lat: json["lat"],
    lon: json["lon"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "point_type": pointType,
    "unrestricted_value": unrestrictedValue,
    "value": value,
    "country": country,
    "region": region,
    "region_type": regionType,
    "type": type,
    "city": city,
    "city_type": cityType,
    "street": street,
    "street_type": streetType,
    "street_with_type": streetWithType,
    "house": house,
    "front_door": frontDoor,
    "comment": comment,
    "out_of_town": outOfTown,
    "house_type": houseType,
    "accuracy_level": accuracyLevel,
    "radius": radius,
    "lat": lat,
    "lon": lon,
  };
}

class Item {
  Item({
    this.id,
    this.product,
    this.variantGroups,
    this.count,
  });

  int id;
  Product product;
  List<VariantGroup> variantGroups;
  int count;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    product: Product.fromJson(json["product"]),
    variantGroups: (json["variant_groups"] == null) ? null : List<VariantGroup>.from(json["variant_groups"].map((x) => VariantGroup.fromJson(x))),
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product": product.toJson(),
    "variant_groups": List<dynamic>.from(variantGroups.map((x) => x.toJson())),
    "count": count,
  };
}

class Product {
  Product({
    this.uuid,
    this.name,
    this.storeUuid,
    this.meta,
    this.productCategories,
  });

  String uuid;
  String name;
  String storeUuid;
  ProductMeta meta;
  List<ProductCategory> productCategories;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    uuid: json["uuid"],
    name: json["name"],
    storeUuid: json["store_uuid"],
    meta: ProductMeta.fromJson(json["meta"]),
    productCategories: (json["product_categories"] == null) ? null : List<ProductCategory>.from(json["product_categories"].map((x) => ProductCategory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "store_uuid": storeUuid,
    "meta": meta.toJson(),
    "product_categories": List<dynamic>.from(productCategories.map((x) => x.toJson())),
  };
}

class ProductMeta {
  ProductMeta({
    this.description,
    this.images,
    this.energyValue,
  });

  String description;
  List<String> images;
  EnergyValue energyValue;

  factory ProductMeta.fromJson(Map<String, dynamic> json) => ProductMeta(
    description: json["description"],
    images: (json["images"] == null) ? null : List<String>.from(json["images"].map((x) => x)),
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
  ClientDataMeta meta;

  factory ProductCategory.fromJson(Map<String, dynamic> json) => ProductCategory(
    uuid: json["uuid"],
    name: json["name"],
    priority: json["priority"],
    comment: json["comment"],
    url: json["url"],
    meta: ClientDataMeta.fromJson(json["meta"]),
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


class StoreData {
  StoreData({
    this.uuid,
    this.name,
    this.storeCategoriesUuid,
    this.productCategoriesUuid,
    this.paymentTypes,
    this.cityUuid,
    this.legalEntityUuid,
    this.parentUuid,
    this.type,
    this.workSchedule,
    this.address,
    this.contacts,
    this.priority,
    this.lat,
    this.lon,
    this.ownDelivery,
    this.url,
    this.meta,
  });

  String uuid;
  String name;
  List<String> storeCategoriesUuid;
  List<String> productCategoriesUuid;
  List<String> paymentTypes;
  String cityUuid;
  String legalEntityUuid;
  String parentUuid;
  String type;
  dynamic workSchedule;
  Address address;
  dynamic contacts;
  int priority;
  int lat;
  int lon;
  bool ownDelivery;
  String url;
  StoreDataMeta meta;

  factory StoreData.fromJson(Map<String, dynamic> json) => StoreData(
    uuid: json["uuid"],
    name: json["name"],
    storeCategoriesUuid: (json["store_categories_uuid"] == null) ? null : List<String>.from(json["store_categories_uuid"].map((x) => x)),
    productCategoriesUuid: (json["product_categories_uuid"] == null) ? null : List<String>.from(json["product_categories_uuid"].map((x) => x)),
    paymentTypes: (json["payment_types"] == null) ? null : List<String>.from(json["payment_types"].map((x) => x)),
    cityUuid: json["city_uuid"],
    legalEntityUuid: json["legal_entity_uuid"],
    parentUuid: json["parent_uuid"],
    type: json["type"],
    workSchedule: json["work_schedule"],
    address: Address.fromJson(json["address"]),
    contacts: json["contacts"],
    priority: json["priority"],
    lat: json["lat"],
    lon: json["lon"],
    ownDelivery: json["own_delivery"],
    url: json["url"],
    meta: StoreDataMeta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "store_categories_uuid": List<dynamic>.from(storeCategoriesUuid.map((x) => x)),
    "product_categories_uuid": List<dynamic>.from(productCategoriesUuid.map((x) => x)),
    "payment_types": List<dynamic>.from(paymentTypes.map((x) => x)),
    "city_uuid": cityUuid,
    "legal_entity_uuid": legalEntityUuid,
    "parent_uuid": parentUuid,
    "type": type,
    "work_schedule": workSchedule,
    "address": address.toJson(),
    "contacts": contacts,
    "priority": priority,
    "lat": lat,
    "lon": lon,
    "own_delivery": ownDelivery,
    "url": url,
    "meta": meta.toJson(),
  };
}

class StoreDataMeta {
  StoreDataMeta({
    this.images,
    this.rating,
    this.avgDeliveryTime,
    this.avgDeliveryPrice,
  });

  List<String> images;
  double rating;
  int avgDeliveryTime;
  int avgDeliveryPrice;

  factory StoreDataMeta.fromJson(Map<String, dynamic> json) => StoreDataMeta(
    images: (json["images"] == null) ? null : List<String>.from(json["images"].map((x) => x)),
    rating: json["rating"].toDouble(),
    avgDeliveryTime: json["avg_delivery_time"],
    avgDeliveryPrice: json["avg_delivery_price"],
  );

  Map<String, dynamic> toJson() => {
    "images": List<dynamic>.from(images.map((x) => x)),
    "rating": rating,
    "avg_delivery_time": avgDeliveryTime,
    "avg_delivery_price": avgDeliveryPrice,
  };
}