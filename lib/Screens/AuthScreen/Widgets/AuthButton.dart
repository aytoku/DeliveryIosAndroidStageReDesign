import 'package:flutter/material.dart';

import '../../../Internet/check_internet.dart';
import '../../../data/data.dart';
import '../Bloc/phone_number_event.dart';
import '../Bloc/phone_number_get_bloc.dart';
import '../View/auth_screen.dart';

class AuthButton extends StatefulWidget {
  Color color;
  AuthSources source;
  AuthGetBloc authGetBloc;

  AuthButton({Key key, this.color, this.source, this.authGetBloc}) : super(key: key);

  @override
  AuthButtonState createState() {
    return new AuthButtonState(color, source, authGetBloc);
  }
}

class AuthButtonState extends State<AuthButton> {
  String error = '';
  Color color = Color(0xFFF3F3F3);
  AuthSources source;
  AuthGetBloc authGetBloc;

  AuthButtonState(this.color, this.source, this.authGetBloc);

  String validateMobile(String value) {
    String pattern = r'(^(?:[+]?7)[0-9]{10}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return 'Укажите норер';
    } else if (!regExp.hasMatch(value)) {
      return 'Указан неверный номер';
    }
    return null;
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 52,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text('Далее',
                style: TextStyle(
                    fontSize: 18.0,
                    color: AppColor.textColor)),
          ),

        ),
      ),
      onTap: () async {
        if (await Internet.checkConnection()) {
          currentUser.phone = currentUser.phone.replaceAll('-', '');
          currentUser.phone = currentUser.phone.replaceAll(' ', '');
          print(currentUser.phone);
          if (validateMobile(currentUser.phone) == null) {
            if (currentUser.phone[0] != '+') {
              currentUser.phone = '+' + currentUser.phone;
            }
            authGetBloc.add(SendPhoneNumber(phoneNumber: currentUser.phone)); // отправка события в bloc
          } else {
            authGetBloc.add(SetError('Указан неверный номер')); // отправка события в bloc
          }
        } else {
          noConnection(context);
        }
      },
    );
  }
}