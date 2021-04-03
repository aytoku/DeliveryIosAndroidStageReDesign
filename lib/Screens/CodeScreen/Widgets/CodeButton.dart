import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../Internet/check_internet.dart';
import '../../../data/data.dart';

class CodeButton extends StatefulWidget {
  Color color;
  final AsyncCallback onTap;

  CodeButton({Key key, this.color, this.onTap}) : super(key: key);

  @override
  CodeButtonState createState() {
    return new CodeButtonState(color, onTap);
  }
}

class CodeButtonState extends State<CodeButton> {
  String error = '';
  TextField code1;
  TextField code2;
  TextField code3;
  TextField code4;
  Color color;
  final AsyncCallback onTap;

  CodeButtonState(this.color, this.onTap);

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
          await onTap();
        } else {
          noConnection(context);
        }
      },
    );
  }

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
}