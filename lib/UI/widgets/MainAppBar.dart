import 'package:flutter/material.dart';
import 'package:kz/Style.dart';

const double kToolbarHeight = 56.0;

class MainAppBar extends StatefulWidget implements PreferredSizeWidget{
  @override
  _MainAppBarState createState() => _MainAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _MainAppBarState extends State<MainAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Icon(Icons.menu, color: Theme.of(context).appBarTheme.actionsIconTheme.color),
      centerTitle: true,
      title: Text("LOGO", style: TextStyle(color: cBlack),),
    );
  }
}
