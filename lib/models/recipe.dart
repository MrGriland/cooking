import 'package:meta/meta.dart';
import 'dart:convert';

List<Recipe> recipeFromJson(String str) => List<Recipe>.from(json.decode(str).map((x) => Recipe.fromJson(x)));

String recipeToJson(List<Recipe> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Recipe {
  Recipe({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.description,
    required this.date,
    required this.deleted,
  });

  int id;
  String ownerId;
  String title;
  String description;
  DateTime date;
  bool deleted;

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
    id: json["Id"],
    ownerId: json["OwnerId"],
    title: json["Title"],
    description: json["Description"],
    date: DateTime.parse(json["Date"]),
    deleted: json["Deleted"],
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "OwnerId": ownerId,
    "Title": title,
    "Description": description,
    "Date": date.toIso8601String(),
    "Deleted": deleted,
  };
}
