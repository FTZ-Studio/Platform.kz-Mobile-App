import 'package:flutter/material.dart';
import 'package:kz/Style.dart';
import 'package:url_launcher/url_launcher.dart';

class Contacts extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: _content(),
    );
  }

  Widget _content(){
    return Column(
      children: [
        ListTile(
          onTap: (){
            launch("tel://+77012027766");
          },
          title: Text("+7 701 202 7766", style: TextStyle(color: cBlue, fontFamily: fontFamily, fontSize: 18),),
          subtitle: Text("Горячая линия", style: TextStyle(color: cBlack, fontFamily: fontFamily, fontSize: 18),),
          trailing: Icon(Icons.call, ),
        )
      ],
    );
  }
}
