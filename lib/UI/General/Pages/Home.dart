import 'package:flutter/material.dart';
import 'package:kz/Style.dart';

class Home extends StatefulWidget {
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
          Text("СООБЩАЙТЕ \nО ПРОБЛЕМАХ", textAlign: TextAlign.start, style: TextStyle(color: cWhite, fontWeight: FontWeight.w600, fontSize: 40, fontFamily: fontFamily, height: 1.2),),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: cBlue,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  boxShadow: [BoxShadow(
                    color: cBlue,
                    offset: Offset(1,3),
                    blurRadius: 23,
                    spreadRadius: 0

                  )]
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(

                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.email, color: cWhite,),
                          SizedBox(width: 12,),
                          Text("Подать обращение", style: TextStyle(color: cWhite, fontSize: 20, fontFamily: fontFamily, fontWeight: FontWeight.w600),),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Spacer(),
          Spacer()
        ],
      ),
    );
  }
}
