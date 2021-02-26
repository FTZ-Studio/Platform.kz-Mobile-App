import 'package:flutter/material.dart';
import 'package:kz/models/Address.dart';
import 'package:kz/models/Categories.dart';
import 'package:kz/models/Comment.dart';
import 'package:kz/models/User.dart';

class Appeal {
  int id;
  String comment;
  List<String> photos;
  Address address;
  CategoryChild category;
  bool anonim;
  int status;
  String organ;
  String date;
  User user;
  List<Comment> comments;

  Appeal({
    this.id,
    @required this.comment,
    @required this.photos,
    @required this.address,
    this.category,
    @required this.anonim,
    this.status,
    this.organ,
    this.date,
    this.user,
    this.comments,
  });

  factory Appeal.fromMap(Map<String, dynamic> map) {
    return new Appeal(
      id: map['id'] as int,
      comment: map['comment'] as String,
      photos: map['photos'].map((i) => i).toList().cast<String>() as List<String>,
      address: map['address'] == null?null:Address.fromMap(map['address']),
      category: CategoryChild.fromMap(map['category']),
      anonim: map['anonim']== "0"?false:true,
      status: map['status'] == null?null:int.parse(map['status']),
      organ: map['organ'] as String,
      date: map['date'] as String,
      user: map['anonim'] == "0"?null:User.fromMap(map['user']),
      comments: map['comments'] == null?[]:map['comments'].map((i)=> Comment.fromMap(i)).toList().cast<Comment>() as List<Comment>,
    );
  }

  Map<String, dynamic> toMap() {
    //todo
    // ignore: unnecessary_cast
    return {
      'id': this.id,
      'comment': this.comment,
      'photos': this.photos,
      'address': this.address.toMap(),
      'category': this.category.id,
      'anonim': this.anonim,
    } as Map<String, dynamic>;
  }
}