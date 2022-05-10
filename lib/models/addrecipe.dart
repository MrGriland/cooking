import 'package:meta/meta.dart';
import 'dart:convert';

List<Addrecipe> AddrecipeFromJson(String str) => List<Addrecipe>.from(json.decode(str).map((x) => Addrecipe.fromJson(x)));

String AddrecipeToJson(List<Addrecipe> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Addrecipe {
  Addrecipe({
    required this.title,
    required this.description,
  });

  String title;
  String description;

  factory Addrecipe.fromJson(Map<String, dynamic> json) => Addrecipe(
    title: json["Title"],
    description: json["Description"],
  );

  Map<String, dynamic> toJson() => {
    "Title": title,
    "Description": description,
  };
}
