import 'dart:convert';

import 'package:flutter_app/Screens/CartScreen/Model/CartModel.dart';

class FilteredStoresData{
  List<FilteredStores> filteredStoresList;

  FilteredStoresData( {
    this.filteredStoresList,
  });

  factory FilteredStoresData.fromJson(List<dynamic> parsedJson){
    List<FilteredStores> storesList = null;
    if(parsedJson != null){
      storesList = parsedJson.map((i) => FilteredStores.fromJson(i)).toList();
    }

    return FilteredStoresData(
        filteredStoresList:storesList,
    );
  }
}


class FilteredStores {
  FilteredStores({
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
    this.url,
    this.meta,
  });

  String uuid;
  String name;
  List<CategoriesUuid> storeCategoriesUuid;
  List<CategoriesUuid> productCategoriesUuid;
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
  String url;
  FilteredStoreMeta meta;

  factory FilteredStores.fromStoreData(StoreData store){

    List<CategoriesUuid> productCategoriesUuid = new List<CategoriesUuid>();
    if(store.productCategoriesUuid != null){
      store.productCategoriesUuid.forEach((element) {
        productCategoriesUuid.add(new CategoriesUuid(uuid: element));
      });
    }else{
      return null;
    }


    return new FilteredStores(
        name: store.name,
        uuid: store.uuid,
        address: store.address,
      productCategoriesUuid: productCategoriesUuid
    );
  }

  factory FilteredStores.fromJson(Map<String, dynamic> json) => FilteredStores(
    uuid: json["uuid"],
    name: json["name"],
    storeCategoriesUuid: (json["store_categories_uuid"] == null) ? null : List<CategoriesUuid>.from(json["store_categories_uuid"].map((x) => CategoriesUuid.fromJson(x))),
    productCategoriesUuid: (json["product_categories_uuid"] == null) ? null : List<CategoriesUuid>.from(json["product_categories_uuid"].map((x) => CategoriesUuid.fromJson(x))),
    paymentTypes: (json["payment_types"] == null) ? null : List<String>.from(json["payment_types"]),
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
    url: json["url"],
    meta: (json['meta'] == null) ? null : FilteredStoreMeta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "store_categories_uuid": List<dynamic>.from(storeCategoriesUuid.map((x) => x.toJson())),
    "product_categories_uuid": List<dynamic>.from(productCategoriesUuid.map((x) => x.toJson())),
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
    "url": url,
    "meta": meta.toJson(),
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
    this.category,
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
  double lat;
  double lon;
  String category;

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
    lat: json["lat"].toDouble(),
    lon: json["lon"].toDouble(),
    category: json["category"] == null ? null : json["category"],
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
    "category": category == null ? null : category,
  };
}

class FilteredStoreMeta {
  FilteredStoreMeta({
    this.images,
    this.rating,
    this.avgDeliveryTime,
    this.avgDeliveryPrice,
  });

  List<String> images;
  double rating;
  int avgDeliveryTime;
  int avgDeliveryPrice;

  factory FilteredStoreMeta.fromJson(Map<String, dynamic> json) => FilteredStoreMeta(
    images: (json["images"] == null) ? null : List<String>.from(json["images"].map((x) => x)),
    rating: json["rating"].toDouble(),
    avgDeliveryTime: json["avg_delivery_time"],
    avgDeliveryPrice: json["avg_delivery_price"],
  );

  Map<String, dynamic> toJson() => {
    "images":(images == null) ? null : List<dynamic>.from(images.map((x) => x)),
    "rating": rating,
    "avg_delivery_time": avgDeliveryTime,
    "avg_delivery_price": avgDeliveryPrice,
  };
}


class CategoriesUuid {
  CategoriesUuid({
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
  ProductCategoriesUuidMeta meta;

  factory CategoriesUuid.fromJson(Map<String, dynamic> json) => CategoriesUuid(
    uuid: json["uuid"],
    name: json["name"],
    priority: json["priority"],
    comment: json["comment"] == null ? null : json["comment"],
    url: json["url"],
    meta: ProductCategoriesUuidMeta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "priority": priority,
    "comment": comment == null ? null : comment,
    "url": url,
    "meta": meta.toJson(),
  };
}

class ProductCategoriesUuidMeta {
  ProductCategoriesUuidMeta();

  factory ProductCategoriesUuidMeta.fromJson(Map<String, dynamic> json) => ProductCategoriesUuidMeta(
  );

  Map<String, dynamic> toJson() => {
  };
}