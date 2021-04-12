import 'dart:convert';

import 'package:flutter_app/Screens/CartScreen/Model/CartModel.dart';
import 'package:flutter_app/Screens/HomeScreen/Model/FilteredStores.dart';

List<OrderDetailsModelItem> orderDetailsModelFromJson(String str) => List<OrderDetailsModelItem>.from(json.decode(str).map((x) => OrderDetailsModelItem.fromJson(x)));

String orderDetailsModelToJson(List<OrderDetailsModelItem> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderDetailsModel{
  List<OrderDetailsModelItem> orderDetailsModelItem;

  OrderDetailsModel( {
    this.orderDetailsModelItem,
  });

  factory OrderDetailsModel.fromJson(List<dynamic> parsedJson){
    List<OrderDetailsModelItem> storesList = null;
    if(parsedJson != null){
      storesList = parsedJson.map((i) => OrderDetailsModelItem.fromJson(i)).toList();
    }

    return OrderDetailsModel(
      orderDetailsModelItem:storesList,
    );
  }
}


class OrderDetailsModelItem {
  OrderDetailsModelItem({
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
    this.items,
    this.paymentType,
    this.totalPrice,
    this.ownDelivery,
    this.withoutDelivery,
    this.eatInStore,
    this.deliveryType,
    this.deliveryPrice,
    this.deliveryTariff,
    this.deliveryAddress,
    this.cookingTime,
    this.cookingTimeFinish,
    this.lastUpdateUuid,
    this.lastUpdateRole,
    this.cancelReason,
    this.cancelComment,
    this.createdAt,
    this.promotion
  });

  String uuid;
  String id;
  String storeUuid;
  StoreData storeData;
  String deviceId;
  String clientUuid;
  ClientData clientData;
  DeliveryTariff deliveryTariff;
  String source;
  String state;
  String callbackPhone;
  String comment;
  List<Item> items;
  String paymentType;
  double totalPrice;
  bool ownDelivery;
  bool withoutDelivery;
  bool eatInStore;
  String deliveryType;
  int deliveryPrice;
  Address deliveryAddress;
  int cookingTime;
  DateTime cookingTimeFinish;
  String lastUpdateUuid;
  String lastUpdateRole;
  String cancelReason;
  String cancelComment;
  DateTime createdAt;
  Promotion promotion;

  factory OrderDetailsModelItem.fromJson(Map<String, dynamic> json) => OrderDetailsModelItem(
    uuid: json["uuid"],
    id: json["id"],
    storeUuid: json["store_uuid"],
    storeData: StoreData.fromJson(json["store_data"]),
    deviceId: json["device_id"],
    clientUuid: json["client_uuid"],
    clientData: ClientData.fromJson(json["client_data"]),
    deliveryTariff: json["delivery_tariff"] == null ? null : DeliveryTariff.fromJson(json["delivery_tariff"]),
    source: json["source"],
    state: json["state"],
    callbackPhone: json["callback_phone"],
    comment: json["comment"],
    items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
    paymentType: json["payment_type"],
    totalPrice: json["total_price"] * 1.0,
    ownDelivery: json["own_delivery"],
    withoutDelivery: json["without_delivery"],
    eatInStore: json["eat_in_store"],
    deliveryType: json["delivery_type"],
    deliveryPrice: json["delivery_price"],
    deliveryAddress: Address.fromJson(json["delivery_address"]),
    cookingTime: json["cooking_time"],
    cookingTimeFinish: DateTime.parse(json["cooking_time_finish"]),
    lastUpdateUuid: json["last_update_uuid"],
    lastUpdateRole: json["last_update_role"],
    cancelReason: json["cancel_reason"],
    cancelComment: json["cancel_comment"],
    createdAt: DateTime.parse(json["created_at"]),
    promotion: json["promotion"] == null ? null : Promotion.fromJson(json["promotion"]),
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
    "delivery_tariff": deliveryTariff == null ? null : deliveryTariff.toJson(),
    "callback_phone": callbackPhone,
    "comment": comment,
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
    "payment_type": paymentType,
    "total_price": totalPrice,
    "own_delivery": ownDelivery,
    "without_delivery": withoutDelivery,
    "eat_in_store": eatInStore,
    "delivery_type": deliveryType,
    "delivery_price": deliveryPrice,
    "delivery_address": deliveryAddress.toJson(),
    "cooking_time": cookingTime,
    "cooking_time_finish": cookingTimeFinish.toIso8601String(),
    "last_update_uuid": lastUpdateUuid,
    "last_update_role": lastUpdateRole,
    "cancel_reason": cancelReason,
    "cancel_comment": cancelComment,
    "created_at": createdAt.toIso8601String(),
    "promotion": promotion == null ? null : promotion.toJson(),
  };
}

class ClientData {
  ClientData({
    this.uuid,
    this.name,
    this.comment,
    this.mainPhone,
    this.devices,
    this.blocked,
    this.addresses,
    this.meta,
  });

  String uuid;
  String name;
  String comment;
  String mainPhone;
  dynamic devices;
  bool blocked;
  dynamic addresses;
  ClientDataMeta meta;

  factory ClientData.fromJson(Map<String, dynamic> json) => ClientData(
    uuid: json["uuid"],
    name: json["name"],
    comment: json["comment"],
    mainPhone: json["main_phone"],
    devices: json["devices"],
    blocked: json["blocked"],
    addresses: json["addresses"],
    meta: ClientDataMeta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "comment": comment,
    "main_phone": mainPhone,
    "devices": devices,
    "blocked": blocked,
    "addresses": addresses,
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
  double lat;
  double lon;

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

class Product {
  Product({
    this.uuid,
    this.name,
    this.storeUuid,
    this.type,
    this.price,
    this.weight,
    this.weightMeasurement,
    this.meta,
  });

  String uuid;
  String name;
  String storeUuid;
  String type;
  int price;
  int weight;
  String weightMeasurement;
  ProductMeta meta;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    uuid: json["uuid"],
    name: json["name"],
    storeUuid: json["store_uuid"],
    type: json["type"],
    price: json["price"],
    weight: json["weight"],
    weightMeasurement: json["weight_measurement"],
    meta: ProductMeta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "store_uuid": storeUuid,
    "type": type,
    "price": price,
    "weight": weight,
    "weight_measurement": weightMeasurement,
    "meta": meta.toJson(),
  };
}

class ProductMeta {
  ProductMeta({
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

  factory ProductMeta.fromJson(Map<String, dynamic> json) => ProductMeta(
    description: json["description"],
    composition: json["composition"],
    weight: json["weight"],
    weightMeasurement: json["weight_measurement"],
    images: List<String>.from(json["images"].map((x) => x)),
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

class StoreData {
  StoreData({
    this.uuid,
    this.name,
    this.paymentTypes,
    this.cityUuid,
    this.legalEntityUuid,
    this.parentUuid,
    this.available,
    this.type,
    this.workSchedule,
    this.holidayWorkSchedule,
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
  List<String> paymentTypes;
  String cityUuid;
  String legalEntityUuid;
  String parentUuid;
  Available available;
  String type;
  WorkSchedule workSchedule;
  dynamic holidayWorkSchedule;
  Address address;
  dynamic contacts;
  int priority;
  int lat;
  int lon;
  bool ownDelivery;
  String url;
  StoreDataMeta meta;

  factory StoreData.fromJson(Map<String, dynamic> json){
    if(json == null){
      return null;
    }
    return StoreData(
      uuid: json["uuid"],
      name: json["name"],
      paymentTypes: List<String>.from(json["payment_types"].map((x) => x)),
      cityUuid: json["city_uuid"],
      legalEntityUuid: json["legal_entity_uuid"],
      parentUuid: json["parent_uuid"],
      available: Available.fromJson(json["available"]),
      type: json["type"],
      workSchedule: json["work_schedule"] == null ? null : WorkSchedule.fromJson(json["work_schedule"]),
      holidayWorkSchedule: json["holiday_work_schedule"],
      address: Address.fromJson(json["address"]),
      contacts: json["contacts"],
      priority: json["priority"],
      lat: json["lat"],
      lon: json["lon"],
      ownDelivery: json["own_delivery"],
      url: json["url"],
      meta: StoreDataMeta.fromJson(json["meta"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "payment_types": List<dynamic>.from(paymentTypes.map((x) => x)),
    "city_uuid": cityUuid,
    "legal_entity_uuid": legalEntityUuid,
    "parent_uuid": parentUuid,
    "available": available.toJson(),
    "type": type,
    "work_schedule": workSchedule,
    "holiday_work_schedule": holidayWorkSchedule,
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

class Available {
  Available({
    this.flag,
    this.reason,
    this.duration,
  });

  bool flag;
  String reason;
  int duration;

  factory Available.fromJson(Map<String, dynamic> json) => Available(
    flag: json["flag"],
    reason: json["reason"],
    duration: json["duration"],
  );

  Map<String, dynamic> toJson() => {
    "flag": flag,
    "reason": reason,
    "duration": duration,
  };
}

class StoreDataMeta {
  StoreDataMeta({
    this.images,
    this.rating,
    this.avgDeliveryTime,
    this.avgDeliveryPrice,
    this.confirmationTime
  });

  final List<String> images;
  final double rating;
  final int avgDeliveryTime;
  final int avgDeliveryPrice;
  final int confirmationTime;

  factory StoreDataMeta.fromJson(Map<String, dynamic> json) => StoreDataMeta(
      images: json["images"] == null ? null : List<String>.from(json["images"].map((x) => x)),
      rating: json["rating"] == null ? null : json["rating"].toDouble(),
      avgDeliveryTime: json["avg_delivery_time"] == null ? null : json["avg_delivery_time"],
      avgDeliveryPrice: json["avg_delivery_price"] == null ? null : json["avg_delivery_price"],
      confirmationTime: json["confirmation_time"] == null ? null : json["confirmation_time"]
  );

  Map<String, dynamic> toJson() => {
    "images": images == null ? null : List<dynamic>.from(images.map((x) => x)),
    "rating": rating == null ? null : rating,
    "avg_delivery_time": avgDeliveryTime == null ? null : avgDeliveryTime,
    "avg_delivery_price": avgDeliveryPrice == null ? null : avgDeliveryPrice,
    "confirmation_time": confirmationTime == null ? null : confirmationTime,
  };
}

class DeliveryAddressDetails {
  DeliveryAddressDetails({
    this.entrance,
    this.floor,
    this.apartment,
    this.intercom,
  });

  final String entrance;
  final String floor;
  final String apartment;
  final String intercom;

  factory DeliveryAddressDetails.fromJson(Map<String, dynamic> json) => DeliveryAddressDetails(
    entrance: json["entrance"] == null ? null : json["entrance"],
    floor: json["floor"] == null ? null : json["floor"],
    apartment: json["apartment"] == null ? null : json["apartment"],
    intercom: json["intercom"] == null ? null : json["intercom"],
  );

  Map<String, dynamic> toJson() => {
    "entrance": entrance == null ? null : entrance,
    "floor": floor == null ? null : floor,
    "apartment": apartment == null ? null : apartment,
    "intercom": intercom == null ? null : intercom,
  };
}

class DeliveryTariff {
  DeliveryTariff({
    this.price,
    this.estimatedTime,
  });

  final int price;
  final int estimatedTime;

  factory DeliveryTariff.fromJson(Map<String, dynamic> json) => DeliveryTariff(
    price: json["price"] == null ? null : json["price"],
    estimatedTime: json["estimated_time"] == null ? null : json["estimated_time"],
  );

  Map<String, dynamic> toJson() => {
    "price": price == null ? null : price,
    "estimated_time": estimatedTime == null ? null : estimatedTime,
  };
}
