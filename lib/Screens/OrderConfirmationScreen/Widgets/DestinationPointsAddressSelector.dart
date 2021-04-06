import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/MyAddressesScreen/Model/my_addresses_model.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DestinationPointsSelector extends StatefulWidget {
  final List<DestinationPoints> destinationPoints;

  DestinationPointsSelector({Key key, this.destinationPoints}) : super(key: key);

  @override
  DestinationPointsSelectorState createState() {
    return new DestinationPointsSelectorState(destinationPoints);
  }

}

class DestinationPointsSelectorState extends State<DestinationPointsSelector> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;
  DestinationPoints selectedDestinationPoint;
  List<DestinationPoints> destinationPointsList;

  DestinationPointsSelectorState(this.destinationPointsList);

  @override
  void initState() {
    if(destinationPointsList.length > 0){
      selectedDestinationPoint = destinationPointsList[0];
    }
    super.initState();
  }

  Widget build(BuildContext context) {
    super.build(context);
    List<Widget> widgetsList = new List<Widget>();
    destinationPointsList.forEach((element) {
      widgetsList.add(
          Padding(
              padding: EdgeInsets.only(right: 15, left: 15, top: 10, bottom: 10),
              child: InkWell(
                child: Container(
                  child: Row(
                    children: [
                      (selectedDestinationPoint == element)
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
                                  right: 0, bottom: 5),
                              child: Text(
                                element.unrestrictedValue,
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
                    selectedDestinationPoint = element;
                  });
                },
              )
          )
      );
    });
    return Container(
      color: AppColor.themeColor,
      child: ScrollConfiguration(
        behavior: new ScrollBehavior(),
        child: SingleChildScrollView(
          child: Column(
            children: widgetsList,
          ),
        ),
      ),
    );
  }
}