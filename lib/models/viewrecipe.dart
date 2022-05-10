// To parse this JSON data, do
//
//     final viewrecipe = viewrecipeFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<Viewrecipe> viewrecipeFromJson(String str) => List<Viewrecipe>.from(json.decode(str).map((x) => Viewrecipe.fromJson(x)));

String viewrecipeToJson(List<Viewrecipe> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Viewrecipe {
  Viewrecipe({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.isFavorite,
  });

  int id;
  String title;
  String description;
  DateTime date;
  bool isFavorite;

  factory Viewrecipe.fromJson(Map<String, dynamic> json) => Viewrecipe(
    id: json["Id"],
    title: json["Title"],
    description: json["Description"],
    date: DateTime.parse(json["Date"]),
    isFavorite: json["isFavorite"],
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Title": title,
    "Description": description,
    "Date": date.toIso8601String(),
    "isFavorite": isFavorite,
  };
}
