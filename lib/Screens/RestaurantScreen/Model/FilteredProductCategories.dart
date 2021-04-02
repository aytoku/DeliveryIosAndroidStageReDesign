class FilteredProductCategoriesData{

  List<FilteredProductCategories> filteredProductCategories;

  FilteredProductCategoriesData( {
    this.filteredProductCategories,
  });

  factory FilteredProductCategoriesData.fromJson(List<dynamic> parsedJson){
    List<FilteredProductCategories> filteredProductCategoriesList = null;
    if(parsedJson != null){
      filteredProductCategoriesList = parsedJson.map((i) => FilteredProductCategories.fromJson(i)).toList();
    }

    return FilteredProductCategoriesData(
      filteredProductCategories:filteredProductCategoriesList,
    );
  }
}


class FilteredProductCategories {
  FilteredProductCategories({
    this.uuid,
    this.name,
    this.priority,
    this.parentUuid,
    this.count,
    this.meta,
  });

  final String uuid;
  final String name;
  final int priority;
  final String parentUuid;
  final int count;
  final Meta meta;

  factory FilteredProductCategories.fromJson(Map<String, dynamic> json) => FilteredProductCategories(
    uuid: json["uuid"] == null ? null : json["uuid"],
    name: json["name"] == null ? null : json["name"],
    priority: json["priority"] == null ? null : json["priority"],
    parentUuid: json["parent_uuid"] == null ? null : json["parent_uuid"],
    count: json["count"] == null ? null : json["count"],
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid == null ? null : uuid,
    "name": name == null ? null : name,
    "priority": priority == null ? null : priority,
    "parent_uuid": parentUuid == null ? null : parentUuid,
    "count": count == null ? null : count,
    "meta": meta == null ? null : meta.toJson(),
  };
}

class Meta {
  Meta();

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
  );

  Map<String, dynamic> toJson() => {
  };
}
