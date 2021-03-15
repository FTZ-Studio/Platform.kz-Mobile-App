import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kz/Style.dart';
import 'package:kz/UI/General/General.dart';
import 'package:kz/UI/InitialPage/InitialPage.dart';
import 'package:kz/UI/widgets/ConnectionProvider.dart';
import 'package:kz/routes.dart';
import 'package:kz/utils/app_keys.dart';
import 'generated/l10n.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData().copyWith(backgroundColor: cBlack,appBarTheme: ThemeData().appBarTheme.copyWith(color: cWhite, actionsIconTheme: IconThemeData(size: 24, color: cBlack, opacity: 1))),
      navigatorKey: AppKeys.navigatorKey,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      title: "S.of(context).app_name",
      builder: (context, child) {
        return MediaQuery(
          child: Scaffold(
            key: AppKeys.scaffoldKey,
            body: ConnectionProvider(
              child: child,
            ),
          ),
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        );
      },
      initialRoute: Routes.general,
      routes: <String, WidgetBuilder>{
        Routes.initial: (BuildContext context) => InitialPage(),
        Routes.general: (BuildContext context) => General(),
      },
    );
  }
}

