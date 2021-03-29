import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/CityScreen/API/getStreet.dart';
import 'package:flutter_app/Screens/MyAddressesScreen/Model/InitialAddressModel.dart';
import 'package:flutter_app/Screens/OrderConfirmationScreen/Widgets/Cross.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../API/necessary_address_data_pass.dart';

class AutoCompleteField extends StatefulWidget {
  GlobalKey<AutoCompleteFieldState> key;
  AsyncCallback onSelected;
  String initialValue;
  AutoCompleteField(this.key, {this.onSelected, this.initialValue}) : super(key: key);

  @override
  AutoCompleteFieldState createState() {
    return new AutoCompleteFieldState(onSelected, initialValue);
  }
}

class AutoCompleteFieldState extends State<AutoCompleteField> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;
  AutoCompleteFieldState(this.onSelected, this.initialValue);
  String initialValue;
  List<InitialAddressModel> suggestions;
  TextEditingController controller;
  AutocompleteList autocompleteList;
  InitialAddressModel selectedValue;
  AsyncCallback onSelected;
  FocusNode node;

  TextEditingController officeField;
  TextEditingController intercomField;
  TextEditingController entranceField;
  TextEditingController floorField;

  @override
  void initState(){
    autocompleteList = AutocompleteList(suggestions, this, new GlobalKey(), initialValue);
    controller = new TextEditingController(text: (initialValue != null) ? initialValue :  '');
    suggestions = new List<InitialAddressModel>();
    node = new FocusNode();
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
  }

  Widget build(BuildContext context) {
    FocusNode focusNode;
    return Container(
      color: AppColor.themeColor,
      child: Column(
        children: [
          Container(
              child: Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 15),
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: TextField(
                          controller: controller,
                          focusNode: node,
                          decoration: new InputDecoration(
                            suffix: Padding(
                              padding: const EdgeInsets.only(right:8.0, top: 3),
                              child: Cross(controller, autocompleteList),
                            ),
                            contentPadding: EdgeInsets.only(left: 10, right: 5, bottom: 10),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          onChanged: (text) async {
                            var temp = await findAddress(text);
                            if(temp != null && autocompleteList.autoCompleteListKey.currentState != null){
                              autocompleteList.autoCompleteListKey.currentState.setState(() {
                                autocompleteList.autoCompleteListKey.currentState.suggestions = temp;
                              });
                            }
                          },
                        ),
                      ),
                      Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Container(
                              color: AppColor.themeColor,
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  'Адрес',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: AppColor.additionalTextColor
                                  ),
                                ),
                              ),
                            ),
                          )
                      ),
                    ],
                  ),
                ],
              )
          ),
          // Padding(
          //   padding: EdgeInsets.only(
          //       top: 20, left: 5, bottom: 10, right: 0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: <Widget>[
          //       Container(
          //         width: 60,
          //         child: Padding(
          //             padding: EdgeInsets.only( bottom: 0, top: 5),
          //             child: Container(
          //               height: 20,
          //               child: TextField(
          //                 textCapitalization: TextCapitalization.sentences,
          //                 controller: entranceField,
          //                 maxLength: 3,
          //                 keyboardType: TextInputType.number,
          //                 focusNode: focusNode,
          //                 decoration: new InputDecoration(
          //                   hintText: 'Подъезд',
          //                   hintStyle: TextStyle(
          //                       color: Color(0xFFB0B0B0),
          //                       fontSize: 13),
          //                   border: InputBorder.none,
          //                   counterText: '',
          //                 ),
          //               ),
          //             )),
          //       ),
          //       Container(
          //         width: 60,
          //         child: Padding(
          //             padding: EdgeInsets.only( bottom: 0, top: 5),
          //             child: Container(
          //               height: 20,
          //               child: TextField(
          //                 textCapitalization: TextCapitalization.sentences,
          //                 controller: floorField,
          //                 keyboardType: TextInputType.number,
          //                 focusNode: focusNode,
          //                 maxLength: 2,
          //                 decoration: new InputDecoration(
          //                   hintText: 'Этаж',
          //                   hintStyle: TextStyle(
          //                       color: Color(0xFFB0B0B0),
          //                       fontSize: 13),
          //                   border: InputBorder.none,
          //                   counterText: '',
          //                 ),
          //               ),
          //             )),
          //       ),
          //       Container(
          //         width: 60,
          //         child: Padding(
          //             padding: EdgeInsets.only( bottom: 0, top: 5),
          //             child: Container(
          //               height: 20,
          //               child: TextField(
          //                 textCapitalization: TextCapitalization.sentences,
          //                 controller: officeField,
          //                 maxLength: 6,
          //                 focusNode: focusNode,
          //                 keyboardType: TextInputType.number,
          //                 decoration: new InputDecoration(
          //                   hintText: 'Кв./офис',
          //                   hintStyle: TextStyle(
          //                       color: Color(0xFFB0B0B0),
          //                       fontSize: 13),
          //                   border: InputBorder.none,
          //                   counterText: '',
          //                 ),
          //               ),
          //             )),
          //       ),
          //       Container(
          //         width: 80,
          //         child: Padding(
          //             padding: EdgeInsets.only( bottom: 0, top: 5),
          //             child: Container(
          //               height: 20,
          //               child: TextField(
          //                 textCapitalization: TextCapitalization.sentences,
          //                 controller: intercomField,
          //                 maxLength: 6,
          //                 keyboardType: TextInputType.number,
          //                 focusNode: focusNode,
          //                 decoration: new InputDecoration(
          //                   hintText: 'Домофон',
          //                   hintStyle: TextStyle(
          //                       color: Color(0xFFB0B0B0),
          //                       fontSize: 13),
          //                   border: InputBorder.none,
          //                   counterText: '',
          //                 ),
          //               ),
          //             )),
          //       ),
          //     ],
          //   ),
          // ),
          autocompleteList
        ],
      ),
    );
  }

  Future<List<InitialAddressModel>> findAddress(String searchText) async {
    // Результирующий список
    List<InitialAddressModel> necessaryAddressDataItems;

    try {
      // Если в поле автокомплита был введен текст
      if (searchText.length > 0) {
        // то получаем релеватные подсказки с сервера
        necessaryAddressDataItems =
            (await getStreet(searchText, selectedCity.uuid)).destinationPoints;
      } else {
        // иначе получаем список рекомендаций для заполнения с того же сервера
        // List<RecommendationAddressModel> temp = await RecommendationAddress.getRecommendations("target");
        // // который загоняем в подсказски автокомплита
        // necessaryAddressDataItems = temp.map<InitialAddressModel>((item) => item.address).toList();
      }
    }
    catch (e) {
      print("Error getting addresses.");
    }
    return necessaryAddressDataItems;
  }
}


class AutocompleteList extends StatefulWidget {
  List<InitialAddressModel> suggestions;
  AutoCompleteFieldState parent;
  String initialValue;
  GlobalKey<AutocompleteListState> autoCompleteListKey;
  AutocompleteList(this.suggestions, this.parent, this.autoCompleteListKey, this.initialValue) : super(key: autoCompleteListKey);

  @override
  AutocompleteListState createState() {
    return new AutocompleteListState(suggestions, parent, initialValue);
  }
}

class AutocompleteListState extends State<AutocompleteList> {

  List<InitialAddressModel> suggestions;
  AutoCompleteFieldState parent;
  String initialValue;
  AutocompleteListState(this.suggestions, this.parent, this.initialValue);

  @override
  void initState(){
    super.initState();
    suggestions = new List<InitialAddressModel>();
  }

  Widget suggestionRow(){
    return Container(
      width: MediaQuery.of(context).size.width,
      color: AppColor.themeColor,
      height: MediaQuery.of(context).size.height * 0.65,
      child: ListView(
        padding: EdgeInsets.zero,
          children: List.generate(suggestions.length, (index){
            return InkWell(
              child: Padding(
                padding: const EdgeInsets.only(left: 5, top: 10, right: 15, bottom: 0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(suggestions[index].unrestrictedValue,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 16
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text('Владикавказ, Республика Северная Осетия -\nАлания, Россия',
                          style: TextStyle(
                              fontSize: 12,
                              color: AppColor.additionalTextColor
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Divider(color: Colors.grey,),
                      )
                    ],
                  ),
                )
              ),
              onTap: () async {
                parent.selectedValue = suggestions[index];
                parent.controller.text = suggestions[index].unrestrictedValue;
                // Избегаем потери фокуса и ставим курсор в конец
                parent.node.requestFocus();
                parent.controller.selection = TextSelection.fromPosition(TextPosition(offset: parent.controller.text.length));
                if(parent.onSelected != null){
                  await parent.onSelected();
                }
                FocusScope.of(context).requestFocus(new FocusNode());
              },
            );
          })
      ),
    );
  }

  Widget build(BuildContext context) {
    if(suggestions == null || suggestions.length == 0){
      return FutureBuilder(
        future: parent.findAddress((initialValue == null) ? '' : initialValue),
        builder: (BuildContext context, AsyncSnapshot<List<InitialAddressModel>> snapshot){
          if(snapshot.hasData){
            if(snapshot.connectionState == ConnectionState.done){
              if(snapshot.data != null){
                suggestions = snapshot.data;
              }
              return suggestionRow();
            }
          }
          return Container();
        },
      );
    }
    return suggestionRow();
  }
}