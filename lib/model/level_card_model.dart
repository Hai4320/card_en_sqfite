import 'package:flutter/material.dart';

class CardLevel{
  int id;
  String name;
  Color color;
  CardLevel(this.id, this.name, this.color);

  factory CardLevel.fromMap(Map<String, dynamic> data) => CardLevel(
    data["id"], 
    data["name"], 
    Color(int.parse("0xff${data["color"]}")),
  );
}