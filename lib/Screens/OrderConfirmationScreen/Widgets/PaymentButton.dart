import 'dart:io';
import 'package:tap_debouncer/tap_debouncer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/OrderConfirmationScreen/Model/DeliveryTariff.dart';
import 'package:flutter_app/Screens/OrderConfirmationScreen/View/address_screen.dart';
import 'package:flutter_app/Screens/OrderConfirmationScreen/Widgets/AddressSelector.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PaymentButton extends StatefulWidget {
  final AsyncCallback onTap;
  AddressScreenState parent;

  PaymentButton({Key key, this.onTap, this.parent}) : super(key: key);

  @override
  PaymentButtonState createState() {
    return new PaymentButtonState(onTap, parent);
  }
}

class PaymentButtonState extends State<PaymentButton>{
  final AsyncCallback onTap;
  AddressScreenState parent;
  PaymentButtonState(this.onTap, this.parent);
  @override
  Widget build(BuildContext context) {
    var deliveryTariff;
    if(parent.addressSelectorKey.currentState != null
        && parent.addressSelectorKey.currentState.myFavouriteAddressesModel.deliveryTariff != null){
      deliveryTariff = parent.addressSelectorKey.currentState.myFavouriteAddressesModel.deliveryTariff;
    }else{
      deliveryTariff = new DeliveryTariff(price: 0, estimatedTime: 0);
    }
    double totalPrice = currentUser.cartModel.totalPrice + deliveryTariff.price;
    if(parent.selectedPaymentMethod == parent.paymentMethods[0]){
      return Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 5.0,
                offset: Offset(0.0, 1)
            )
          ],
          color: AppColor.themeColor,),
        child: Padding(
          padding: EdgeInsets.only(bottom: 15, left: 50, right: 20, top: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                      '${(totalPrice).toStringAsFixed(0)} \₽',
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black)),
                  Padding(
                    padding: const EdgeInsets.only(right: 3),
                    child: Text(
                      (deliveryTariff.estimatedTime / 60).toString() + ' мин.',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              Stack(
                children: [
                  Container(
                    height: 52,
                    width: 168,
                    decoration: BoxDecoration(
                      color: AppColor.mainColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text('Заказать',
                          style: TextStyle(
                              fontSize: 18.0,
                              color: AppColor.textColor)),
                    ),
                  ),
                  Material(
                    type: MaterialType.transparency,
                    child: TapDebouncer(
                      cooldown: const Duration(seconds: 5),
                        onTap: () async {
                          if(onTap != null){
                            await onTap();
                          }
                        },
                      builder: (BuildContext context, TapDebouncerFunc onTap) {
                        return InkWell(
                          splashColor: AppColor.unselectedBorderFieldColor.withOpacity(0.5),
                          child: Container(
                            width: 168,
                            height: 52,
                          ),
                         onTap: onTap,
                        );
                      }
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      );
    }else{
      return InkWell(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 43,
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(5)
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Text('Оплатить',
                      style: TextStyle(
                          fontSize: 21,
                          letterSpacing: 0.4,
                          color: Colors.white,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                  ),
                  SvgPicture.asset((Platform.isIOS)
                      ? 'assets/svg_images/apple_pay_logo.svg'
                      : 'assets/svg_images/google_pay_logo.svg')
                ],
              ),
            ),
          ),
        ),
        onTap: () async {
          if(onTap != null){
            await onTap();
          }
        },
      );
    }
  }
}