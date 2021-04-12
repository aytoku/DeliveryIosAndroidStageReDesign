import 'package:flutter/material.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/VersionControl/API/getCurrentVersion.dart';
import 'package:flutter_app/VersionControl/Model/CurrentVersionModel.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_app/VersionControl/API/getCurrentVersion.dart';
import 'package:flutter_app/VersionControl/Model/CurrentVersionModel.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AboutAppScreen extends StatefulWidget {
  @override
  AboutAppScreenState createState() => AboutAppScreenState();
}

class AboutAppScreenState extends State<AboutAppScreen> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Container(
          color: AppColor.themeColor,
          child: Stack(
            children: <Widget>[
              ScreenTitlePop(img: 'assets/svg_images/arrow_left.svg', title: 'О приложении'),
              Align(
                alignment: Alignment.center,
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
                    child: Column(
                      children: <Widget>[
                        Center(
                          child: Padding(
                              padding: EdgeInsets.only(top: 20, bottom: 10),
                              child: Image.asset('assets/images/Beirut.png')
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 25),
                          child: Center(
                              child: Text(
                                'Версия $version от 10 апр. 2021 г.\nсборка 9',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Color(0x97979797), fontSize: 15),
                              )
                          ),
                          // FutureBuilder<CurrentVersionModel>(
                          //   future: getCurrentVersion(authCodeData.token),
                          //   builder: (context, AsyncSnapshot<CurrentVersionModel> snapshot) {
                          //     return Center(
                          //       child: (snapshot.connectionState == ConnectionState.done && snapshot.data != null) ? Text(
                          //         'Версия ${CheckVersion.updateVersion} от 27 мар. 2021 г.\nсборка 19',
                          //         textAlign: TextAlign.center,
                          //         style: TextStyle(color: Color(0x97979797), fontSize: 15),
                          //       ) : Center(
                          //         child: SpinKitThreeBounce(
                          //           color: AppColor.mainColor,
                          //           size: 20.0,
                          //         ),
                          //       ),
                          //       // Text(
                          //       //   'Версия 1.0.10 от 27 мар. 2021 г.\nсборка 19',
                          //       //   textAlign: TextAlign.center,
                          //       //   style: TextStyle(color: Color(0x97979797), fontSize: 15),
                          //       // ),
                          //     );
                          //   }
                          // ),
                        ),
                          // Container(
                          //   height: 30,
                          //   color: Color(0xFFF9F9F9),
                          // ),
                        // Align(
                        //   alignment: Alignment.centerLeft,
                        //   child: InkWell(
                        //     child: Padding(
                        //       padding:
                        //       EdgeInsets.only(top: 20, bottom: 20, left: 15, right: 15),
                        //       child: Row(
                        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //         children: <Widget>[
                        //           Text('Лицензионное соглашение',
                        //               style:
                        //               TextStyle(fontSize: 17, color: Color(0xFF424242))),
                        //           GestureDetector(
                        //             child:
                        //             SvgPicture.asset('assets/svg_images/arrow_right.svg'),
                        //           )
                        //         ],
                        //       ),
                        //     ),
                        //     onTap: () async {
                        //       if (await Internet.checkConnection()) {
                        //         if (await canLaunch("https://faem.ru/legal/agreement")) {
                        //           await launch("https://faem.ru/legal/agreement");
                        //         }
                        //       } else {
                        //         noConnection(context);
                        //       }
                        //     },
                        //   ),
                        // ),
                        // Divider(height: 1.0, color: Color(0xFFEDEDED)),
                        // Align(
                        //   alignment: Alignment.centerLeft,
                        //   child: InkWell(
                        //     child: Padding(
                        //       padding:
                        //       EdgeInsets.only(top: 20, bottom: 20, left: 15, right: 15),
                        //       child: Row(
                        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //         children: <Widget>[
                        //           Text('Политика конфиденцальности',
                        //               style:
                        //               TextStyle(fontSize: 17, color: Color(0xFF424242))),
                        //           GestureDetector(
                        //             child:
                        //             SvgPicture.asset('assets/svg_images/arrow_right.svg'),
                        //           )
                        //         ],
                        //       ),
                        //     ),
                        //     onTap: () async {
                        //       if (await Internet.checkConnection()) {
                        //         if (await canLaunch("https://faem.ru/privacy")) {
                        //           await launch("https://faem.ru/privacy");
                        //         }
                        //       } else {
                        //         noConnection(context);
                        //       }
                        //     },
                        //   ),
                        // ),
                        // Divider(height: 1.0, color: Color(0xFFEDEDED)),
                      ],
                    ),
                  ),
                ),
              ),
              // Align(
              //   alignment: Alignment.bottomLeft,
              //   child: Padding(
              //     padding: EdgeInsets.only(bottom: 20, left: 15),
              //     child: Text(
              //       '@ 2011-2020 ООО «ФАЕМ ТЕХНОЛОГИИ»',
              //       style: TextStyle(color: Color(0x97979797), fontSize: 15),
              //     ),
              //   ),
              // )
            ],
          ),
        ));
  }
}