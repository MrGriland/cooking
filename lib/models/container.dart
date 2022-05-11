import 'package:meta/meta.dart';
import 'dart:convert';

List<Idcontainer> IdcontainerFromJson(String str) => List<Idcontainer>.from(json.decode(str).map((x) => Idcontainer.fromJson(x)));

String IdcontainerToJson(List<Idcontainer> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

List<Datecontainer> DatecontainerFromJson(String str) => List<Datecontainer>.from(json.decode(str).map((x) => Datecontainer.fromJson(x)));

String DatecontainerToJson(List<Datecontainer> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Idcontainer {
  Idcontainer({
    required this.id,
  });

  int id;

  factory Idcontainer.fromJson(Map<String, dynamic> json) => Idcontainer(
    id: json["Id"],
  );

  Map<String, int> toJson() => {
    "Id": id,
  };
}

class Datecontainer {
  Datecontainer({
    required this.date,
  });

  String date;

  factory Datecontainer.fromJson(Map<String, dynamic> json) => Datecontainer(
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {
    "date": date,
  };
}
