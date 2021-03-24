import 'package:flutter/material.dart';
import 'package:flutter_app/data/global_variables.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../data/data.dart';

class PriorityScreen extends StatefulWidget {

  PriorityScreen({Key key}) : super(key: key);

  @override
  PriorityScreenState createState() {
    return new PriorityScreenState();
  }
}

class PriorityScreenState extends State<PriorityScreen>{

  PriorityScreenState();

  List<bool> selectedFilterItem;

  List<String> titles = [
    'Доверюсь вам',
    'С высоким рейтингом',
    'Быстрые',
    'Недорогие',
    'Дорогие',
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedFilterItem = List.generate(5, (index) => false);
  }

  @override
  Widget build(BuildContext context) {

    return Container(
        padding: EdgeInsets.only(),
        height: 370,
        child: Column(
          children: [
            Container(
              height: 280,
              child: ListView(
                padding: EdgeInsets.zero,
                children: List.generate(5,(index){
                  return InkWell(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 15),
                      child: (!selectedFilterItem[index]) ? Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(titles[index],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18
                              ),
                            ),
                            SvgPicture.asset('assets/svg_images/home_unselected_item.svg'),
                          ],
                        ),
                      ) : Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(titles[index],
                              style: TextStyle(
                                  fontSize: 18
                              ),
                            ),
                            SvgPicture.asset('assets/svg_images/home_selected_item.svg'),
                          ],
                        ),
                      ),
                    ),
                    onTap: (){
                      setState(() {
                        selectedFilterItem[index] = !selectedFilterItem[index];
                      });
                    },
                  );
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 10),
              child: FlatButton(
                child: Text('Готово',
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white)),
                color: (haveSelectedItems()) ? mainColor : Color(0xF3F3F3F3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.only(left: 140, top: 20, right: 140, bottom: 20),
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
            )
          ],
        )
    );
  }

  bool haveSelectedItems(){
    try{
      var selectedItem = selectedFilterItem.firstWhere((element) => element);
      return true;
    }catch(e){
      return false;
    }
  }
}