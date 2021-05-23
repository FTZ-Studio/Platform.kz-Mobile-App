import 'package:flutter/material.dart';

class Category {
  int id;
  String name;
  List<CategoryChild> children;

  Category({
    @required this.id,
    @required this.name,
    @required this.children,
  });

  factory Category.fromMap(Map<String, dynamic> map) {
    return new Category(
      id: int.parse(map['id']),
      name: map['name'] as String,
      children: map['children'].map((i)=>CategoryChild.fromMap(i)).toList().cast<CategoryChild>() as List<CategoryChild>,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'id': this.id,
      'name': this.name,
      'children': this.children.map((e) => e.toMap()).toList(),
    } as Map<String, dynamic>;
  }
}

class CategoryChild {
  int id;
  String name;
  int parent;

  CategoryChild({
    @required this.id,
    @required this.name,
    @required this.parent,
  });

  factory CategoryChild.fromMap(Map<String, dynamic> map) {
    return new CategoryChild(
      id: int.parse(map['id']),
      name: map['name'] as String,
      parent: int.parse(map['parent']),
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'id': this.id,
      'name': this.name,
      'parent': this.parent,
    } as Map<String, dynamic>;
  }
}