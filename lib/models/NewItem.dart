import 'package:flutter/material.dart';

class _NewItemType {
  static String photo = "photo";
  static String text = "text";
}



class NewItem {
  List<NewItemElement> items;
  NewItem({
    @required this.items,
  });

  factory NewItem.fromMap(Map<String, dynamic> map) {
    return new NewItem(
      items: map['items'].map((i)=>NewItem.fromMap(i)).toList().cast<NewItemElement>() as List<NewItemElement>,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
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
      url: map['url']??"",
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