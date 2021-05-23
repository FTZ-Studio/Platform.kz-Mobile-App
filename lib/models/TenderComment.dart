import 'package:flutter/material.dart';
import 'package:kz/models/User.dart';

class TenderComment{
  final String text;
  final int id;
  final int parent;
  final User user;
  final String date;
  bool openReply;
  List<TenderComment> reply;

  TenderComment({
    @required this.text,
    this.id,
    @required this.parent,
    this.user,
    this.date,
    this.reply,
    this.openReply = false
  });

  factory TenderComment.fromMap(Map<String, dynamic> map) {
    return new TenderComment(
      text: map['text'] as String,
      id: int.parse(map['id']),
      parent: int.parse(map['parent']??"0"),
      user: User.fromMap(map['author']),
      date: map['created_at'] as String,
      reply: map['children'] == null?[]:map['children'].map((i)=> TenderComment.fromMap(i)).toList().cast<TenderComment>(),
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'text': this.text,
      'id': this.id,
      'parent': this.parent,
    } as Map<String, dynamic>;
  }
}