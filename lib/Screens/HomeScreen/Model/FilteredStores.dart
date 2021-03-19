import 'dart:convert';

import 'package:flutter_app/Screens/CartScreen/Model/CartModel.dart';
import 'package:flutter_app/Screens/HomeScreen/Model/AllStoreCategories.dart';

class FilteredStoresData{
  static List<FilteredStores> filteredStoresCache;

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
  
  static Future<List<FilteredStores>> applyCategoryFilters(List<AllStoreCategories> filters) async{
    // если выбран хотя бы один из фильтров, то
    if(filters.length > 0){
      // получаем отфильтрованные рестораны
      var stores =filteredStoresCache.where((element) =>
      element.storeCategoriesUuid != null && element.storeCategoriesUuid.length > 0 &&
          filters.indexWhere((filter) => element.storeCategoriesUuid[0].uuid == filter.uuid) != -1);
      List<FilteredStores> filteredStores = new List<FilteredStores>();
      filteredStores.addAll(stores);
      return filteredStores;
    } else {
      // весь список
      return List.from(filteredStoresCache);
    }
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
    this.available,
    this.settings,
    this.open,
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
  Available available;
  String type;
  bool open;
  WorkSchedule workSchedule;
  Address address;
  List<Contact> contacts;
  int priority;
  int lat;
  int lon;
  String url;
  FilteredStoreMeta meta;
  Settings settings;

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
    available: json["available"] == null ? null : Available.fromJson(json["available"]),
    type: json["type"] == null ? null : json["type"],
    open: json["open"] == null ? null : json["open"],
    workSchedule: json["work_schedule"] == null ? null : WorkSchedule.fromJson(json["work_schedule"]),
    address: Address.fromJson(json["address"]),
    contacts: json["contacts"] == null ? null : List<Contact>.from(json["contacts"].map((x) => Contact.fromJson(x))),
    priority: json["priority"],
    lat: json["lat"],
    lon: json["lon"],
    url: json["url"],
    meta: (json['meta'] == null) ? null : FilteredStoreMeta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid == null ? null : uuid,
    "name": name == null ? null : name,
    "store_categories_uuid": storeCategoriesUuid == null ? null : List<dynamic>.from(storeCategoriesUuid.map((x) => x.toJson())),
    "product_categories_uuid": productCategoriesUuid == null ? null : List<dynamic>.from(productCategoriesUuid.map((x) => x.toJson())),
    "payment_types": paymentTypes == null ? null : List<dynamic>.from(paymentTypes.map((x) => x)),
    "city_uuid": cityUuid == null ? null : cityUuid,
    "legal_entity_uuid": legalEntityUuid == null ? null : legalEntityUuid,
    "parent_uuid": parentUuid == null ? null : parentUuid,
    "available": available == null ? null : available.toJson(),
    "type": type == null ? null : type,
    "open": open == null ? null : open,
    "work_schedule": workSchedule == null ? null : workSchedule.toJson(),
    "address": address == null ? null : address.toJson(),
    "contacts": contacts == null ? null : List<dynamic>.from(contacts.map((x) => x.toJson())),
    "lat": lat == null ? null : lat,
    "lon": lon == null ? null : lon,
    "url": url == null ? null : url,
    "meta": meta == null ? null : meta.toJson(),
    "settings": settings == null ? null : settings.toJson(),
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

class Available {
  Available({
    this.flag,
    this.reason,
    this.duration,
  });

  final bool flag;
  final String reason;
  final int duration;

  factory Available.fromJson(Map<String, dynamic> json) => Available(
    flag: json["flag"] == null ? null : json["flag"],
    reason: json["reason"] == null ? null : json["reason"],
    duration: json["duration"] == null ? null : json["duration"],
  );

  Map<String, dynamic> toJson() => {
    "flag": flag == null ? null : flag,
    "reason": reason == null ? null : reason,
    "duration": duration == null ? null : duration,
  };
}

class Contact {
  Contact();

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
  );

  Map<String, dynamic> toJson() => {
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
  String avgDeliveryTime;
  String avgDeliveryPrice;

  factory FilteredStoreMeta.fromJson(Map<String, dynamic> json) => FilteredStoreMeta(
    images: (json["images"] == null) ? null : List<String>.from(json["images"].map((x) => x)),
    rating: json["rating"].toDouble(),
    avgDeliveryTime: json["delivery_time"],
    avgDeliveryPrice: json["delivery_price"],
  );

  Map<String, dynamic> toJson() => {
    "images":(images == null) ? null : List<dynamic>.from(images.map((x) => x)),
    "rating": rating,
    "delivery_time": avgDeliveryTime,
    "delivery_price": avgDeliveryPrice,
  };
}

class Settings {
  Settings({
    this.confirmationTime,
  });

  final int confirmationTime;

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
    confirmationTime: json["confirmation_time"] == null ? null : json["confirmation_time"],
  );

  Map<String, dynamic> toJson() => {
    "confirmation_time": confirmationTime == null ? null : confirmationTime,
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

class WorkSchedule {
  WorkSchedule({
    this.timeZoneOffset,
    this.standard,
    this.holiday,
  });

  final int timeZoneOffset;
  final List<Standard> standard;
  final dynamic holiday;

  factory WorkSchedule.fromJson(Map<String, dynamic> json) => WorkSchedule(
    timeZoneOffset: json["time_zone_offset"] == null ? null : json["time_zone_offset"],
    standard: json["standard"] == null ? null : List<Standard>.from(json["standard"].map((x) => Standard.fromJson(x))),
    holiday: json["holiday"],
  );

  Map<String, dynamic> toJson() => {
    "time_zone_offset": timeZoneOffset == null ? null : timeZoneOffset,
    "standard": standard == null ? null : List<dynamic>.from(standard.map((x) => x.toJson())),
    "holiday": holiday,
  };
}

class Standard {
  Standard({
    this.beginningTime,
    this.endingTime,
    this.weekDays,
  });

  final String beginningTime;
  final String endingTime;
  final List<bool> weekDays;

  factory Standard.fromJson(Map<String, dynamic> json) => Standard(
    beginningTime: json["beginning_time"] == null ? null : json["beginning_time"],
    endingTime: json["ending_time"] == null ? null : json["ending_time"],
    weekDays: json["week_days"] == null ? null : List<bool>.from(json["week_days"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "beginning_time": beginningTime == null ? null : beginningTime,
    "ending_time": endingTime == null ? null : endingTime,
    "week_days": weekDays == null ? null : List<dynamic>.from(weekDays.map((x) => x)),
  };
}
