import 'package:flutter/material.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/Screens/CartScreen/View/cart_page_view.dart';
import 'package:flutter_app/Screens/MyAddressesScreen/Model/my_addresses_model.dart';
import 'package:flutter_app/Screens/OrderConfirmationScreen/View/autocolplete_field_list.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:flutter_svg/svg.dart';
import 'address_screen.dart';

// ignore: must_be_immutable
class AddAddressScreen extends StatefulWidget {
  MyFavouriteAddressesModel myAddressesModel;
  AddressScreenState parent;

  AddAddressScreen({Key key, this.myAddressesModel, this.parent}) : super(key: key);

  @override
  AddAddressScreenState createState() =>
      AddAddressScreenState(myAddressesModel, parent);
}

class AddAddressScreenState extends State<AddAddressScreen> {
  bool status1 = false;
  String name;
  MyFavouriteAddressesModel myAddressesModel;
  GlobalKey<AutoCompleteFieldState> autoCompleteFieldKey;
  AddressScreenState parent;
  TextEditingController nameField;
  TextEditingController commentField;
  GlobalKey<CartPageState>cartPageKey;


  AddAddressScreenState(this.myAddressesModel, this.parent);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    autoCompleteFieldKey = new GlobalKey();
    nameField = new TextEditingController();
    commentField = new TextEditingController();
    cartPageKey = new GlobalKey();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    nameField.text = myAddressesModel.name;
    commentField.text = myAddressesModel.description;
    // TODO: implement build
    return Scaffold(
      backgroundColor: AppColor.themeColor,
      resizeToAvoidBottomPadding: false,
      body: GestureDetector(
        child: Stack(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                InkWell(
                  hoverColor: AppColor.themeColor,
                  focusColor: AppColor.themeColor,
                  splashColor: AppColor.themeColor,
                  highlightColor: AppColor.themeColor,
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                          padding: EdgeInsets.only(top: 30, bottom: 25),
                          child: Container(
                              height: 40,
                              width: 60,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 12, bottom: 12, right: 10),
                                child:SvgPicture.asset(
                                    'assets/svg_images/arrow_left.svg'),
                              )))),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 80, left: 20),
                  child: Column(
                    children: <Widget>[
                      // Align(
                      //   alignment: Alignment.topLeft,
                      //   child: Padding(
                      //     padding: EdgeInsets.only(top: 10, bottom: 10),
                      //     child: Text('Адрес',
                      //         style: TextStyle(fontSize: 14, color: Color(0xFF9B9B9B))),
                      //   ),
                      // ),
                      AutoCompleteField(autoCompleteFieldKey, onSelected: (){
                        myAddressesModel.address = DestinationPoints.fromInitialAddressModelChild(autoCompleteFieldKey.currentState.selectedValue);
                        return;
                      }, initialValue: (myAddressesModel.address == null) ? '' : myAddressesModel.address.unrestrictedValue,)
                    ],
                  ),
                )
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: AppColor.themeColor,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 15, left: 15, right: 15, top: 5),
                  child: FlatButton(
                    child: Text(
                        "Добавить адрес",
                        style: TextStyle(
                            fontSize: 16.0,
                            color: AppColor.textColor)
                    ),
                    color: AppColor.mainColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding:
                    EdgeInsets.only(left: 100, top: 20, right: 100, bottom: 20),
                    onPressed: () async {
                      if (await Internet.checkConnection()) {
                        if(myAddressesModel.address == null){
                          return;
                        }
                        myAddressesModel.name = nameField.text;
                        myAddressesModel.description = commentField.text;
                        //Navigator.pop(context);
                        Navigator.pop(context);
                        // Navigator.push(context,
                        //   new MaterialPageRoute(builder: (context) => new AddressScreen(restaurant: parent.restaurant, myAddressesModelList: parent.myAddressesModelList, isTakeAwayOrderConfirmation: false,)),
                        // );
                        setState(() {

                        });
                        parent.setState(() {

                        });

                      } else {
                        noConnection(context);
                      }
                    },
                  ),
                ),
              ),
            )
          ],
        ),
        onTap: (){
          FocusScope.of(context).requestFocus(new FocusNode());
        },
      ),
    );
  }
}