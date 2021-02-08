import 'dart:convert';

import '../../../models/ResponseData.dart';

AddressesModel addressesModelFromJson(String str) => AddressesModel.fromJson(json.decode(str));

String addressesModelToJson(AddressesModel data) => json.encode(data.toJson());

class AddressesModelData{
  List<AddressesModel> addressModelList;

  AddressesModelData( {
    this.addressModelList,
  });

  factory AddressesModelData.fromJson(List<dynamic> parsedJson){
    List<AddressesModel> storesList = null;
    if(parsedJson != null){
      storesList = parsedJson.map((i) => AddressesModel.fromJson(i)).toList();
    }

    return AddressesModelData(
      addressModelList:storesList,
    );
  }
}


class AddressesModel {
  AddressesModel({
    this.uuid,
    this.type,
    this.favorite,
    this.point,
  });

  String uuid;
  String type;
  bool favorite;
  DestinationPoints point;

  factory AddressesModel.fromJson(Map<String, dynamic> json) => AddressesModel(
    uuid: json["uuid"],
    type: json["type"],
    favorite: json["favorite"],
    point: DestinationPoints.fromJson(json["point"]),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "type": type,
    "favorite": favorite,
    "point": point.toJson(),
  };
}
