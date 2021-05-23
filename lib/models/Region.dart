import 'package:flutter/material.dart';

class Region{
  String name;
  int id;

  Region({
    @required this.name,
    @required this.id,
  });

  factory Region.fromMap(Map<String, dynamic> map) {
    return new Region(
      name: map['name'] as String,
      id: int.parse(map['id']),
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'name': this.name,
      'id': this.id,
    } as Map<String, dynamic>;
  }
}