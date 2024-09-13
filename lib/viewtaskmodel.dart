// To parse this JSON data, do
//
//     final gettasks = gettasksFromJson(jsonString);

import 'dart:convert';

Gettasks gettasksFromJson(String str) => Gettasks.fromJson(json.decode(str));

String gettasksToJson(Gettasks data) => json.encode(data.toJson());

class Gettasks {
  int code;
  bool status;
  String message;
  List<Datum> data;

  Gettasks({
    required this.code,
    required this.status,
    required this.message,
    required this.data,
  });

  factory Gettasks.fromJson(Map<String, dynamic> json) => Gettasks(
    code: json["code"],
    status: json["status"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  int id;
  String title;
  String description;
  int status;

  Datum({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "status": status,
  };
}
