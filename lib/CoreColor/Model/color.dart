// To parse this JSON data, do
//
//     final colorData = colorDataFromJson(jsonString);

import 'dart:convert';



class ColorData {
  ColorData({
    this.mainColor,
    this.textColor,
    this.unselectedTextColor,
    this.additionalTextColor,
    this.themeColor,
    this.textFieldColor,
    this.elementsColor,
    this.subElementsColor,
    this.borderFieldColor,
    this.unselectedBorderFieldColor,
  });

  String mainColor;
  String textColor;
  String unselectedTextColor;
  String additionalTextColor;
  String themeColor;
  String textFieldColor;
  String elementsColor;
  String subElementsColor;
  String borderFieldColor;
  String unselectedBorderFieldColor;

  factory ColorData.fromJson(Map<String, dynamic> json) => ColorData(
    mainColor: json["main_color"],
    textColor: json["text_color"],
    unselectedTextColor: json["unselected_text_color"],
    additionalTextColor: json["additional_text_color"],
    themeColor: json["theme_color"],
    textFieldColor: json["text_field_color"],
    elementsColor: json["elements_color"],
    subElementsColor: json["sub_elements_color"],
    borderFieldColor: json["border_field_color"],
    unselectedBorderFieldColor: json["unselected_border_field_color"],
  );

  Map<String, dynamic> toJson() => {
    "main_color": mainColor,
    "text_color": textColor,
    "unselected_text_color": unselectedTextColor,
    "additional_text_color": additionalTextColor,
    "theme_color": themeColor,
    "text_field_color": textFieldColor,
    "elements_color": elementsColor,
    "sub_elements_color": subElementsColor,
    "border_field_color": borderFieldColor,
    "unselected_border_field_color": unselectedBorderFieldColor,
  };



}
