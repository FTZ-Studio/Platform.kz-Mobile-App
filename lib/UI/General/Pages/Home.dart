import 'package:flutter/material.dart';
import 'package:kz/Controllers/GeneralController.dart';
import 'package:kz/Style.dart';
import 'package:kz/UI/widgets/AddAppeal/showAddAppeal.dart';
import 'package:kz/UI/widgets/Auth/ShowAuth.dart';
import 'package:kz/utils/svg/IconSVG.dart';

class Home extends StatefulWidget {
  final GeneralController controller;
  Home(this.controller);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          Text(
            "Сообщайте \nо проблемах",
            textAlign: TextAlign.start,
            style: TextStyle(
                color: cWhite,
                fontWeight: FontWeight.w700,
                fontSize: 40,
                fontFamily: fontFamily,
                height: 1.3),
          ),
          SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  widget.controller.addAppeal();
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: cBlue,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      boxShadow: [
                        BoxShadow(
                            color: cBlue,
                            offset: Offset(1, 3),
                            blurRadius: 23,
                            spreadRadius: 0)
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Row(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconSvg(IconsSvg.letterArrow, width: 24),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              "Подать обращение",
                              style: TextStyle(
                                  color: cWhite,
                                  fontSize: 18,
                                  fontFamily: fontFamily,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Spacer(),
          Spacer(),
          Spacer(),
          Spacer()
        ],
      ),
    );
  }
}
