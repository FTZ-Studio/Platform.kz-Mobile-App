import 'package:flutter/material.dart';
import 'package:kz/models/Region.dart';

class _NewItemType {
  static String photo = "photo";
  static String text = "text";
}



class NewItem {
  bool open = false;
  String title;
  List<NewItemElement> items;
  Region region;
  String time;


  NewItem({
    @required this.items,
    @required this.title,
    this.open = false,
    this.time,
  });

  factory NewItem.fromMap(Map<String, dynamic> map) {
    return new NewItem(
      title: map['title']??"null",
      items: map['new_item'].map((i)=>NewItemElement.fromMap(i)).toList().cast<NewItemElement>() as List<NewItemElement>,
      time: map['time'],

    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'title': this.title,
      'items': this.items,
    } as Map<String, dynamic>;
  }
}

class NewItemElement {
  String type;
  String text;
  String url;

  NewItemElement({
    @required this.type,
    @required this.text,
    @required this.url,
  });

  factory NewItemElement.fromMap(Map<String, dynamic> map) {
    return new NewItemElement(
      type: map['type'] as String,
      text: map['text']??"",
      url: map['url_photo']??"",
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'type': this.type,
      'text': this.text,
      'url': this.url,
    } as Map<String, dynamic>;
  }
}