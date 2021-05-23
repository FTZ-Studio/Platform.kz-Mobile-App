import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

part 'IconData.dart';

Widget IconSvg(int id,{ Color color, double width, double height, bool nullColor}){

  String icon (String name, {bool active, bool check}){
    String path = "assets/images/";
    if(active != null)path="lib/assets/icons/active/";
    if(check != null)path="lib/assets/icons/checkBox/";
    String ex = ".svg";
    return path+name+ex;
  }

  String iconName;

  int count = 19;
  if(id < 0||id >= count)id=0;

  switch(id) {
    case 0: iconName =icon('document'); break;
    case 1: iconName =icon('lamp'); break;
    case 2: iconName =icon('latter_arrow'); break;
    case 3: iconName =icon('letter'); break;
    case 4: iconName =icon('lock'); break;
    case 5: iconName =icon('menu'); break;
    case 6: iconName =icon('message'); break;
    case 7: iconName =icon('notif'); break;
    case 8: iconName =icon('person'); break;
    case 9: iconName =icon('trands'); break;
    case 10: iconName =icon('warn'); break;
    case 11: iconName =icon('back'); break;
    case 12: iconName =icon('marker'); break;
    case 13: iconName =icon('phone'); break;
    case 14: iconName =icon('vk'); break;
    case 15: iconName =icon('uploadPhoto'); break;
    case 16: iconName =icon('bag'); break;
    case 17: iconName =icon('comment'); break;
    case 18: iconName =icon('send'); break;
    default: iconName = icon('lamp'); break;
  }



  final String assetName = iconName;
  final  Widget svg =

  SvgPicture.asset(
      assetName,
      height: height,
      width: width,
      color: color,
      semanticsLabel: 'Acme Logo'
  );

  return svg;

}