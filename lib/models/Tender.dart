import 'package:flutter/material.dart';
import 'package:kz/models/TenderComment.dart';

class Tender{
  final String title;
  final String text;
  final String date;
  final List<String> photos;
  final List<TenderComment> comments;
  final int id;
  bool openComments;

  Tender({
    @required this.title,
    @required this.text,
    @required this.date,
    @required this.photos,
    @required this.comments,
    @required this.id,
    this.openComments = false
  });

  factory Tender.fromMap(Map<String, dynamic> map) {
    return new Tender(
      title: map['header'] as String,
      text: map['text'] as String,
      date: map['created_at'] as String,
      photos: map['photos'] == null?[]:map['photos'].map((i)=> i).toList().cast<String>(),
      comments: map['comments'] == null?null:map['comments'].map((i)=> TenderComment.fromMap(i)).toList().cast<TenderComment>(),
      id: int.parse(map['id']),
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'title': this.title,
      'text': this.text,
      'date': this.date,
      'photos': this.photos,
      'comments': this.comments,
      'id': this.id,
    } as Map<String, dynamic>;
  }
}