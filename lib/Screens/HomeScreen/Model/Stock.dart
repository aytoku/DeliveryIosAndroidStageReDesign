import 'package:flutter_app/Screens/HomeScreen/Model/FilteredStores.dart';

class StockData{
  List<Stock> stockList;

  StockData( {
    this.stockList,
  });

  factory StockData.fromJson(List<dynamic> parsedJson){

    List<Stock> stocks;
    if(parsedJson != null){
      stocks = parsedJson.map((i) => Stock.fromJson(i)).toList();
    }

    return StockData(
      stockList:stocks,
    );
  }
}

class Stock {
  Stock({
    this.uuid,
    this.name,
    this.stores,
    this.image,
    this.description,
    this.banner,
    this.citiesUuid,
    this.code,
    this.offerStart,
    this.offerEnd
  });

  String uuid;
  String name;
  List<FilteredStores> stores;
  List<String> citiesUuid;
  String image;
  String description;
  String banner;
  String code;
  DateTime offerStart;
  DateTime offerEnd;

  factory Stock.fromJson(Map<String, dynamic> json) => Stock(
    uuid: json["uuid"] == null ? null : json["uuid"],
    name: json["name"] == null ? null : json["name"],
    stores: json["stores"] == null ? null : List<FilteredStores>.from(json["stores"].map((x) => FilteredStores.fromJson(x))),
    citiesUuid: json["cities_uuid"] == null ? null : List<String>.from(json["cities_uuid"].map((x) => (x))),
    image: json["image"] == null ? null : json["image"],
    description: json["description"] == null ? null : json["description"],
    banner: json["banner"] == null ? null : json["banner"],
    code: json["code"],
    offerStart: DateTime.parse(json["offer_start"]),
    offerEnd: DateTime.parse(json["offer_end"]),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid == null ? null : uuid,
    "name": name == null ? null : name,
    "stores_uuid": stores == null ? null : List<dynamic>.from(stores.map((x) => x.toJson())),
    "cities_uuid": citiesUuid == null ? null : List<dynamic>.from(citiesUuid.map((x) => x)),
    "image": image == null ? null : image,
    "banner": banner == null ? null : banner,
    "description": description == null ? null : description,
    "code": code,
    "offer_start": offerStart.toIso8601String(),
    "offer_end": offerEnd.toIso8601String(),
  };
}