import 'package:flutter/material.dart';
import 'package:kz/generated/l10n.dart';
import 'package:kz/routes.dart';
import 'package:kz/utils/app_keys.dart';

class InitialPage extends StatefulWidget {
  @override
  _InitialPageState createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {

  void goToHomePage() {
    Navigator.pushReplacementNamed(context, Routes.initial);
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(S.of(AppKeys.navigatorKey.currentContext).app_name, style: TextStyle(color: Colors.white),),
    );
  }
}
