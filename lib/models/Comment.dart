import 'package:flutter/material.dart';
import 'package:kz/models/User.dart';

class Comment {
  String text;
  int id;
  String date;
  bool anonim;
  int appeal_id;
  List<int> likes;
  List<int> dislikes;
  User author;

  Comment({
    @required this.text,
    @required this.id,
    @required this.date,
    @required this.anonim,
    @required this.appeal_id,
    @required this.likes,
    @required this.dislikes,
    this.author
  });

  factory Comment.fromMap(Map<String, dynamic> map) {
    return new Comment(
      text: map['text'] as String,
      id: map['id'] as int,
      date: map['date'] as String,
      anonim: map['anonim'] == "0"?false:true,
      appeal_id: map['appeal_id'] as int,
      likes: map['likes'].map((i)=>i).toList().cast<int>() as List<int>,
      dislikes: map['dislikes'].map((i)=>i).toList().cast<int>() as List<int>,
      author: map['anonim'] == "0"?null:User.fromMap(map['author']),
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'text': this.text,
      'id': this.id,
      'date': this.date,
      'anonim': this.anonim,
      'appeal_id': this.appeal_id,
      'likes': this.likes,
      'dislikes': this.dislikes,
      'author': this.author.toMap(),
    } as Map<String, dynamic>;
  }
}