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
    this.storesUuid,
    this.image,
  });

  String uuid;
  String name;
  List<String> storesUuid;
  String image;

  factory Stock.fromJson(Map<String, dynamic> json) => Stock(
    uuid: json["uuid"] == null ? null : json["uuid"],
    name: json["name"] == null ? null : json["name"],
    storesUuid: json["stores_uuid"] == null ? null : List<String>.from(json["stores_uuid"].map((x) => x)),
    image: json["image"] == null ? null : json["image"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid == null ? null : uuid,
    "name": name == null ? null : name,
    "stores_uuid": storesUuid == null ? null : List<dynamic>.from(storesUuid.map((x) => x)),
    "image": image == null ? null : image,
  };
}