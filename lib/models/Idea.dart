import 'package:flutter/cupertino.dart';
import 'package:kz/models/User.dart';

class Idea {
  final int id;
  final String text;
  final String title;
  final String date;
  final User user;
  final int status;
  final List<String> photo;

  Idea({
    this.id,
    @required this.text,
    this.date,
    this.user,
    this.status,
    this.photo,
    this.title
  });

  factory Idea.fromMap(Map<String, dynamic> map) {
    return new Idea(
      id: int.parse(map['id']) ,
      text: map['text'] as String,
      date: map['time']??"01.01.2021 12:12:12",
      user: User.fromMap(map['author']),
      status: int.parse(map['status']),
      photo: map['photos']== null?[]:map['photos'].map((i) => i).toList().cast<String>() as List<String>,
      title: map['title']??""
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'id': this.id,
      'text': this.text,
      'date': this.date,
      'user': this.user,
      'photos': this.photo,
    } as Map<String, dynamic>;
  }
}