import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/CartScreen/Model/CartModel.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:flutter_app/Screens/OrderConfirmationScreen/API/promo_code.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

import '../../../data/data.dart';
import '../../../data/globalVariables.dart';
import '../../../data/globalVariables.dart';
import '../../../data/globalVariables.dart';
import '../../../data/globalVariables.dart';
import '../../../data/globalVariables.dart';
import '../View/address_screen.dart';

class PromoText extends StatefulWidget {
  PromoText({
    this.key,
    this.title,
    this.parent
  }) : super(key: key);
  final GlobalKey<PromoTextState> key;
  String title;
  AddressScreenState parent;

  @override
  PromoTextState createState() {
    return new PromoTextState(title, parent);
  }
}

class PromoTextState extends State<PromoText>{

  String title = '  Введите\nпромокод';
  TextEditingController promoCodeField;
  AddressScreenState parent;
  PromoTextState(title, this.parent);

  @override
  void initState(){
    super.initState();
    promoCodeField = new TextEditingController();
    if(savedPromo != null && savedPromo.code != null && savedPromo.stores.contains(parent.restaurant)){
      promoCodeField.text = savedPromo.code;
    }
    lock = false;
  }

  @override
  void dispose(){
    super.dispose();
    promoCodeField.dispose();
  }

  promoCodeAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(context).pop(true);
        });
        return Padding(
          padding: EdgeInsets.only(bottom: 500),
          child: Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            child: Container(
              height: 50,
              width: 100,
              child: Center(
                child: Text("Промокод не действителен"),
              ),
            ),
          ),
        );
      },
    );
  }

  _promoCode() {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20),
            )),
        context: context,
        builder: (context) {
          return Container(
            height: 500,
            child: _buildPromoCodeBottomNavigationMenu(),
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                )),
          );
        });
  }

  _buildPromoCodeBottomNavigationMenu() {
    return Container(
      height: 500,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 60, bottom: 315),
        child: Container(
          height: 40,
          width: 300,
          decoration: BoxDecoration(
            color: AppColor.mainColor,
            border: Border.all(
              color: AppColor.mainColor,
            ),
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.only(top: 0),
                  child: TextField(
                    controller: promoCodeField,
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                    autofocus: true,
                    decoration: new InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      counterText: '',
                      hintStyle: TextStyle(
                          color: Color(0xFFC0BFC6),
                          fontSize: 14
                      ),
                      hintText: 'Введите промокод',
                    ),
                  )
              ),
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10),),
                    ),
                    child: Center(
                      child: Text('Применить',
                        style: TextStyle(
                          fontSize: 21,
                          color: AppColor.unselectedTextColor,
                        ),
                      ),
                    ),
                  ),
                ),
                onTap: () async {
                  if(!lock){
                    lock = true;
                    try{
                      title = promoCodeField.text;
                      CartModel tempCartModel = await sendPromo(title, currentUser.cartModel.uuid);
                      currentUser.cartModel = tempCartModel ?? currentUser.cartModel;
                      Navigator.pop(context);
                      parent.setState(() {
                        if(tempCartModel==null){
                          promoCodeAlert(context);
                          title = '  Введите\nпромокод';
                        }
                      });
                    }finally{
                      lock = false;
                      savedPromo = null;
                    }
                  }else{
                    await Vibrate.vibrate();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: 10, left: 0, right: 0, bottom: 10),
      child: Align(
        alignment: Alignment.bottomRight,
        child: InkWell(
          child: Container(
            width: 160,
            height: 64,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 2.0,
                      offset: Offset(0.0, 1)
                  )
                ],
                color: AppColor.themeColor,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(width: 1.0, color: Colors.grey[200])),
            child: Padding(
              padding: EdgeInsets.only(
                  top: 10, left: 15, right: 15, bottom: 10),
              child: Column(
                children: [
                  (title != '  Введите\nпромокод') ? Text('Промокод применен',
                    style: TextStyle(
                        color: Color(0xFFB8B8B8), fontSize: 12),) : Container(),
                  (title != '  Введите\nпромокод') ? Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 3, top: 10),
                        child: Text(title),
                      )
                  ) : Text(title)
                ],
              ),
            ),
          ),
          onTap: () async {
            _promoCode();
          },
        ),
      ),
    );
  }
}