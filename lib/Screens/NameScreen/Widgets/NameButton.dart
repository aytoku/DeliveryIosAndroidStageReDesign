import 'package:flutter/material.dart';

import '../../../data/data.dart';

class NameButton extends StatefulWidget {
  Color color;
  VoidCallback onTap;

  NameButton({Key key, this.color, this.onTap}) : super(key: key);

  @override
  NameButtonState createState() {
    return new NameButtonState(color, onTap: onTap);
  }
}

class NameButtonState extends State<NameButton> {
  String error = '';
  Color color;
  final VoidCallback onTap;

  NameButtonState(this.color, {this.onTap});


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
                    color: AppColor.unselectedTextColor)),
          ),
        ),
      ),
      onTap: () async {
        await onTap();
      },
    );
  }
}