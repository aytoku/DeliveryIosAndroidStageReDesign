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
  });

  String uuid;
  String name;
  List<FilteredStores> stores;
  String image;

  factory Stock.fromJson(Map<String, dynamic> json) => Stock(
    uuid: json["uuid"] == null ? null : json["uuid"],
    name: json["name"] == null ? null : json["name"],
    stores: json["stores"] == null ? null : List<FilteredStores>.from(json["stores"].map((x) => FilteredStores.fromJson(x))),
    image: json["image"] == null ? null : json["image"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid == null ? null : uuid,
    "name": name == null ? null : name,
    "stores_uuid": stores == null ? null : List<dynamic>.from(stores.map((x) => x.toJson())),
    "image": image == null ? null : image,
  };
}