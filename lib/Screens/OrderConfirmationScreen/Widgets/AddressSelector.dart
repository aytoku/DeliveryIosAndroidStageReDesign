import 'package:flutter/material.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/Screens/MyAddressesScreen/Model/my_addresses_model.dart';
import 'package:flutter_app/Screens/OrderConfirmationScreen/View/add_address_screen.dart';
import 'package:flutter_app/Screens/OrderConfirmationScreen/View/address_screen.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/data/global_variables.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddressSelector extends StatefulWidget {
  List<MyFavouriteAddressesModel> myFavouriteAddressList;
  AddressScreenState parent;
  GlobalKey<AddressSelectorState> addressSelectorKey;

  AddressSelector({this.addressSelectorKey, this.myFavouriteAddressList, this.parent}) : super(key: addressSelectorKey);

  @override
  AddressSelectorState createState() => AddressSelectorState(myFavouriteAddressList, parent);
}

class AddressSelectorState extends State<AddressSelector> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;
  MyFavouriteAddressesModel myFavouriteAddressesModel;
  List<MyFavouriteAddressesModel> myFavouriteAddressList;
  AddressScreenState parent;
  TextEditingController notFavouriteAddressController;

  AddressSelectorState(this.myFavouriteAddressList, this.parent);

  @override
  void initState() {
    super.initState();
    notFavouriteAddressController = new TextEditingController();
    if(myFavouriteAddressList.length > 0){
      myFavouriteAddressesModel = myFavouriteAddressList[0];
      if(myFavouriteAddressList.last.address != null && myFavouriteAddressList.last.type == null){
        myFavouriteAddressesModel = myFavouriteAddressList.last;
        notFavouriteAddressController.text = myFavouriteAddressList.last.address.street + ' ' +
            myFavouriteAddressList.last.address.house;
      }
    }
  }

  @override
  void dispose(){
    super.dispose();
  }


  Widget build(BuildContext context) {
    List<Widget> widgetsList = new List<Widget>();
    myFavouriteAddressList.forEach((element) {
      if(element.type == null) {
        widgetsList.add(Container()
        );
      } else {
        widgetsList.add(
            Padding(
              padding: const EdgeInsets.only(right: 15, left: 15, bottom: 10),
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: InkWell(
                      child: Container(
                        child: Row(
                          children: [
                            (myFavouriteAddressesModel == element)
                                ? SvgPicture.asset(
                                'assets/svg_images/address_screen_selector.svg')
                                :
                            SvgPicture.asset(
                                'assets/svg_images/circle.svg'),
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.only(left: 15),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 10, bottom: 5),
                                    child: Text(
                                      element.address.street + ' ' +
                                          element.address.house,
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () async {
                        setState(() {
                          myFavouriteAddressesModel = element;
                          notFavouriteAddressController.text = '';
                          myFavouriteAddressList.last.address = null;
                        });
                      },
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 20,
                    color: Colors.grey,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: InkWell(
                      child: SvgPicture.asset(
                          'assets/svg_images/edit.svg'),
                      onTap: () async {
                        if (await Internet.checkConnection()) {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) {
                                  return new AddAddressScreen(
                                    myAddressesModel: element,
                                    parent: parent,
                                  );
                                }),
                          );
                        } else {
                          noConnection(context);
                        }
                      },
                    ),
                  ),
                ],
              ),
            )
        );
      }
    });
    return Container(
      color: AppColor.elementsColor,
      child: ScrollConfiguration(
        behavior: new ScrollBehavior(),
        child: Column(
          children: [
            SingleChildScrollView(
              child: Column(
                  children: widgetsList
              ),
            ),
            GestureDetector(
              child: Padding(
                padding: const EdgeInsets.only(top: 0, left: 15, right: 15),
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 15),
                      child: TextFormField(
                        style: TextStyle(color: AppColor.textColor),
                        onTap: () async {
                          if (await Internet.checkConnection()) {
                            Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) {
                                    return new AddAddressScreen(
                                        myAddressesModel:
                                        myFavouriteAddressList.last,
                                        parent: parent
                                    );
                                  }),
                            );
                          } else {
                            noConnection(context);
                          }
                        },
                        readOnly: true,
                        controller: notFavouriteAddressController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 15),
                          hintText: 'Указать адрес',
                          hintStyle: TextStyle(
                              color: AppColor.additionalTextColor
                          ),
                          enabledBorder:  OutlineInputBorder(
                            // width: 0.0 produces a thin "hairline" border
                            borderRadius: BorderRadius.circular(10),
                            borderSide: (notFavouriteAddressController.text != '') ? BorderSide(color: AppColor.mainColor) : BorderSide(color: AppColor.additionalTextColor),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Container(
                            color: AppColor.elementsColor,
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
              ),
            )
          ],
        ),
      ),
    );
  }
}