import 'package:flutter/material.dart';
import 'package:kz/Style.dart';
import 'package:kz/UI/General/Pages/Home.dart';
import 'package:kz/UI/widgets/MainAppBar.dart';
import 'package:kz/UI/widgets/TabBar/MainTabBar.dart';

class General extends StatefulWidget {
  @override
  _GeneralState createState() => _GeneralState();
}

class _GeneralState extends State<General> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: MainAppBar(),
          backgroundColor: Theme.of(context).backgroundColor,
          body: Stack(
            children: [
              PageView(
                children: [
                  Home()
                ],
              )
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: MainTabBar(
            listItems: [
              ItemMainTabBar(text: Text("Сообщить"), icon: Icon(Icons.where_to_vote_outlined, color: cRed,)),
              ItemMainTabBar(text: Text("Новости"), icon: Icon(Icons.messenger_outline, color: cBlue,)),
              ItemMainTabBar(text: Text("Тендеры"), icon: Icon(Icons.assignment_outlined, color: Colors.deepPurpleAccent,)),
              ItemMainTabBar(text: Text("Идеи"), icon: Icon(Icons.wb_incandescent_outlined, color: cGreen,)),
            ],

          ),
        )
      ],
    );
  }
}
