import 'package:flutter_app/Screens/MyAddressesScreen/API/add_address.dart';
import 'package:flutter_app/Screens/MyAddressesScreen/API/delete_address_by_uuid.dart';
import 'package:flutter_app/Screens/MyAddressesScreen/API/get_client_addresses.dart';
import 'package:flutter_app/Screens/MyAddressesScreen/Model/AddressesModel.dart';
import 'package:flutter_app/Screens/MyAddressesScreen/Model/InitialAddressModel.dart';
import 'package:flutter_app/Screens/OrderConfirmationScreen/Model/DeliveryTariff.dart';
import '../../../data/refreshToken.dart';

class MyFavouriteAddressesModel{
  // Список возможных тегов
  // null = empty
  static const List<String> MyAddressesTags = ["work","house","study", null];

  // useful
  String uuid;
  DestinationPoints address;
  String type;
  bool favorite;

  // еще 3 (4) поля для создания заказа
  String entranceField;
  String floorField;
  String officeField;
  String intercomField;
  DeliveryTariff deliveryTariff;

  // useless
  String name;
  String description;
  String clientUuid;

  MyFavouriteAddressesModel( {
    this.address,
    this.name,
    this.favorite,
    this.description,
    this.uuid,
    this.type,
    this.clientUuid
  });

  Future<MyFavouriteAddressesModel> ifNoBrainsSave() async{
    if(name == "")
      name = " ";
    if(uuid == null || uuid == "")
      return await save();
    else
      return await update();
  }

  Future<MyFavouriteAddressesModel> save() async{
    // Обновляем токен
    await SendRefreshToken.sendRefreshToken();
    // Отправляем данные на сервер

    await addAddress(type, favorite, address);

    return this;
  }

  Future<MyFavouriteAddressesModel> update() async{
    return this;
  }

  Future<void> delete() async{
      await deleteAddressByUuid(uuid);
  }

  static Future<List<MyFavouriteAddressesModel>> getAddresses() async{
    List<MyFavouriteAddressesModel> addressesList = List<MyFavouriteAddressesModel>();

    AddressesModelData addressesModelData = await getClientAddress();

    // Если что-то пошло не так, возвращаем пустой список

    if(addressesModelData == null || addressesModelData.addressModelList == null)
      return addressesList;

    // Иначе возвращаем заполненный
    addressesList = addressesModelData.addressModelList;
    return addressesList;
  }

  Map<String, dynamic> toServerSaveJson() => {
    "name": name,
    "description": description,
    "tag": type,
    "address": address.toJson(),
  };

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "description": description,
    "tag": type,
    "client_uuid": clientUuid,
    "address": address.toJson(),
  };


  factory MyFavouriteAddressesModel.fromJson(Map<String, dynamic> parsedJson){
    return new MyFavouriteAddressesModel(
      address:DestinationPoints.fromJson(parsedJson['point']),
      uuid: parsedJson["uuid"],
      type: parsedJson["type"],
      favorite: parsedJson["favorite"],

      name: "",
      description: "",
      clientUuid: "",
    );
  }
}

class DestinationPoints extends InitialAddressModel {
  // Поля класса
  String type;
  String pointType;
  int frontDoor;


  DestinationPoints({
    String uuid,
    String unrestrictedValue,
    this.pointType,
    String value,
    String country,
    String region,
    String regionType,
    this.type,
    String city,
    String cityType,
    String street,
    String streetType,
    String streetWithType,
    String house,
    String comment,
    this.frontDoor,
    bool outOfTown,
    String houseType,
    int accuracyLevel,
    int radius,
    double lat,
    double lon,
  }):super( // Передаем данные в родительский конструктор
      uuid: uuid,
      unrestrictedValue: unrestrictedValue,
      value: value,
      country: country,
      region: region,
      regionType: regionType,
      city: city,
      cityType: cityType,
      street: street,
      streetType: streetType,
      streetWithType: streetWithType,
      house: house,
      outOfTown: outOfTown,
      houseType: houseType,
      accuracyLevel: accuracyLevel,
      radius: radius,
      lat: lat,
      lon: lon,
      comment: comment,
  );

  factory DestinationPoints.fromJson(Map<String, dynamic> json) => DestinationPoints(
    unrestrictedValue: json["unrestricted_value"],
    uuid: json["uuid"],
    value: json["value"],
    country: json["country"],
    comment: json["comment"],
    pointType: json["point_type"],
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
    outOfTown: json["out_of_town"],
    houseType: json["house_type"],
    accuracyLevel: json["accuracy_level"],
    radius: json["radius"],
    lat: json["lat"].toDouble(),
    lon: json["lon"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "unrestricted_value": unrestrictedValue,
    "uuid": uuid,
    "value": value,
    "comment": comment,
    "point_type": pointType,
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
    "out_of_town": outOfTown,
    "house_type": houseType,
    "accuracy_level": accuracyLevel,
    "radius": radius,
    "lat": lat,
    "lon": lon,
  };
  factory DestinationPoints.fromInitialAddressModelChild(var address){
    return address;
  }
}